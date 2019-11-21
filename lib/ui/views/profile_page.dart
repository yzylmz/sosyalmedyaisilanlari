import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  logOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.exit_to_app),
              
              onPressed: logOut(),
            ),
          ],
          backgroundColor: Colors.purple,
          title: Text(
            "Profil",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
