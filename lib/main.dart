import 'package:flutter/material.dart';
import 'package:sosyalmedyaisilanlari/ui/views/root_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: RootPage()
    );
  }
}
