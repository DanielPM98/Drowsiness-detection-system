import 'package:flutter/material.dart';

import '../widgets/new_emergency_contact.dart';
import '../models/contact.dart';
import '../widgets/contact_item.dart';
import '../widgets/connected_device_item.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main-screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _activateBluetooth = false;
  var _activateContacts = false;

  final List _userContacts = [];
  final List _connectedDevices = [];

  void _startAddNewEmergencyContact(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          child: NewEmergencyContact(_addNewEmergencyContact),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addNewEmergencyContact(String name, String number) {
    final newContact = EmergencyContact(
      name: name,
      phoneNumber: number,
    );

    setState(() {
      _userContacts.add(newContact);
    });
  }

  void _removeEmergencyContact(String number) {
    setState(() {
      _userContacts.removeWhere((contact) => contact.phoneNumber == number);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Card(
              color: Colors.black54,
              margin: EdgeInsets.all(10),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Link device',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Switch(
                        value: _activateBluetooth,
                        onChanged: (bool newValue) {
                          setState(() {
                            _activateBluetooth = newValue;
                          });
                        })
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
            ),
            ConnectedDeviceItem('Linked devices:', _connectedDevices),
            SizedBox(
              height: 80,
            ),
            Card(
              color: Colors.black54,
              margin: EdgeInsets.all(10),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: <Widget>[
                        Text(
                          'Activate alerts',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Switch(
                            value: _activateContacts,
                            onChanged: (bool newValue) {
                              setState(() {
                                _activateContacts = newValue;
                              });
                            })
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    Text(
                      'Activate this option to alert selected contacts via sms in case of an emergency',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    TextButton(
                      onPressed: () => _startAddNewEmergencyContact(context),
                      child: Text('Add emergency contact'),
                    ),
                  ],
                ),
              ),
            ),
            ContactItem(
                'Emergency contacts:', _userContacts, _removeEmergencyContact),
          ],
        ),
      ),
    );
  }
}
