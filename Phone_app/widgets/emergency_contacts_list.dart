import 'package:flutter/material.dart';

import '../models/contact.dart';

class EmergencyContactsList extends StatelessWidget {
  final List contacts;

  EmergencyContactsList(this.contacts);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: contacts
          .map(
            (contact) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  contact.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  contact.phoneNumber,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          )
          .toList(),
    );
  }
}
