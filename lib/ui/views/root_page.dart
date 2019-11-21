import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sosyalmedyaisilanlari/main.dart';
import 'package:sosyalmedyaisilanlari/ui/views/login_page.dart';
import 'package:sosyalmedyaisilanlari/ui/views/main_page.dart';

import 'HomeView.dart';
import 'create_job.dart';
import 'landing_page.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _rootPageState();
}

class _rootPageState extends State<RootPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Duration duration = const Duration(seconds: 2);

  startTimeout() {
    return new Timer(duration, handleTimeout);
  }

  handleTimeout() {
    checkUserAuth();
  }

  Widget _rootWidget = LandingPage();

  checkUserAuth() async {
    var _user = await _firebaseAuth.currentUser();
    if (_user != null) {
      setState(() {
      _rootWidget = MainPage();
    });
      
    } else {
      setState(() {
      _rootWidget = LoginPage();
    });
    }
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        body: _rootWidget,
      ),
    );
  }
}
