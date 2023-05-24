import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'manage_list_question.dart';

class AddGejala extends StatefulWidget {
  const AddGejala({Key? key}) : super(key: key);

  @override
  State<AddGejala> createState() => _AddGejalaState();
}

class _AddGejalaState extends State<AddGejala> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _gejala = TextEditingController();
  final TextEditingController _codePenyakit = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<String> _codeGejala = ['A', 'B', 'C', 'D', 'E', 'F'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Gejala'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _gejala,
                decoration: InputDecoration(
                  labelText: 'Gejala',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _codePenyakit,
                decoration: InputDecoration(
                  labelText: 'Kode Penyakit',
                  hintText: 'Contoh: A,B,C,D,E,F',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (_codeGejala.contains(_codePenyakit.text)) {
                      addGejala();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Kode gejala tidak sesuai!'),
                        ),
                      );
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Tambah'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addGejala() async {
    CollectionReference gejala = firestore.collection('gejala');
    var id = gejala.doc().id;
    await gejala.doc(id).set({
      'gejala': _gejala.text,
      'value': false,
      'penyakit': _codePenyakit.text,
      'id': id,
    }).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Gejala Berhasil Ditambahkan!'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManageListQuestion(),
        ),
      );
    });

    _gejala.clear();
    _codePenyakit.clear();
  }
}
