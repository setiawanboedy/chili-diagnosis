import 'package:flutter/material.dart';
import 'package:try_not_err/views/about.dart';
import 'package:try_not_err/views/diagnosa.dart';
import 'package:try_not_err/views/help.dart';
import 'package:try_not_err/views/home_page.dart';
import 'package:try_not_err/views/penyakit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  final screen = [const HomePage(), const Penyakit(), const Diagnosis(), const Help(), const About()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: IndexedStack(
          index: index,
          children: screen,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.lightBlue,
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: (value) => setState((() => index = value)),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bug_report), label: "Penyakit"),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_hospital), label: "Diagnosa"),
            BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "About"),
          ],
        ));
  }
}
