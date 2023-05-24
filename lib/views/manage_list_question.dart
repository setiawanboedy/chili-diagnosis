import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:try_not_err/model/model_checkbox.dart';
import 'package:try_not_err/model/model_gejala.dart';
import 'package:try_not_err/views/add_gejala.dart';
import 'package:try_not_err/views/home.dart';

class ManageListQuestion extends StatefulWidget {
  const ManageListQuestion({Key? key}) : super(key: key);

  @override
  State<ManageListQuestion> createState() => _ManageListQuestionState();
}

class _ManageListQuestionState extends State<ManageListQuestion> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Questions'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Icon(Icons.arrow_back),
        ),
        actions: [
          InkWell(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(18.0),
              child: Icon(Icons.logout),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<ModelGejala>>(
            future: getGejala(),
            builder: (context, data) {
              var gejala = data.data;
              if (data.hasData) {
                return ListView.builder(
                    itemCount: gejala?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          'Gejala: ${gejala?[index].gejala}',
                        ),
                        subtitle: Text('Kode: ${gejala?[index].penyakit}'),
                        trailing: InkWell(
                          onTap: () {
                            deleteGejala(gejala![index].id);
                            setState(() {});
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Icon(Icons.delete),
                        ),
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddGejala(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<ModelGejala>> getGejala() async {
    CollectionReference data = firestore.collection('gejala');
    var gejala = await data.get();
    List<ModelGejala> _gejalas = List.empty(growable: true);
    gejala.docs.forEach(
      (value) => _gejalas.add(
        ModelGejala(
          id: value['id'],
          gejala: value['gejala'],
          value: false,
          penyakit: value['penyakit'],
        ),
      ),
    );
    return _gejalas;
  }

  Future<void> deleteGejala(String id) async {
    CollectionReference data = firestore.collection('gejala');
    await data.doc(id).delete();
  }
}
