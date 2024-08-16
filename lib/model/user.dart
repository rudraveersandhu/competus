class User {
  final String id;
  final String name;
  final String dob;
  final String email;
  final String subjects;
  final String phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.dob,
    required this.email,
    required this.subjects,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Debugging logs
    print("JSON input: $json");

    // Extracting content from JSON
    final content = json['content'] ?? {};

    return User(
      id: json['_id'] ?? '',
      name: content['name'] ?? '',
      dob: content['dob'] ?? '',
      email: content['email'] ?? '',
      subjects: content['subjects'] ?? '',
      phoneNumber: content['phone_number'] ?? '',
    );
  }
}
