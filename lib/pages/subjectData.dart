import 'dart:convert';
import 'package:http/http.dart' as http;

// Define a class to represent the subject data.
class SubjectData {
  final String stream;
  final Map<String, List<String>> subjects;

  SubjectData({required this.stream, required this.subjects});
}

// Fetch and process the subject data.
Future<List<SubjectData>> fetchSubjects() async {
  final response = await http.get(Uri.parse('https://db.quilldb.io/data/subjects'));

  if (response.statusCode == 200) {
    // Decode the JSON response.
    List<dynamic> jsonResponse = json.decode(response.body);

    // Initialize a list to store the subject data.
    List<SubjectData> subjectDataList = [];

    // Iterate through the JSON data and extract subjects.
    for (var item in jsonResponse) {
      String stream = item['content']['stream'];
      Map<String, List<String>> subjectsMap = Map<String, List<String>>.from(item['content']['subjects']);

      subjectDataList.add(SubjectData(stream: stream, subjects: subjectsMap));
    }

    return subjectDataList;
  } else {
    throw Exception('Failed to load subjects');
  }
}

// Get topics for a specific subject.
Future<List<String>> getTopicsForSubject(String subjectName) async {
  try {
    List<SubjectData> subjects = await fetchSubjects();

    // Iterate through the subject data to find the requested subject.
    for (var subjectData in subjects) {
      for (var subject in subjectData.subjects.keys) {
        if (subject == subjectName) {
          return subjectData.subjects[subject]!;
        }
      }
    }

    // If the subject is not found, return an empty list or throw an exception.
    return [];
  } catch (e) {
    print(e);
    return [];
  }
}

// Example usage of the function.
void main() async {
  try {
    // Fetch topics for a specific subject.
    String subjectName = 'Law (General Legal Knowledge, The Constitution of India, The Code of Civil Procedure, 1908, The Code of Criminal Procedure, 1973, The Indian Penal Code, etc.)';
    List<String> topics = await getTopicsForSubject(subjectName);

    // Print the topics for demonstration.
    print('Topics for "$subjectName":');
    for (var topic in topics) {
      print(' - $topic');
    }
  } catch (e) {
    print(e);
  }
}
