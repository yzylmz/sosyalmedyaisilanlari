import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sosyalmedyaisilanlari/ui/views/create_job.dart';
import 'package:sosyalmedyaisilanlari/ui/views/login_page.dart';

class HomeView extends StatefulWidget {
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final databaseReference = Firestore.instance;

  int _currentIndex = 0;
  Stream<QuerySnapshot> _jobStream =
      Firestore.instance.collection('job').orderBy('createdDate', descending: true).snapshots();

  getJobs() {
    databaseReference
        .collection("ilanlar")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateJobPage()),
      );
    } else if (index == 2) {}
  }

  void gotoLoginPage() {
    Navigator.of(context).pop(true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Emin misin?'),
            content: new Text('Uygulamadan çıkış yapmak istiyor musun?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Hayır'),
              ),
              new FlatButton(
                onPressed: () => gotoLoginPage(),
                child: new Text('Evet'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document['title']),
      subtitle: Text(document['body']),
    );
  }

  // Future<void> refresh() {
  //   refreshData();
  //   return Future.value();
  // }

  // void initState() {
  //   super.initState();
  //   _jobStream = refreshData();
  // }

  refreshData() {
    return Firestore.instance.collection('job').orderBy('createdDate', descending: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.purple,
              title: Text(
                "İş İlanları",
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Center(
              child: StreamBuilder(
                  stream: _jobStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return new Text('Loading...');
                    return new ListView(
                      children: snapshot.data.documents.map((document) {
                        return Center(
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://bussplus.blob.core.windows.net/bussplusmain/0a6b764a_default_profile_image.png"),
                                  ),
                                  title: Text(document['title']),
                                  subtitle: Text(document['explanation']),
                                ),
                                ButtonTheme.bar(
                                  // make buttons use the appropriate styles for cards
                                  child: ButtonBar(
                                    children: <Widget>[
                                      FlatButton(
                                        child: const Text('Beğen'),
                                        onPressed: () {/* ... */},
                                      ),
                                      FlatButton(
                                        child: const Text('Yorum Yap'),
                                        onPressed: () {/* ... */},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ));
  }
}
