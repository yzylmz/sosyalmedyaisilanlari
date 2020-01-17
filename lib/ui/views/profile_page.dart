import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  logOut() {
    FirebaseAuth.instance.signOut();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<QuerySnapshot> _myJobsStream;

  final databaseReference = Firestore.instance;

  static int scrollCount = 10;

  bool progressState = false;

  ScrollController _scrollController = ScrollController();

  getUserJobs() async {
    var _user = await _firebaseAuth.currentUser();

    _myJobsStream = Firestore.instance
        .collection('job')
        .where("senderuid", isEqualTo:_user.uid )
        .orderBy('createdDate', descending: true)
        .limit(scrollCount)
        .snapshots();
  }

  void initState() {
    super.initState();
    getUserJobs();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        progressState = true;
        _loadMore();
      }
    });
  }

  _loadMore() {
    int countDoc = Firestore.instance.collection('job').toString().length;

    if (scrollCount < countDoc) {
      setState(() {
        scrollCount += 10;
        getUserJobs();
      });
      progressState = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                logOut();
              },
            ),
          ],
          backgroundColor: Colors.purple,
          title: Text(
            "Profil",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: StreamBuilder(
            stream: _myJobsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return new Text('Loading...');
              if (progressState) {
                return new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[CircularProgressIndicator()],
                );
              }
              return new ListView(
                controller: _scrollController,
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
      ),
    );
  }
}
