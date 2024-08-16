import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_drona/drona_service.dart';
import 'package:my_drona/pages/quiz_screens/question_screen.dart';
import 'package:provider/provider.dart';

import '../../model/answer_model.dart';
import '../../model/question.dart';
import '../../model/user_model.dart';

class QuizIntroduction extends StatefulWidget {
  String subject;
  String level;
  String question_count;

  QuizIntroduction({
    super.key,
    required this.subject,
    required this.level,
    required this.question_count,
  });

  @override
  State<QuizIntroduction> createState() => _QuizIntroductionState();
}

class _QuizIntroductionState extends State<QuizIntroduction> {
  List<String> questions = [];
  List<String> correct_answers = [];
  List<List<String>> answers = [];
  bool isLoading = false;
  int ques_count = 0;
  int second_per_ques = 0;

  Future<void> _loadQuestions() async {
    switch (widget.question_count) {
      case "30 questions":
        ques_count =  30;
      case "50 questions":
        ques_count =  50;
      case "100 questions":
        ques_count = 100;
      default:
        throw ArgumentError("Invalid question count string: ${widget.question_count}");
    }

    switch (widget.level) {
      case "Easy":
        second_per_ques =  120;
      case "Medium":
        second_per_ques =  90;
      case "Hard":
        second_per_ques = 60;
      default:
        throw ArgumentError("Invalid question count string: ${widget.level}");
    }

    print("Question count is: $ques_count");

    setState(() {
      isLoading = true;
    });

    List<Map<String, dynamic>> fetchedQuestionsData = await DronaService().fetchQuestions(ques_count) ?? [];
    //print("Fetched question json: $fetchedQuestionsData");

    questions = fetchedQuestionsData.map((questionData) {
      return questionData['question'] as String;
    }).toList();

    answers = fetchedQuestionsData.map((questionData) {
      return [
        questionData['optionA'] as String,
        questionData['optionB'] as String,
        questionData['optionC'] as String,
        questionData['optionD'] as String,
      ];
    }).toList();

    correct_answers = fetchedQuestionsData.map((questionData) {
      return questionData['correctAnswer'] as String;
    }).toList();

    setState(() {
      isLoading = false;
    });

    //print(answers);
  }

  @override
  void initState() {
    super.initState();
    print(widget.level);
    print(widget.question_count);
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    var question = Provider.of<AnswerModel>(context);
    var height = MediaQuery.of(context).size.height;
    print(height);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xFF00968A),
        child: SafeArea(
          child: Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: isLoading
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.beat(
                        color: Colors.white,
                        size: 25,),
                      SizedBox(height: 10,),
                      Text('Thinking..',style: TextStyle(color: Colors.white),)
                    ],
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: height > 900 ? MediaQuery.of(context).size.height/5 : height > 700 ? MediaQuery.of(context).size.height/7 : MediaQuery.of(context).size.height/12,
                            child: Center(
                              child: Container(
                                height: height > 900 ? MediaQuery.of(context).size.height/2.3  : height > 700 ? MediaQuery.of(context).size.height/2: MediaQuery.of(context).size.height/1.5,
                                width: MediaQuery.of(context).size.width - 60,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.5),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white60),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 20,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 20.0, left: 15, right: 30),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Instructions :",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 23,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  BulletPoint(
                                                      text:
                                                      "The quiz comprises xyz multiple choice questions, each offering four options."),
                                                  SizedBox(height: 5,),
                                                  BulletPoint(
                                                      text:
                                                      "The objective is to select the most appropriate answer for each question."),
                                                  SizedBox(height: 5,),
                                                  BulletPoint(
                                                      text:
                                                      "The quiz has to be competed in xyz minutes"),
                                                  SizedBox(height: 5,),
                                                  BulletPoint(
                                                      text:
                                                      "Each correct answer awards 1 mark. The total score will be calculated based on the number of questions answered correctly"),

                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: height > 900 ? 40 : 30,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(),
                                          GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              utilize_credits();

                                              //('Loading questions before navigating to question screen');
                                              //await _loadQuestions(widget.question_count);

                                              //print('Navigating to question screen');
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (builder) => QuestionScreen(
                                                  subject: widget.subject,
                                                  questions: questions,
                                                  answers: answers,
                                                  correct_answers: correct_answers,
                                                  time_limit: ques_count * second_per_ques,
                                                      level: widget.level
                                                  )
                                                )
                                              );

                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            child: Container(
                                              height: 45,
                                              width: MediaQuery.of(context).size.width / 2,
                                              decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(.2),
                                                  borderRadius: BorderRadius.circular(15),
                                                  border: Border.all(
                                                      color: Colors.white, width: .5)),
                                              child: const Center(
                                                child: Text(
                                                  'Start Quiz',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 40,
                                      top: 40,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(.2),
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: Colors.white, width: .5)),
                                          child: Icon(CupertinoIcons.xmark,
                                            color: Colors.white,),
                                        ),
                                      ),
                                    )

                                ],
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  utilize_credits() async {
    var user = Provider.of<UserModel>(context,listen: false);
    double credits = user.credits_left - (0.67 * ques_count) ;
    setState(() {
      user.utilizeCredits(credits_left: credits);
    });
    await updateDatabase();
  }

  updateDatabase() async {
    var model = context.read<UserModel>();
    var content = {
      "credits_left"      : model.credits_left,
    };

    await DronaService().updateUserData(model.id,content);
  }

}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('• ', style: TextStyle(fontSize: 20, color: Colors.white)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
