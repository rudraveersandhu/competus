class SubjectModel {
  final String stream;
  final Map<String, List<String>> subjects;

  SubjectModel({required this.stream, required this.subjects});

  factory SubjectModel.fromJson(Map<String, dynamic> json) {

    return SubjectModel(
      stream: json['content']['stream'],
      subjects: Map<String, List<String>>.from(
        json['content']['subjects'].map(
              (key, value) => MapEntry(key,
            List<String>.from(value),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': {
        'stream': stream,
        'subjects': subjects.map(
              (key, value) => MapEntry(key, value),
        ),
      },
    };
  }
}
