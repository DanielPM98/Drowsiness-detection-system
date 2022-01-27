import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:firebase_storage/firebase_storage.dart';

import './auth_screen.dart';
import '../models/auth.dart';
import '../widgets/badge.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _storedImage;

  Future<void> _getPicture(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile image = await _picker.pickImage(
      source: source,
      maxWidth: 600,
    );
    //final imageFile = File(image.path);
    //if (imageFile == null) {
    //  return;
    //}
    //setState(() {
    //  _storedImage = imageFile;
    //});
    //final ref =
    //    FirebaseStorage.instance.ref().child('user_image').child('user.jpg');
    //ref.putFile(imageFile);
    //final appDir = await syspaths.getApplicationDocumentsDirectory();
    //final fileName = path.basename(imageFile.path);
    //final savedImage = await imageFile.copy('${appDir.path}/$fileName');
  }

  void _startAddProfilePicture(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            height: 100,
            child: Column(
              children: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    _getPicture(ImageSource.camera);
                  },
                  icon: Icon(Icons.photo_camera),
                  label: Text('Take picture'),
                ),
                TextButton.icon(
                  onPressed: () {
                    _getPicture(ImageSource.gallery);
                  },
                  icon: Icon(Icons.camera_roll),
                  label: Text('Select from camera roll'),
                ),
              ],
            ),
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/profile_background.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          Card(
            margin: const EdgeInsets.all(10),
            color: Colors.white54,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Consumer<Auth>(
                builder: (ctx, auth, _) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        auth.isAuth
                            ? Badge(
                                color: Colors.white,
                                value: IconButton(
                                  onPressed: () {
                                    _startAddProfilePicture(context);
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                child: const Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: //auth.isAuth
                                            //? //_storedImage == null
                                            //? const AssetImage(
                                            //'assets/images/perfil_en_blanco.png')
                                            //: _storedImage
                                            AssetImage(
                                                'assets/images/profile.jpeg')
                                        //: const AssetImage(
                                        //    'assets/images/perfil_en_blanco.png')),
                                        ),
                                  ),
                                ),
                              )
                            : Badge(
                                color: Colors.white,
                                value: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                  ),
                                ),
                                child: const Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: //auth.isAuth
                                            //? //_storedImage == null
                                            //? const AssetImage(
                                            //'assets/images/perfil_en_blanco.png')
                                            //: _storedImage
                                            AssetImage(
                                                'assets/images/perfil_en_blanco.png')
                                        //: const AssetImage(
                                        //    'assets/images/perfil_en_blanco.png')),
                                        ),
                                  ),
                                ),
                              ),
                        auth.isAuth
                            ? const Text(
                                'RebecaGR',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              )
                            : const Text(
                                'User Name',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        auth.isAuth
                            ? auth.logout()
                            : Navigator.of(context)
                                .pushNamed(AuthScreen.routeName);
                      },
                      child: auth.isAuth
                          ? const Text('Logout')
                          : const Text('Signup / Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            color: Colors.white54,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Settings',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
