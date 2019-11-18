import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sosyalmedyaisilanlari/main.dart';

import 'HomeView.dart';
import 'create_job.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _mainPageState();
}

class _mainPageState extends State<MainPage> {
  
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget navWidget(){
    if (_currentIndex == 0) {
      return  new HomeView();
    } else if (_currentIndex == 1) {
      return  CreateJobPage();
    } else if (_currentIndex == 2) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        body: navWidget(),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: onTabTapped, // new
          currentIndex: _currentIndex, // new
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Anasayfa'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text('İlan Ekle'),
            ),
            new BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('Profil'))
          ],
        ),
      ),
    );
  }
}
