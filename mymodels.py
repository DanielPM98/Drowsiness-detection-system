#!/usr/bin/env python
# coding: utf-8

import torch
import torch.nn as nn
import numpy as np


def conv_out_dims(hin,win,conv,pool=2):
    # Get Conv parameters
    kernel_size=conv.kernel_size
    stride=conv.stride
    padding=conv.padding
    dilation=conv.dilation

    hout=np.floor((hin+2*padding[0]-dilation[0]*(kernel_size[0]-1)-1)/stride[0]+1)
    wout=np.floor((win+2*padding[1]-dilation[1]*(kernel_size[1]-1)-1)/stride[1]+1)

    if pool:
        hout/=pool
        wout/=pool
        
    return int(hout),int(wout)

# Convolutional Network for image classification
class Network(nn.Module):
    def __init__(self, params):
        super(Network, self).__init__()
        
        C_in, H_in, W_in = params['shape']
        init_f = params['initial_filters']
        num_fc1 = params['num_fc1']
        num_classes = params['num_classes']
        self.dropout_rate = params['dropout_rate']
        
        # Define CNN architecture
        self.conv1 = nn.Conv2d(C_in, init_f, kernel_size=3)
        h, w = conv_out_dims(H_in, W_in, self.conv1)
        
        self.conv2 = nn.Conv2d(init_f, 2*init_f, kernel_size=3)
        h, w= conv_out_dims(h, w, self.conv2)
        
        self.conv3 = nn.Conv2d(2*init_f, 4*init_f, kernel_size=3)
        h, w = conv_out_dims(h, w, self.conv3)
        
        self.conv4 = nn.Conv2d(4*init_f, 8*init_f, kernel_size=3)
        h, w = conv_out_dims(h, w, self.conv4)
        
        # Flatten layer
        self.flatten = nn.Flatten(start_dim=1)
        
        # Hidden layers
        self.num_flatten = h*w*8*init_f
        self.fc1 = nn.Linear(self.num_flatten, num_fc1)
        self.fc2 = nn.Linear(num_fc1, num_classes)
        
        # Special layers
        self.pool = nn.MaxPool2d(2)
        self.dropout = nn.Dropout(self.dropout_rate)
        self.relu = nn.ReLU()
        self.sigmoid = nn.Sigmoid()
        
    def forward(self,x):
        # CNN layers
        x = self.pool(self.relu(self.conv1(x)))
        x = self.pool(self.relu(self.conv2(x)))
        x = self.pool(self.relu(self.conv3(x)))
        x = self.pool(self.relu(self.conv4(x)))
        
        # Flatten
        x = self.flatten(x)
        
        # Fully connected layers
        x = self.relu(self.fc1(x))
        x = self.dropout(x)
        x = self.fc2(x)
        
        # Last activation function before output
        #out = self.sigmoid(x)
        out = x
        
        return out
    
# Get Neuronal networ parameters
def get_network_params(cnn=False):
    if cnn:
        params_model = {'shape': (3,64,64),
                        'initial_filters': 8,
                        'num_fc1': 100,
                        'dropout_rate': 0.25,
                        'num_classes': 1}
    else:
        params_model = {'shape': (0,0,0),
                        'initial_filters': 0,
                        'num_fc1': 0,
                        'dropout_rate': 0.0,
                        'num_classes': 0}
        
    return params_model
            






