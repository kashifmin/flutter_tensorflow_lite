part of tensorflow_lite;

abstract class Classifier {
  Future<List<Recognition>> recognizeImage(Image image);

  void close();
}

class Recognition {
  String _id;
  String _title;
  double _confidence;

  Recognition(this._id, this._title, this._confidence);

  double get confidence => _confidence;

  String get title => _title;

  String get id => _id;

  @override
  String toString() {
    return 'Recognition{_id: $_id, _title: $_title, _confidence: $_confidence}';
  }


}