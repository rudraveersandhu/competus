class Subject {
  String name;
  List<String> filenames;

  Subject({required this.name, required this.filenames});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'] as String,
      filenames: List<String>.from(json['filenames']),
    );
  }
}
