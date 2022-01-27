#!/usr/bin/env python
# coding: utf-8

import pandas as pd
import numpy as np
import torch
from torch.utils.data import Dataset
import matplotlib.pyplot as plt
from torchvision import transforms, utils
import torch.nn as nn
from PIL import Image
import copy
import os


class CustomDataSet(Dataset):
    def __init__(self, csv_path, root_dir, transform=None):
        """
        Params:
            csv_path (str): path to the csv file containing images paths and labels
            root_dir (str): path to the folder containing the images
            transform (callable, optional): optional transformation to the data
        """
        data = pd.read_csv(csv_path)
        
        self.img_path = np.array(data['Paths'],str)
        self.label = np.array(data['Label'],int)
        
        self.root_dir = root_dir
        self.transform = transform

    def __len__(self):
        return len(self.img_path)
                         
    
    # def to_one_hot(y):
    #     return torch.eye(len(set(y)))[y]
    
    def __getitem__(self, idx):
        """
        This methods loads the next sample form the dataset using the name of the image from the
        dataset. The image is loaded as PIL image and then converted into RGB as there are different
        types of formats in the images, this allows us to treat them all equally.
        """
        if torch.is_tensor(idx):
            idx = idx.tolist()
        
        # Creates path to the images from working directory, in this case 
        # e.g.: .\Eyes_DataSet\Data\s001_0001_0_0_0_0_0_01.png 
        img_name = os.path.join(self.root_dir, self.img_path[idx])
        img = Image.open(img_name)
        img = img.convert('RGB') # Converts to RGB values the image
        label = self.label[idx]
        
        sample = {'image': img, 'label': label}
        
        if self.transform:
            sample['image'] = self.transform(sample['image'])
            
        return sample
    
           
def image_grid(imgs, rows, cols, dims=(64,64)):
    """
    Params:
        imgs (list of PIL images): Images to be printed
        rows (int): rows of the grid
        cols (int): cols of the grid
        dims (tuple): dimensions of the images to be displayed    
        
    Output:
        grid (grid): returns a grid with the images
    """
    assert len(imgs) == rows*cols, 'Unable to display images with a grid of those dimensions'
    
    w, h = dims
    grid = Image.new('RGB',size=(cols*w, rows*h))
    grid_w, grid_h = grid.size
    
    for i, img in enumerate(imgs):
        grid.paste(img, box= (i%cols*w+1, i//cols*h+1))
    
    return grid

def binary_acc(y_pred, y_test):
    correct_results = 0
    for i in range(len(y_pred)):
        temp = round(y_pred[i].item())
        if temp == y_test[i]:
            correct_results += 1
    
    return correct_results 

# Get learning rate from optimizer
def get_lr(opt):
    for param_group in opt.param_groups:
        return param_group['lr']

# Compute loss and metric over one batch
def loss_batch(loss_fn, output, target, opt=None):
    # Get loss
    loss = loss_fn(output, target)
    metric_b = binary_acc(output, target)
    
    if opt is not None:
        opt.zero_grad()
        loss.backward()
        opt.step()
    
    return loss.item(), metric_b
        
    
# Compute loss and metric over one epoch
def loss_epoch(model, loss_fn, data_ld, check=False, opt=None):
    run_loss = 0.0
    t_metric = 0.0
    len_data = len(data_ld.dataset)
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    
    ## Internal Loop ##
    for sample in data_ld:
        data = sample['image'].to(device)
        label = sample['label'].to(device).type(torch.FloatTensor)
        
        # Forward Pass
        output = model(data)
        # Apply Sigmoid for training and validation
        sigmoid = nn.Sigmoid()
        output = sigmoid(output)
        
        loss_b, metric_b = loss_batch(loss_fn, output, label, opt) # Loss per batch
        run_loss += loss_b # Update running loss
        
        if metric_b is not None: # Update running metric
            t_metric += metric_b            
        
        # Break of the loop in case of sanity check
        if check:
            break
            
    loss = run_loss / float(len_data) # Avg. loss value
    metric = t_metric / float(len_data) # Avg. metric value
    
    return loss, metric


# Train the model
def fit(model, params, verbose=False):
    # Get training parameters
    epochs=params["epochs"]
    loss_fn=params["loss_fn"]
    opt=params["optimiser"]
    train_ld=params["train"]
    val_ld=params["val"]
    check=params["check"]
    lr_scheduler=params["lr_change"]
    weight_path=params["weight_path"]
    
    loss_history = {'train': [], 'val': []} # History of loss values each epoch
    metric_history = {'train': [], 'val': []} # History of metric values each epoch
    
    best_model_wts = copy.deepcopy(model.state_dict()) # Deep copy of the weights for best performing model
    best_loss = float('inf') # Initialize best loss to a large value
    
    ### MAIN LOOP ###
    for e in range(epochs):
        
        ### Get learning rate ###
        current_lr = get_lr(opt)
        if verbose:
            print('Epoch {e}/{epochs-1}, current lr={current_lr}')
            
        ### Train Model ###
        model.train()
        train_loss, train_metric = loss_epoch(model, loss_fn, train_ld, check, opt)
        
        ### Collect loss and metric for the training set ###
        loss_history["train"].append(train_loss)
        metric_history["train"].append(train_metric)
        
        ### Evaluate Model ###
        model.eval()
        with torch.no_grad():
            val_loss, val_metric = loss_epoch(model, loss_fn, val_ld, check)
            
        ### Store best model ###
        if val_loss < best_loss:
            best_loss = val_loss
            best_model_wts = copy.deepcopy(model.state_dict())
            
            # Store weights into local file
            torch.save(model.state_dict(), weight_path)
            if verbose:
                print('Copied best model weights in Epoch: ', e)
                
        ### Collect loss and metric for the validation set ###
        loss_history["val"].append(val_loss)
        metric_history["val"].append(val_metric)
                
        ### Learning rate scheduler ###
        lr_scheduler.step(val_loss)
        if current_lr != get_lr(opt):
            if verbose:
                print('Loading best model weights!')
            model.load_state_dict(best_model_wts)
            
        if verbose:
            print(f'train loss: {train_loss:.6f}, val loss: {val_loss:.6f}, accuracy: {100*val_metric:.2f}')
            print('-'*10)
            
    # Load best model weights
    model.load_state_dict(best_model_wts)
    
    return model, loss_history, metric_history


# Return trainable params
def get_train_params(train_loader,val_loader,epochs,optimiser,lr_change,loss_fn,weight_path='weights.pt',check=True):
    """
    Output:
        params_train(dic): trainable parameters for the loop
    Example:
        params_train = {'train': train_loader,
                'val': val_loader,
                'epochs': 20,
                'optimiser': torch.optim.Adam(model.parameters(), lr = L_RATE),
                'lr_change': torch.optim.lr_scheduler.ReduceLROnPlateau(optimiser, mode='min',factor=0.5, patience=20,verbose=0),
                'loss_fn': nn.BCELoss(),
                'weight_path': 'weights.pt',
                'check': True}  
    """
    params_train = {'train': train_loader,
                     'val': val_loader,
                     'epochs': epochs,
                     'optimiser': optimiser,
                     'lr_change': lr_change,
                     'loss_fn': loss_fn,
                     'weight_path': weight_path,
                     'check': check}
    return params_train



