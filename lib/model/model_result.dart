class ModelResult {
  String most;
  List<Persentase>? persentase;

  ModelResult({required this.most, this.persentase});
}

class Persentase {
  String penyakit;
  double persen;

  Persentase(this.penyakit, this.persen);
}
