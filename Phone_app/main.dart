import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/main_screen.dart';
import './screens/tabs_screen.dart';
import './models/auth.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            bodyText2: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        home: TabsScreen(),
        routes: {
          MainScreen.routeName: (ctx) => MainScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
        },
      ),
    );
  }
}
