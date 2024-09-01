import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import '../drona_service.dart';
import '../main.dart';
import '../model/QuizHistory.dart';
import '../model/qanda_history_model.dart';
import '../model/quiz_history_model.dart';
import '../model/stream_model.dart';
import '../model/user_model.dart';
import '../pages/login_page/login_page_widget.dart';

class SplashScreenWeb extends StatefulWidget {
  final String plat;
  const SplashScreenWeb({super.key,required this.plat});

  @override
  State<SplashScreenWeb> createState() => _SplashScreenWebState();
}

class _SplashScreenWebState extends State<SplashScreenWeb> with TickerProviderStateMixin{
  late List<StreamModel> futureStreams;
  late AnimationController _scaleControllerGetHired;
  late Animation<double> _scaleAnimationGetHired;
  int streamCount = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    runme().then((_) {
      _navigateToHome();
    });
  }

  Future<void> runme() async {
    var quiz = Provider.of<Quizhistory>(context, listen: false);
    var model = Provider.of<Quizhistory>(context);

    try {
      await get_graph_data();
      futureStreams = await DronaService(widget.plat).getStreams();
      streamCount = futureStreams.length;
    } catch (e) {
      print("Error Caught: $e");
      print(e == "Exception: Failed to load streams");
      if (e == "Exception: Failed to load streams") {
        print("Server band hai");
      }
    }
  }

  get_graph_data() async {
    var bx = Provider.of<QandaHistoryModel>(context, listen: false);
    final graph_box = await Hive.openBox('QandA');

    List<int> answers = await graph_box.get('correct_answers') ?? [0];
    List<int> total_questions = await graph_box.get('total_questions') ?? [0];
    List<DateTime> days = (await graph_box.get('days') as List<dynamic>?)?.map((e) => e as DateTime).toList() ?? [DateTime.now()];

    setState(() {
      bx.answers = answers;
      bx.total_questions = total_questions;
      bx.days = days;
    });
  }

  List<QuizHistory> parseQuizHistoryList(String jsonString) {
    final parsed = jsonDecode(jsonString) as List<dynamic>;
    return parsed.map((json) => QuizHistory.fromJson(json as Map<String, dynamic>)).whereType<QuizHistory>().toList();
  }

  void _setupAnimations() {
    _scaleControllerGetHired = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimationGetHired = CurvedAnimation(
      parent: _scaleControllerGetHired,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _scaleControllerGetHired.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width * .6,
                  child: Image.asset('assets/1.gif'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToHome() async {
    final user_box = await Hive.openBox('user');

    String id = user_box.get('id') ?? '';

    if (id.isNotEmpty) {

      print("id is not empty: $id");
      var x = await DronaService(plat).getUserData(id);
      await DronaService(plat).feedUserModel_ThenHomeScreen(context,x);

    } else if (id.isEmpty) {
      print("id is empty");
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => LoginPageWidget(stream_count: streamCount, plat: widget.plat),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.ease;
            var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve)));
            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }



  data_to_model(Map<String, dynamic> jsonData) {
    var model = context.read<UserModel>();
    String id = jsonData['_id'];
    String name = jsonData['name'];
    String dob = jsonData['dob'];
    String email = jsonData['email'];
    String phoneNumber = jsonData['phone_number'];
    String subject = jsonData['subject'];
    String subSubjects = jsonData['sub_subjects'];
    String address = jsonData['address'];
    double credits_left = jsonData['credits_left'].toDouble();
    double credits_recharged = jsonData['credits_recharged'].toDouble();
    String profilePhoto = jsonData['profile_picture'] ?? '';
    int total_questions_solved = jsonData['total_questions_solved'] ?? 0;
    int time_spent_practicing = jsonData['time_spent_practicing'] ?? 0;
    String strongest_subject = jsonData['strongest_subject'] ?? '';
    String weakest_subject = jsonData['weakest_subject'] ?? '';

    List<QuizHistory> testHistory = (jsonData['quiz_history'] as List)
        .map((item) => QuizHistory.fromJson(item))
        .toList();

    List<List<dynamic>> graphPerformanceData = (jsonData['graph_performance_data'] as List)
        .map((item) => (item as List).map((element) {
      if (element is int) {
        return element;
      } else if (element is String) {
        // Assuming DateTime is stored as a string in the JSON data
        return DateTime.parse(element);
      }
      return null; // Or handle unexpected cases
    }).toList())
        .toList();

    print(" splash screen fetched History: $testHistory");

    setState(() {
      model.updateData(
        id: id,
        name: name,
        email: email,
        number: phoneNumber,
        profilePicture: profilePhoto,
        DOB: dob,
        subject: subject,
        subsubject: subSubjects,
        address: address,
        rank: '4893',
        credits_left: credits_left,
        credits_recharged: credits_recharged,
        quizHistory: testHistory,
        graph_performance_data: graphPerformanceData,
        total_questions_solved: total_questions_solved,
        time_spent_practicing: time_spent_practicing,
        strongest_subject: strongest_subject,
        weakest_subject: weakest_subject,
      );
    });
  }
}
