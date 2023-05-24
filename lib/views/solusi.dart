import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:try_not_err/model/model_result.dart';
import '../model/model.dart';

class Solusi extends StatefulWidget {
  final PenyakitSolusi solusi;
  final List<Persentase>? persentase;
  const Solusi({Key? key, required this.solusi, this.persentase})
      : super(key: key);

  @override
  State<Solusi> createState() => _SolusiState();
}

class _SolusiState extends State<Solusi> {
  List<Persentase>? persentase;

  @override
  void initState() {
    widget.persentase?.sort(((a, b) => b.persen.compareTo(a.persen)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hasil Diagnosa',
          style: TextStyle(fontFamily: 'montserrat'),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Column(
                        children: [
                          const Text(
                            'Hasil',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'poppins'),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.solusi.name,
                            style: const TextStyle(
                                fontSize: 20, fontFamily: 'worksans'),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Solusi',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(widget.solusi.solusi),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      height: 2,
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Image.asset(widget.solusi.imageAsset),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      height: 1,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.persentase!.length,
                      itemBuilder: (context, index) {
                        /// Persentase tertinggi
                        if (index == 0) {
                          return Container();
                        }
                        return ListTile(
                          leading:
                              Text('${widget.persentase?[index].penyakit}'),
                          trailing: Text(
                              '${widget.persentase?[index].persen.toStringAsFixed(1)}%'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
