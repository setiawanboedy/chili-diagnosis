import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:try_not_err/model/model_gejala.dart';
import 'package:try_not_err/model/model_result.dart';
import 'package:try_not_err/views/login.dart';
import 'package:try_not_err/views/solusi.dart';

import '../model/model.dart';
import '../model/model_checkbox.dart';
import 'manage_list_question.dart';
import 'tab_bar_view.dart';

class Diagnosis extends StatefulWidget {
  const Diagnosis({Key? key}) : super(key: key);

  @override
  State<Diagnosis> createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> resultlist = List.empty(growable: true);
  var popularNumbers = [];

  int initPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Diagnosa",
          style: TextStyle(fontFamily: 'montserrat'),
        ),
        automaticallyImplyLeading: false,
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
        actions: [
          InkWell(
            onTap: () {
              FirebaseAuth.instance.userChanges().listen((User? user) {
                if (user == null) {
                  print('User is currently signed out!');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                } else {
                  print('User is signed in!');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageListQuestion(),
                    ),
                  );
                }
              });
            },
            borderRadius: BorderRadius.circular(18),
            child: const Padding(
              padding: EdgeInsets.all(18.0),
              child: Icon(Icons.account_box_rounded),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<ModelGejala>>(
          future: getGejala(),
          builder: (context, dataSnap) {
            var gejalas = dataSnap.data;
            if (dataSnap.hasData) {
              return CustomTabView(
                initPosition: initPosition,
                itemCount: gejalas?.length,
                tabBuilder: (context, index) => Container(),
                pageBuilder: (context, index) => Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Text(
                          gejalas![index].gejala,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                initPosition++;
                                if (initPosition >= gejalas.length) {
                                  print('result');
                                  initPosition--;
                                  resultData(context, gejalas);
                                }
                              });
                            },
                            child: Text('No'),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                resultlist.add(gejalas[index].penyakit);
                                initPosition++;
                                if (initPosition >= gejalas.length) {
                                  print('result');
                                  initPosition--;
                                  resultData(context, gejalas);
                                }
                              });
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    ])),
                onPositionChange: (index) {
                  print('current position: $index');
                  initPosition = index;
                },
                onScroll: (position) => print(''),
              );
            } else {
              return Container();
            }
          }),
    );
  }

  Future<List<ModelGejala>> getGejala() async {
    CollectionReference _data = firestore.collection('gejala');
    var gejala = await _data.get();
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

  void resultData(BuildContext context, List<ModelGejala> data) {
    data.asMap().forEach((key, value) {
      if (value.value == true) {
        resultlist.add(value.penyakit);
      }
    });
    var gejala = mostAppears();
    for (var sakit in PenyakitSolusiList) {
      if (sakit.sakit == gejala.most) {
        if (kDebugMode) {
          print(sakit.name);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Solusi(
              solusi: sakit,
              persentase: gejala.persentase,
            ),
          ),
        );
      }
    }
    initPosition = 0;
    resultlist.clear();
  }

  ModelResult mostAppears() {
    if (resultlist.iterator.moveNext()) {
      resultlist.sort();
      var popularNumbers = [];
      List<Map<dynamic, dynamic>> data = [];
      List<Persentase> persentase = [];
      var maxOccurrence = 0;

      var i = 0;
      while (i < resultlist.length) {
        var number = resultlist[i];
        var occurrence = 1;
        for (int j = 0; j < resultlist.length; j++) {
          if (j == i) {
            continue;
          } else if (number == resultlist[j]) {
            occurrence++;
          }
        }
        resultlist.removeWhere((it) => it == number);
        data.add({number: occurrence});
        if (maxOccurrence < occurrence) {
          maxOccurrence = occurrence;
        }
      }
      for (var map in data) {
        if (map[map.keys.toList()[0]] == maxOccurrence) {
          popularNumbers.add(map.keys.toList()[0]);
        }
      }

      var selected = 0;
      data.asMap().forEach((key, value) => value.values.forEach((val) {
            selected += val as int;
          }));
      data.asMap().forEach((key, value) => value.forEach((k, v) {
            var persen = v / selected * 100;
            for (var sakit in PenyakitSolusiList) {
              if (sakit.sakit == k) {
                persentase.add(Persentase(sakit.name, persen));
              }
            }
          }));

      return ModelResult(
          most: popularNumbers[0].toString(), persentase: persentase);
    } else {
      return ModelResult(most: '');
    }
  }
}

class CustomTabView extends StatefulWidget {
  final int? itemCount;
  final IndexedWidgetBuilder? tabBuilder;
  final IndexedWidgetBuilder? pageBuilder;
  final Widget? stub;
  final ValueChanged<int>? onPositionChange;
  final ValueChanged<double>? onScroll;
  final int? initPosition;

  const CustomTabView({
    @required this.itemCount,
    @required this.tabBuilder,
    @required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  TabController? controller;
  int? _currentCount;
  int? _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount!,
      vsync: this,
      initialIndex: _currentPosition!,
    );
    controller?.addListener(onPositionChange);
    controller?.animation?.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller?.animation?.removeListener(onScroll);
      controller?.removeListener(onPositionChange);
      controller?.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition! > widget.itemCount! - 1) {
        _currentPosition = widget.itemCount! - 1;
        _currentPosition = _currentPosition! < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange!(_currentPosition!);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount!,
          vsync: this,
          initialIndex: _currentPosition!,
        );
        controller?.addListener(onPositionChange);
        controller?.animation?.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller?.animateTo(widget.initPosition!);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller?.animation?.removeListener(onScroll);
    controller?.removeListener(onPositionChange);
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount! < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            tabs: List.generate(
              widget.itemCount!,
              (index) => widget.tabBuilder!(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount!,
              (index) => widget.pageBuilder!(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller!.indexIsChanging) {
      _currentPosition = controller?.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange!(_currentPosition!);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll!(controller!.animation!.value);
    }
  }
}
