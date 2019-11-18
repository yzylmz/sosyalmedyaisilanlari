import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosyalmedyaisilanlari/ui/views/login_page.dart';

class SignPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final formKey = new GlobalKey<FormState>();

  // String _name;
  // String _surname;
  String _email;
  String _password;
  String _errorMessage = "";
  bool _loading = false;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() => _loading = true);
    if (validateAndSave()) {
      try {
        AuthResult myAuthResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = myAuthResult.user;
        print('signed in : ${user.uid}');

        if (myAuthResult.user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } catch (error) {
        if (error.code == "ERROR_EMAIL_ALREADY_IN_USE") {
          setState(() => _errorMessage = "Bu email kullanılıyor!");
        } else {
          setState(() => _errorMessage = "Kullanıcı adı veya şifreyi kontrol edin!");
        }
      }
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.purple,
        title: new Text('Kayıt Ol'),
      ),
      body: new Container(
          padding: EdgeInsets.all(16.0),
          child: _loading
              ? new Center(child: CircularProgressIndicator())
              : new Form(
                  key: formKey,
                  child: new SingleChildScrollView(
                    child: new Column(
                      children: <Widget>[
                        new TextFormField(
                          onChanged: (text) {
                            validateAndSave();
                          },
                          decoration: new InputDecoration(labelText: 'Email'),
                          validator: (value) =>
                              value.isEmpty ? 'Email boş geçilemez.' : null,
                          onSaved: (value) => _email = value,
                        ),
                        new TextFormField(
                          onChanged: (text) {
                            validateAndSave();
                          },
                          decoration: new InputDecoration(labelText: 'Şifre'),
                          obscureText: true,
                          validator: (value) =>
                              value.isEmpty ? 'Şifre boş geçilemez.' : null,
                          onSaved: (value) => _password = value,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        new RaisedButton(
                          child: Text('Kayıt Ol'),
                          onPressed: validateAndSubmit,
                        ),
                        new FlatButton(
                          child: Text('Giriş Yap'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                )),
    );
  }
}
