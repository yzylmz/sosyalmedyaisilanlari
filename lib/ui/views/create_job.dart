import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateJobPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  final formKey = new GlobalKey<FormState>();
  final databaseReference = Firestore.instance;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _title;
  String _explanation;
  String _senderuid;
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

  getCurrentUser() async {
    var _user = await _firebaseAuth.currentUser();
    _senderuid= _user.uid;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void _successfullyAddedAlert() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("İlan Eklendi"),
              content: Text("İlan başarılı şekilde kaydedildi."),
              actions: <Widget>[
                FlatButton(
                  child: Text('Tamam'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _errorAddedAlert() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("İlan Eklenemedi"),
              content: Text("Lütfen başlık ve açıklamayı kontrol edin!"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Tamam'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void validateAndSubmit() async {
    setState(() => _loading = true);
    if (validateAndSave()) {
      try {
       
        await databaseReference.collection("job").add({
          "title": _title,
          "explanation": _explanation,
          "createdDate": DateTime.now(),
          "senderuid": _senderuid
        });
        _successfullyAddedAlert();
      } catch (error) {
        _errorAddedAlert();
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
        title: new Text('İş İlanı Ekle'),
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Başlık",
                            style: new TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )),
                      ),
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: new TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 1,
                            onChanged: (text) {
                              validateAndSave();
                            },
                            decoration: new InputDecoration(
                                hintText: 'İlan Başlığı',
                                border: OutlineInputBorder()),
                            validator: (value) =>
                                value.isEmpty ? 'Başlık boş geçilemez.' : null,
                            onSaved: (value) => _title = value,
                          )),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Açıklama",
                            style: new TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )),
                      ),
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: new TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 7,
                            onChanged: (text) {
                              validateAndSave();
                            },
                            decoration: new InputDecoration(
                                hintText: 'İlan Açıklaması',
                                border: OutlineInputBorder()),
                            validator: (value) => value.isEmpty
                                ? 'Açıklama boş geçilemez.'
                                : null,
                            onSaved: (value) => _explanation = value,
                          )),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      new RaisedButton(
                        child: Text('Ekle'),
                        onPressed: validateAndSubmit,
                      ),
                    ],
                  ),
                )),
      ),
    );
  }
}
