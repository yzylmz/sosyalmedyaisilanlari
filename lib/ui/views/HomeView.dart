import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatefulWidget {
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final databaseReference = Firestore.instance;

  static int scrollCount = 10;
  bool progressState = false;

  ScrollController _scrollController = ScrollController();

  Stream<QuerySnapshot> _jobStream = Firestore.instance
      .collection('job')
      .orderBy('createdDate', descending: true)
      .limit(scrollCount)
      .snapshots();

  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        progressState = true;
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _loadMore() {
    int countDoc = Firestore.instance.collection('job').toString().length;

    if (scrollCount < countDoc) {
      setState(() {
        scrollCount += 10;
        _jobStream = Firestore.instance
            .collection('job')
            .orderBy('createdDate', descending: true)
            .limit(scrollCount)
            .snapshots();
        progressState = false;
      });
    }
  }

  void gotoLoginPage() {
    Navigator.of(context).pop(true);
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

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.amber[500],
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
        ));
  }
}
