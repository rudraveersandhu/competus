import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:my_drona/Main_Screen.dart';
import 'package:my_drona/pages/login_page/info_page_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'model/quiz_history_model.dart';
import 'model/stream_model.dart';
import 'model/subject.dart';
import 'model/user.dart';
import 'model/user_model.dart';



class DronaService {

  DronaService();
  bool flag = false;

  Timer? timer;

  Future<void> putUserData(String id, Map<String, dynamic> content) async {
    final String dbUrl = "https://db.quilldb.io/db/drona/users/document";

    final Map<String, dynamic> userData = {
      "_id": id,
      "content": content,
    };

    try {
      final response = await http.post(
        Uri.parse(dbUrl),
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode(userData),
      );
      print(userData);

      if (response.statusCode != 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update user data');
      } else {
        print('User data successfully updated');
      }
    } catch (e) {
      print("Error while updating user data: $e");
    }
  }

  updateUserData(String id, Map<String, dynamic> content) async {
    final String dbUrl = "https://db.quilldb.io/users/$id";
    print('saving to the quill db');


    try {
      final response = await http.put(
        Uri.parse(dbUrl),
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode(content),
      );
      print(content);

      if (response.statusCode != 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}'
        );

        throw Exception('Failed to update user data');
      } else {

        print('User data successfully updated');
        return content;
      }
    } catch (e) {
      print("Error while updating user data: $e");
    }
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
   // final String apiUrl = '$baseUrl/users/$userId'; // Append the userId to the users endpoint

    final String DbUrl = "https://db.quilldb.io/users/$userId";

    final response = await http.get(
        Uri.parse(DbUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    //await Future.delayed(Duration(microseconds: 1)); // simulate a network delay

    if (response.statusCode == 200) {
      print("Response code mila hai bhai : ${jsonDecode(response.body)}");
      return jsonDecode(response.body);

    } else {
      return jsonDecode(response.body);

    }
  }

  fetchAndGetData(Map<String, dynamic> data, BuildContext context) async {
    User user = User.fromJson(data);
    var model = context.read<UserModel>();
    model.id = user.id;
    model.name = user.name;
    model.email = user.email;
    model.number = user.phoneNumber;
    model.profilePicture = '';
    model.DOB = user.dob;
    model.subject = user.subjects;  // Ensure `model.subject` is a List<String>
  }

  checkUser(String userId,BuildContext context, String number,String email) async {
    var model = context.read<UserModel>();

    final String DbUrl = "https://db.quilldb.io/db/drona/users/document/$userId";

    final response = await http.get( Uri.parse(DbUrl), headers: {'Content-Type': 'application/json',} );

    print("Response Code: ${response.statusCode}");  //Response Code: 523 if the user already exist

    if(response.statusCode == 200){

      var x = await getUserData( userId );
      await fetchAndGetData( x, context );

      Navigator.pushReplacement( context ,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.ease;
            var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve)));
            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
      return true;
    }else{
      print("New user identified");
      Navigator.pushReplacement(context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => InfoPageWidget(

            number:number,
            ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.ease;
            var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve)));

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
      return false;
    }
  }

  Future<Map<String, dynamic>> getQuizQuestions() async {
    //final String apiUrl = '$baseUrl/quiz'; // Append the quiz endpoint to the base URL
    final String DbUrl = "https://db.quilldb.io/db/drona/users/documents";
    final response = await http.get(Uri.parse(DbUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get quiz questions');
    }
  }

  delete_user_account(String userId) async {
    final String dbUrl = "https://db.quilldb.io/users/$userId";

    try{
      final response = await http.delete(
        Uri.parse(dbUrl),
        headers: { 'Content-Type': 'application/json' },
      );

      if (response.statusCode != 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update user data');
      } else {
        print('User data deleted updated');
      }

    }catch(e){

    }

  }

  Future<List<StreamModel>> getStreams() async {
    final String dbUrl = "https://db.quilldb.io/data/subjects";
    final response = await http.get(Uri.parse(dbUrl));

    if (response.statusCode == 200) {

      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => StreamModel.fromJson(data)).toList();

    } else {
      throw Exception('Failed to load streams');
    }
  }

  Future<List<Subject>> getSubjects() async {
    final String dbUrl = "https://db.quilldb.io/data/subjects";
    final response = await http.get(Uri.parse(dbUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Find the NET stream
      Map<String, dynamic>? netStream = data.firstWhere(
            (element) => element['content']['stream'] == "NET",
        orElse: () => null,
      );

      if (netStream != null) {
        Map<String, dynamic> subjects = netStream['content']['subjects'];

        // Convert to a list of Subject objects
        List<Subject> subjectList = subjects.entries.map((entry) {
          return Subject(name: entry.key, filenames: List<String>.from(entry.value));
        }).toList();

        return subjectList;
      } else {
        throw Exception("NET stream not found");
      }
    } else {
      throw Exception("Failed to load subjects");
    }
  }

  Future<List<Subject>> getallSubjects(String Subj) async {

    final String dbUrl = "https://db.quilldb.io/data/subjects";
    final response = await http.get(Uri.parse(dbUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Find the NET stream
      Map<String, dynamic>? netStream = data.firstWhere(
            (element) => element['content']['stream'] == Subj,
        orElse: () => null,
      );

      if (netStream != null) {
        Map<String, dynamic> subjects = netStream['content']['subjects'];

        // Convert to a list of Subject objects
        List<Subject> subjectList = subjects.entries.map((entry) {
          return Subject(name: entry.key, filenames: List<String>.from(entry.value));
        }).toList();

        return subjectList;
      } else {
        throw Exception("NET stream not found");
      }
    } else {
      throw Exception("Failed to load subjects");
    }
  }

  Future<List<Map<String, dynamic>>> fetchQuestions(int question_limit) async {
    //final url = "https://db.quilldb.io/data/questions?limit=$question_limit";
    final url = "https://db.quilldb.io/data/questions?limit=10";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> questions = [];

      for (var item in data) {
        Map<String, dynamic> question = {
          'id': item['_id'],
          'question': item['Question'],
          'questionNumber': item['Question Number'],
          'optionA': item['Option A'],
          'optionB': item['Option B'],
          'optionC': item['Option C'],
          'optionD': item['Option D'],
          'correctAnswer': item['Correct Answer'],
          'tag': item['Tag']
        };
        questions.add(question);
      }
      print("BHAI YE RAHE QUESTIONS:  $questions");

      return questions;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> phoneAuth(String phn, BuildContext context, int stream_count) async {
    if (phn == null || phn.isEmpty) {
      print('Error: Phone number is null or empty');
      return;
    }

    final String authURL = "https://auth.quilldb.io/startAuthPhone?phoneNumber=91$phn";
    print(authURL);

    try {
      final response = await http.get(Uri.parse(authURL));
      if (response.statusCode != 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to start user authentication');
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        print('User authentication started successfully');

        // Start periodic checking
        Timer.periodic(Duration(seconds: 3), (timer) async {
          await checkPhoneAuth(phn, context, stream_count);

          if (flag == true) {
            print('Phone authentication completed successfully');
            timer.cancel();
          } else if (flag == false) {
            print(flag);
          }
        });
      }
    } catch (e) {
      print("Error while authenticating user: $e");
    }
  }

  userCheck(){

    final String authURL = "https://db.quilldb.io/userCheck";


  }

  checkPhoneAuth(String phn, BuildContext context, int stream_count) async {
    final String authURL = "https://auth.quilldb.io/checkVerificationStatus?phoneNumber=$phn";

    try{
      final response = await http.get(
        Uri.parse(authURL),
      );
      if (response.statusCode != 200) {
        print('Response xxx  status: ${response.statusCode}');
        print('Response xxx  body: ${response.body}');
        throw Exception('Failed to update user data');

      } else {
        print('hahahahahahaha');
        print('Response aa status: ${response.statusCode}');
        print('Response aa body: ${response.body}');
        Map<String, dynamic> responseMap = jsonDecode(response.body);

        bool verified = responseMap['verified'] ?? '';
        bool exists = responseMap['exists'] ?? '';
        String id = responseMap['id'] ?? '';

        print("----------------------------------");
        print(verified);
        print(exists);
        print(id);
        print("----------------------------------");

        print("verified: $verified");

        flag = verified;
        if(verified && exists){
          print("going to the main screen");
          var x = await getUserData(id);
          print("Userdata_1: $x");
          await feedUserModel_ThenHomeScreen(context,x);
          // var data = await fetchAndGetData( x, context );

          // print("Userdata_2: $data");


          //add info updation method here


        } else if(verified && exists == false)
        {
          print("going to the info screen");
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => InfoPageWidget(number: phn),
              //ExamSelectionScreen(streamCount: stream_count),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const curve = Curves.ease;
                var fadeAnimation = animation.drive(
                    Tween(begin: 0.0, end: 1.0).chain(
                        CurveTween(curve: curve)));

                return FadeTransition(
                  opacity: fadeAnimation,
                  child: child,
                );
              },
              transitionDuration:
              const Duration(milliseconds: 700), // Adjust duration to make it slower
            ),
          );
        }
      }
    } catch(e) {
      print("Error while authenticating user: $e");
    }

  }



  create_user(
      var userData,
      BuildContext context,
      String name,
      String dob,
      String email,
      String subject,
      String sub_subjects,
      String number,
      double crLeft,
      double crRech,
      String profile_pic,
      List<List<dynamic>> graph_performance_data
      ) async {
    final user_box = await Hive.openBox('user');

    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('https://db.quilldb.io/createuser/'));
      request.body = json.encode(userData);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("The id received is :${await response.stream.bytesToString()}");

        var data = response.stream;
        print(data);
      } else if (response.statusCode == 307) {
        // Handle the redirect manually
        String redirectUrl = response.headers['location']!;
        var redirectedResponse = await http.post(
          Uri.parse(redirectUrl),
          headers: headers,
          body: json.encode(userData),
        );

        if (redirectedResponse.statusCode == 200) {
          print("The data is : ${redirectedResponse.body}");
          Map<String, dynamic> responseMap = jsonDecode(redirectedResponse.body);
          String id = responseMap['id'];

          await user_box.put('id', id);

          await updateBloodLine(
            context,
            id,
            name,
            email,
            number,
            dob,
            subject,
            sub_subjects,
            crLeft,
            crRech,
            profile_pic,
            graph_performance_data
          );

        } else {
          print('Redirected request failed with status: ${redirectedResponse.statusCode}');
          print('Reason: ${redirectedResponse.reasonPhrase}');
          print('Response body: ${redirectedResponse.body}');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error while creating user: $e");
    }
  }

  updateBloodLine(
      BuildContext context,
      String id,
      String name,
      String email,
      String number,
      String dob,
      String subject,
      String sub_subjects,
      double crLeft,
      double crRech,
      String profile_pic,
      List<List<dynamic>> graph_performance_data
      ) {

    var model = context.read<UserModel>();

    model.updateData(
      id: id,
      name: name,
      email: email,
      number: number,
      profilePicture: profile_pic,
      DOB: dob,
      subject: subject,
      subsubject: sub_subjects,
      address: '',
      rank: "45382",
      credits_left: crLeft,
      credits_recharged: crRech,
      quizHistory: [],
      graph_performance_data: graph_performance_data,
      total_questions_solved: 0,
      time_spent_practicing: 0,
      strongest_subject: "Less-Data",
      weakest_subject: "Less-Data",


    );

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.ease;
          var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve)));

          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  feedUserModel_ThenHomeScreen(BuildContext context,var user) async {

    final user_box = await Hive.openBox('user');
    var userId     = user['_id'];
    var name       = user['name'];
    var dob        = user['dob'];
    var email = user['email'];
    var subject = user['subject'];
    var subSubjects = user['sub_subjects'];
    var phoneNumber = user['phone_number'];
    var profilePicture = user['profile_picture'];
    var address = user['address'];
    //var rank = user['rank'];
    var creditsLeft = user['credits_left'];
    var creditsRecharged = user['credits_recharged'];

    var total_questions_solved = user['total_questions_solved'];
    var time_spent_practicing = user['time_spent_practicing'];
    var strongest_subject = user['strongest_subject'];
    var weakest_subject = user['weakest_subject'];


    List<List<dynamic>> graph_performance_data = (user['graph_performance_data'] as List)
        .map((item) => (item as List).map((subItem) => subItem as dynamic).toList())
        .toList();
    ;

    List<QuizHistory> testHistory = (user['quiz_history'] as List)
        .map((item) => QuizHistory.fromJson(item))
        .toList();

    var model = context.read<UserModel>();

    model.updateData(
        id: userId,
        name: name,
        email: email,
        number: phoneNumber,
        profilePicture: profilePicture,
        DOB: dob,
        subject: subject,
        subsubject: subSubjects,
        address: address,
        rank: '',
        credits_left: creditsLeft,
        credits_recharged: creditsRecharged,
        graph_performance_data: graph_performance_data,
        quizHistory: testHistory,
        total_questions_solved: total_questions_solved,
        time_spent_practicing: time_spent_practicing,
        strongest_subject: strongest_subject,
        weakest_subject: weakest_subject
    );

    print("DS redits_left: $creditsLeft");
    print("DS credits_recharged: $creditsRecharged");
    await user_box.put('id', userId);

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.ease;
          var fadeAnimation = animation.drive(
              Tween(begin: 0.0, end: 1.0).chain(
                  CurveTween(curve: curve)));

          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
        transitionDuration:
        const Duration(milliseconds: 700), // Adjust duration to make it slower
      ),
    );
  }

  feedtestHistory(String id, var content) async {
    try{
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      var request = http.Request('PUT', Uri.parse('https://db.quilldb.io/users/$id'));
      request.body = json.encode(content);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("The id received is :${await response.stream.bytesToString()}");

        var data = response.stream;
        print(data);
      } else if (response.statusCode == 307) {
        // Handle the redirect manually
        String redirectUrl = response.headers['location']!;
        var redirectedResponse = await http.post(
          Uri.parse(redirectUrl),
          headers: headers,
          body: json.encode(content),
        );

        if (redirectedResponse.statusCode == 200) {
          print("The data is : ${redirectedResponse.body}");
          Map<String, dynamic> responseMap = jsonDecode(redirectedResponse.body);
          String id = responseMap['id'];

        } else {
          print('Redirected request failed with status: ${redirectedResponse.statusCode}');
          print('Reason: ${redirectedResponse.reasonPhrase}');
          print('Response body: ${redirectedResponse.body}');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
      }

    } catch(e){
      print("error");

    }
    final String dbUrl = "https://db.quilldb.io/users/$id";
    final Map<String, dynamic> userData = {
      "_id": id,
      "content": content,
    };

    try {
      final response = await http.put(
        Uri.parse(dbUrl),
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode(userData),
      );
      print(content);

      if (response.statusCode != 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        throw Exception('Failed to update user data');
      } else {

        print('User data successfully updated');
        return content;
      }
    } catch (e) {
      print("Error while updating user data: $e");
    }
  }

}
