import 'package:flutter/material.dart';
import 'package:try_not_err/model/model.dart';
import 'package:try_not_err/views/detail.dart';

class Penyakit extends StatelessWidget {
  const Penyakit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Penyakit dan solusi",
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
      body: ListView.builder(
        itemBuilder: ((context, index) {
          final PenyakitSolusi solusi = PenyakitSolusiList[index];
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Detail(
                  solusi: solusi,
                );
              }));
            },
            child: Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: Image.asset(solusi.imageAsset)),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(solusi.name,style: const TextStyle(fontFamily: 'poppins'),),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        }),
        itemCount: PenyakitSolusiList.length,
      ),
    );
  }
}
