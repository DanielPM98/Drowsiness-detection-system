import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewEmergencyContact extends StatefulWidget {
  final Function addContact;

  NewEmergencyContact(this.addContact);

  @override
  _NewEmergencyContactState createState() => _NewEmergencyContactState();
}

class _NewEmergencyContactState extends State<NewEmergencyContact> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  void submitData() {
    final enteredName = nameController.text;
    final enteredPhone = phoneController.text;

    if (enteredName.isEmpty || enteredPhone.isEmpty) {
      return;
    }

    widget.addContact(
      enteredName,
      enteredPhone,
    );

    Navigator.of(context).pop(); // closes the slide-window
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: nameController,
                onSubmitted: (_) {},
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Phone number'),
                controller: phoneController,
                onSubmitted: (_) {},
              ),
              //TextButton(
              //onPressed: () {},
              //child: Text('Add from contact list'),
              //),
              ElevatedButton(
                onPressed: submitData,
                child: Text('Save contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
