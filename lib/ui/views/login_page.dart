import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosyalmedyaisilanlari/ui/views/HomeView.dart';
import 'package:sosyalmedyaisilanlari/ui/views/main_page.dart';
import 'package:sosyalmedyaisilanlari/ui/views/register_view.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  bool _loading = false;
  String _errorMessage = "";

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // void validateAndSubmit() async {
  //   if (validateAndSave()) {
  //     AuthResult myAuthResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email,password: _password);
  //     FirebaseUser user = myAuthResult.user;
  //     print('signed in : ${user.uid}');
  //   }
  // }

  void validateAndSubmit() async {
    setState(() => _loading = true);
    if (validateAndSave()) {
      try {
        AuthResult myAuthResult = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = myAuthResult.user;
        print('login : ${user.uid}');

        if (myAuthResult.user != null) {
          setState(() => _loading = false);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        }
      } catch (error) {
        if (error.code == "ERROR_EMAIL_ALREADY_IN_USE") {
          setState(() => _errorMessage = "Bu email kullanılıyor!");
        } else {
          setState(
              () => _errorMessage = "Kullanıcı adı veya şifreyi hatalı!");
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
        automaticallyImplyLeading: false,
        title: new Text('Giriş Yap'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: _loading
            ? new Center(child: CircularProgressIndicator())
            : new Form(
                key: formKey,
                child: new SingleChildScrollView( 
                  child : new Column(
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
                      decoration: new InputDecoration(labelText: 'Password'),
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
                      child: Text('Giriş Yap'),
                      onPressed: validateAndSubmit,
                    ),
                    new FlatButton(
                      child: Text('Kayıt Ol'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignPage()),
                        );
                      },
                    )
                  ],
                ),)
              ),
      ),
    );
  }
}
