import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:try_not_err/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options:const FirebaseOptions(
    apiKey: "AIzaSyAyimeJYW-Hz5cpdEhFZkot2FjyMwOF9vw",
      appId: "sistem-pakar-4e227",
      projectId: "sistem-pakar-4e227",
      messagingSenderId: "447302752878",
  ),);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
