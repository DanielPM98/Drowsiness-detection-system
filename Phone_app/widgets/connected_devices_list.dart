import 'package:flutter/material.dart';

class ConnectedDevicesList extends StatelessWidget {
  final List devices;

  ConnectedDevicesList(this.devices);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 80,
      child: devices.isEmpty
          ? Center(
              child: Text('No emergency contacts'),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      devices[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      devices[index],
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              },
              itemCount: devices.length,
            ),
    );
  }
}
