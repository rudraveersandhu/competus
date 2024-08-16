import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import '../../drona_service.dart';
import '../../model/QuizHistory.dart';
import '../../model/quiz_history_model.dart';
import '../../model/subject.dart';
import '../../model/user_model.dart';
import '../../quiz_history_screen.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TestHistory extends StatefulWidget {
  const TestHistory({super.key});

  @override
  State<TestHistory> createState() => _TestHistoryState();
}

class _TestHistoryState extends State<TestHistory> with TickerProviderStateMixin {
  late List<Animation<double>> _fadeAnimations;
  bool isToggleOn = false;
  String dropdownValue = 'Easy';
  final List<String> dropdownOptions = ['Easy', 'Medium', 'Hard'];
  var subjects;

  String _selectedSubject = '';
  String? _selectedNETSub;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};
  late List<AnimationController> _fadeControllers;
  int _selectedIndex = -1;
  late String sub;
  TextEditingController _searchController = TextEditingController();
  List<QuizHistory> _filteredQuizHistory = [];

  getSubjects() {
    var model = context.read<UserModel>();
    sub = model.subject;

    setState(() {
      _filteredQuizHistory = model.quizHistory;
    });

  }

  @override
  void initState() {
    super.initState();
    getSubjects();
    _fadeControllers = List<AnimationController>.generate(
      16,
          (int index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );
    _fadeAnimations = _fadeControllers
        .map((controller) => Tween<double>(begin: 0, end: 1).animate(controller))
        .toList();

    _searchController.addListener(() {
      filterSearchResults(_searchController.text);
    });

    animationsMap.addAll({
      // Add your animations here
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger || !anim.applyInitialState),
      this,
    );
  }

  void filterSearchResults(String query) {
    final userModel = context.read<UserModel>();
    if (query.isEmpty) {
      setState(() {
        _filteredQuizHistory = userModel.quizHistory;
      });
      return;
    }
    setState(() {
      _filteredQuizHistory = userModel.quizHistory
          .where((history) => history.subjectName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, quizHistoryProvider, child) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 20),
              child: Text(
                'Test History',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            centerTitle: false,
            elevation: 0.0,
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/login_bg@2x.png'),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value){

                    },
                    decoration: InputDecoration(
                      hintText: 'Subjects:',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFF00968A),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () {
                            // Add your calendar event function here
                          },
                          child: Icon(
                            Icons.calendar_month_outlined,
                            color: Color(0xFF00968A),
                          ),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                  ),
                ),
                Divider(height: 1),

                Container(
                  height: MediaQuery.of(context).size.height/1.5,
                  child: ListView.builder(
                    itemCount: _filteredQuizHistory.length,
                    itemBuilder: (context, index) {
                      print("History Length: ${_filteredQuizHistory.length}");
                      final quizHistory = _filteredQuizHistory[index];
                      final List<String> questions = quizHistory.questions.map((question) => question.questionText).toList();
                      final List<List<String>> answers = quizHistory.questions.map((question) => question.options).toList();
                      final List<String> correctAnswers = quizHistory.questions.map((question) => question.correctAnswer).toList();
                      List<String> userAnswers = quizHistory.userAnswers;
                      String level = quizHistory.level;
                      int num_of_ques = quizHistory.numOfQues;

                      return optionCards(
                        quizHistory.subjectName,
                        quizHistory.markAchieved.toString(),
                        quizHistory.totalMarks.toString(),
                        questions,
                        answers,
                        correctAnswers,
                        userAnswers,
                          level,
                          num_of_ques

                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        );
      }
    );
  }

  Widget optionCards(
      String subjectName,
      String achievedMarks,
      String totalMarks,
      List<String> questions,
      List<List<String>> answers,
      List<String> correctAnswers,
      List<String> userAnswers,
      String level,
      int num_of_ques
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => QuizHistoryScreen(
              subject: subjectName,
              questions: questions,
              answers: answers,
              correct_answers: correctAnswers,
              selected_answers: userAnswers,
            ),
          ),
        );
      },
      child: optionCard(
        context: context,
        title: "Total Questions: 30",
        subtitle: subjectName,
        description1: "Scored:",
        description2: "Max Scores:",
        description3: totalMarks,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        textColor: FlutterFlowTheme.of(context).textColor,
        achievedMarks: achievedMarks,
        level: level,
        num_of_ques: num_of_ques,


      ),
    );
  }

  Widget optionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description1,
    required String description2,
    required String description3,
    required Color backgroundColor,
    required Color textColor,
    required achievedMarks,
    required level,
    required num_of_ques,

  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
      child: Container(
        width: 100.0,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Lexend',
                        color: FlutterFlowTheme.of(context).alternate,
                        letterSpacing: 0.0,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: textColor,
                      size: 16.0,
                    ),
                  ],
                ),
              ),
              Text(
                subtitle,
                style: FlutterFlowTheme.of(context).displaySmall.override(
                  fontFamily: 'Lexend',
                  color: textColor,
                  letterSpacing: 0.0,
                  fontSize: 22,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(2.0, 4.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Level",
                              textAlign: TextAlign.end,
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Lexend',
                                color: const Color(0xB3FFFFFF),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text(
                                level,
                                textAlign: TextAlign.end,
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Lexend',
                                  color: textColor,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              description1,
                              textAlign: TextAlign.end,
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Lexend',
                                color: const Color(0xB3FFFFFF),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text(
                                achievedMarks,
                                textAlign: TextAlign.end,
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Lexend',
                                  color: textColor,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                    ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Row(
                        children: [
                          Text(
                            "Questions",
                            textAlign: TextAlign.end,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Lexend',
                              color: const Color(0xB3FFFFFF),
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                              num_of_ques.toString(),
                              textAlign: TextAlign.end,
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Lexend',
                                color: textColor,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            description2,
                            textAlign: TextAlign.end,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Lexend',
                              color: const Color(0xB3FFFFFF),
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                              description3,
                              textAlign: TextAlign.end,
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Lexend',
                                color: textColor,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

