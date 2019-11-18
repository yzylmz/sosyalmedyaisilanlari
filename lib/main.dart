import 'package:flutter/material.dart';
import 'package:sosyalmedyaisilanlari/ui/views/HomeView.dart';
import 'package:sosyalmedyaisilanlari/ui/views/login_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: LoginPage()
    );
  }
}
