class StreamModel {
  final String id;
  final String stream;
  final Map<String, List<String>> subjects;

  StreamModel({required this.id, required this.stream, required this.subjects});

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    return StreamModel(
      id: json['_id'],
      stream: json['content']['stream'],
      subjects: Map<String, List<String>>.from(
        json['content']['subjects'].map(
              (key, value) => MapEntry(
            key,
            List<String>.from(value),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': {
        'stream': stream,
        'subjects': subjects.map(
              (key, value) => MapEntry(key, value),
        ),
      },
    };
  }

  bool isNetStream() {
    return stream == "NET";
  }


  @override
  String toString() {
    return 'StreamModel{id: $id, name: $subjects';
  }
}
