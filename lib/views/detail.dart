import 'package:try_not_err/model/model.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  final PenyakitSolusi solusi;
  const Detail({Key? key, required this.solusi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: const Text(
          "Halaman Detail",
          style: TextStyle(fontFamily: 'montserrat'),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(children: [Image.asset(solusi.imageAsset)]),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(solusi.name, style: const TextStyle(fontFamily: 'montserrat'),),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(solusi.solusi, style: const TextStyle(fontFamily: 'worksans'),),
            ),
          ],
        ),
      ),
    );
  }
}
