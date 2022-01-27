import 'dart:math';

import 'package:flutter/material.dart';

class ContactItem extends StatefulWidget {
  final String title;
  final List list;
  final Function removeContact;

  ContactItem(this.title, this.list, this.removeContact);

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(
          _expanded ? Icons.expand_less : Icons.expand_more,
          color: Colors.white,
        ),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            height: min(widget.list.length * 20.0 + 40, 100),
            child: widget.list.isEmpty
                ? const Center(
                    child: Text('No emergency contacts'),
                  )
                : ListView(
                    children: widget.list
                        .map(
                          (contact) => Dismissible(
                            key: ValueKey(contact.phoneNumber),
                            background: Container(
                              color: Theme.of(context).errorColor,
                              child: Text(
                                'delete',
                                style: TextStyle(color: Colors.white),
                              ),
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              //margin: EdgeInsets.symmetric(
                              //  horizontal: 15,
                              //  vertical: 4,
                              //),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              widget.removeContact(contact.phoneNumber);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  contact.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  contact.phoneNumber,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
        onExpansionChanged: (bool expanded) {
          setState(() => _expanded = expanded);
        },
      ),
    );
  }
}
