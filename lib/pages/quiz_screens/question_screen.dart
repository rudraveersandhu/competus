import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_drona/drona_service.dart';
import 'package:my_drona/model/QuizHistory.dart';
import 'package:provider/provider.dart';
import '../../components/QuestionBlock.dart';
import '../../main.dart';
import '../../model/answer_model.dart';
import '../../model/qanda_history_model.dart';
import '../../model/quiz_history_model.dart';
import '../../model/user_model.dart';

class QuestionScreen extends StatefulWidget {
  final String subject;
  final List<String> questions;
  final List<String> correct_answers;
  final List<List<String>> answers;
  final int time_limit;
  final String level;
  const QuestionScreen({
    super.key,
    required this.questions,
    required this.answers,
    required this.subject,
    required this.correct_answers,
    required this.time_limit,
    required this.level,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final PageController _pageController = PageController();
  late int _timeLeft;

  Timer? _timer;
  int _seconds = 0;
  int q_index  = 1; // Start at 1 since it's 1-based index

  List<String> user_answers = [];
  List<String> user_answers_string = [];

  String    selected_answer = '0';

  List<String> currentAnswers = [];

  int _elapsedTime = 0;

  int total_time = 0;



  @override
  void initState() {
    super.initState();
    _timeLeft = widget.time_limit;
    user_answers.clear();
    selected_answer = '0';
    q_index = 1;
    _seconds = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        final currentPage = _pageController.page ?? 0;
        setState(() {
          q_index = currentPage.toInt() + 1;
        });
        startTimer();
      }
    });
  }




  void startTimer() async {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
          _elapsedTime++;
          //print("Time elapsed: $_elapsedTime seconds");
        } else {
          _timer?.cancel();
          //print("Time's up!");
        }
      });
    });

    await _autoSubmit();
  }

  _autoSubmit() async {
    await updateQuizHistory();
    print("auto submitted !!!");

  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print("Answers: ${widget.answers}");
    var question = Provider.of<AnswerModel>(context);
    var height = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          // background element above
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFF00968A),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    right: 90,
                    top: 24,
                    child: Container(
                      height: 45,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black54,
                        border: Border.all(color: Colors.white54),
                      ),
                      child: Center(
                        child: Text(
                          formatTime(_timeLeft),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 90,
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.questions.length,
                            onPageChanged: (index) {
                              setState(() {
                                q_index = index + 1;
                              });
                            },
                            itemBuilder: (context, index) {
                              //print(index);
                              return buildQuestionPage(context, widget.questions[index], question, index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Positioned(
                    bottom: 10,
                    left: 20,
                    right: 20,
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 0.0,top: 20),
                        child: GestureDetector(
                            onTap: () {
                              if (_pageController.page!.toInt() > 0 ) {
                                _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                              } else {

                              }
                            },
                            child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width / 4,
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white, width: .5)),
                              child: Center(
                                child: Text(
                                  'Back',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            )

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 0.0, top: 20),
                        child: GestureDetector(
                          onTap: () {
                            if (_pageController.hasClients && _pageController.page != null) {
                              if (_pageController.page!.toInt() == widget.questions.length - 1) {
                                //print("Last screen, think about it.");
                                //print(widget.questions.length);
                              } else {
                                print("Page 1 answer");

                                saveAnswers();
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              }
                            }
                          },
                          child: _pageController.hasClients && _pageController.page?.toInt() != widget.questions.length - 1
                              ? Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: .5),
                            ),
                            child: Center(
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                              : GestureDetector(
                            onTap: () async {

                              saveAnswers();
                              show_loading();
                              print(user_answers);
                              print(user_answers.length);

                              print("Saving last answer");
                              Provider.of<AnswerModel>(context, listen: false).all_false();

                              await updateQuizHistory();
                              test_finished();
                              selected_answer = '0';
                            },
                            child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width / 3.2,
                              decoration: BoxDecoration(
                                color: Colors.black54.withGreen(41),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white, width: .5),
                              ),
                              child: const Center(
                                child: Text(
                                  'Submit Test',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: .5)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.circle_grid_hex,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Question $q_index",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: GestureDetector(
                          onTap: () {
                            _showExitConfirmationDialog();
                          },
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.white, width: .5)),
                            child: Icon(CupertinoIcons.xmark,color: Colors.white,),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget buildQuestionPage(BuildContext context,
      String questionText,
      AnswerModel question,
      int index) {
    // Get answers for the current question
    currentAnswers = widget.answers[index];
    var height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .7,
          width: MediaQuery.of(context).size.width * .85 ,
          decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15)),
          child: Stack(
              children: [
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 90,
                        height: height < 700 ?  (MediaQuery.of(context).size.height / 3.7)  : (MediaQuery.of(context).size.height / 4.5),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.0, left: 20),
                            child: Text(
                              questionText,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize:  16,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height > 700 ? 220 : 200,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          buildAnswerOption(
                              context,
                              question,
                              selected_answer == 'A',
                              'A)',
                              currentAnswers[0]
                          ),
                          buildAnswerOption(
                              context,
                              question,
                              selected_answer == 'B',
                              'B)',
                              currentAnswers[1]
                          ),
                          buildAnswerOption(
                              context,
                              question,
                              selected_answer == 'C',
                              'C)',
                              currentAnswers[2]
                          ),
                          buildAnswerOption(
                              context,
                              question,
                              selected_answer == 'D',
                              'D)',
                              currentAnswers[3]
                          ),
                        ],
                      ),
                    ),
                  ),

              ],
          ),
        ),

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(right: 0.0,top: 20),
        //       child: GestureDetector(
        //         onTap: () {
        //           if (_pageController.page!.toInt() > 0 ) {
        //             _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        //
        //           } else {
        //
        //           }
        //         },
        //         child: Container(
        //           height: 45,
        //           width: MediaQuery.of(context).size.width / 4,
        //           decoration: BoxDecoration(
        //               color: Colors.black54,
        //               borderRadius: BorderRadius.circular(20),
        //               border: Border.all(color: Colors.white, width: .5)),
        //           child: Center(
        //             child: Text(
        //               'Back',
        //               style: TextStyle(
        //                   fontWeight: FontWeight.w400,
        //                   fontSize: 18,
        //                   color: Colors.white
        //               ),
        //             ),
        //           ),
        //         )
        //
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(right: 0.0,top: 20),
        //       child: GestureDetector(
        //         onTap: () {
        //
        //           if (_pageController.page!.toInt() == widget.questions.length - 1) {
        //             print("last screen hai soch le");
        //             print(widget.questions.length);
        //
        //           } else {
        //             print("page 1 ans");
        //             saveAnswers();
        //             _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        //           }
        //         },
        //         child: !(_pageController.page?.toInt() == widget.questions.length - 1) ? Container(
        //           height: 45,
        //           width: MediaQuery.of(context).size.width / 4,
        //           decoration: BoxDecoration(
        //               color: Colors.black54,
        //               borderRadius: BorderRadius.circular(20),
        //               border: Border.all(color: Colors.white, width: .5)),
        //           child: Center(
        //             child: Text(
        //               'Next',
        //               style: TextStyle(
        //                   fontWeight: FontWeight.w400,
        //                   fontSize: 18,
        //                   color: Colors.white
        //               ),
        //             ),
        //           ),
        //         ) :  GestureDetector(
        //           onTap: () async {
        //             saveAnswers();
        //             print(user_answers);
        //             print(user_answers.length);
        //
        //             print("Saving last answer");
        //             Provider.of<AnswerModel>(context, listen: false).all_false();
        //             selected_answer = '0';
        //             await updateQuizHistory();
        //             test_finished();
        //           },
        //           child: Container(
        //             height: 45,
        //             width: MediaQuery.of(context).size.width / 3.2,
        //             decoration: BoxDecoration(
        //                 color: Colors.black54.withGreen(41),
        //                 borderRadius: BorderRadius.circular(20),
        //                 border: Border.all(color: Colors.white, width: .5)),
        //             child: const Center(
        //               child: Text(
        //                 'Submit Test',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.w400,
        //                     fontSize: 18,
        //                     color: Colors.white),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     )
        //   ],
        // ),
      ],
    );
  }


  Widget buildAnswerOption(
      BuildContext context,
      AnswerModel question,
      bool isSelected,
      String number,
      String answerText) {
        return GestureDetector(
          onTap: () {
            setState(() {
              Provider.of<AnswerModel>(context, listen: false).all_false();
              switch (number) {
                case 'A)':
                  selected_answer = 'A';
                  Provider.of<AnswerModel>(context, listen: false).toggle_answer1();
                  break;

                case 'B)':
                  selected_answer = 'B';
                  Provider.of<AnswerModel>(context, listen: false).toggle_answer2();
                  break;
                case 'C)':
                  selected_answer = 'C';

                  Provider.of<AnswerModel>(context, listen: false).toggle_answer3();
                  break;
                case 'D)':
                  selected_answer = 'D';
                  Provider.of<AnswerModel>(context, listen: false).toggle_answer4();
                  break;
                default:
                  selected_answer = '0';

              }
            });
          },
          child: QuestionBlock(
            number: number,
            Question: answerText,
            block_color: isSelected ? Color(0xFF00968A).withBlue(600) : Colors.white54,
            text_color: isSelected ? Colors.white : Colors.white,
          ),
        );
  }

  _showExitConfirmationDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Curved corners
          ),
          backgroundColor: Colors.transparent, // Transparent background
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8), // Semi-transparent white background
              borderRadius: BorderRadius.circular(20.0), // Curved corners
            ),
            width: 300.0, // Set a fixed width for the container
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Do you want to quit the exam?',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                  Container(
                  height: 40,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                        child: Center(
                          child: TextButton(
                            child: Text('No',
                              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),

                      ),
                    ),
                  Container(
                    height: 40,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),

                    child: Center(
                      child: TextButton(
                        child: Text('Yes, quit exam',
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                        ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.of(context).pop(); // Close the QuestionScreen
                            Navigator.of(context).pop(); // Close the Instruction screen
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  test_finished() {
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Curved corners
          ),
          //backgroundColor: Colors.black, // Transparent background
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.85), // Semi-transparent white background
              borderRadius: BorderRadius.circular(20.0), // Curved corners
            ),
            width: 300.0, // Set a fixed width for the container
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Test Submitted successfully!',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300,color: Colors.white),
                ),
                SizedBox(height: 16.0),
                Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF00968A),
                  ),

                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.of(context).pop(); // Close the QuestionScreen
                        Navigator.of(context).pop(); // Close the Instruction screen
                        Navigator.of(context).pop(); // Close the Instruction screen
                      },
                      child: Container(
                        child: Text('Back to Homepage',
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  saveAnswers(){

    Provider.of<AnswerModel>(context, listen: false).all_false();

    String caseValue = selected_answer; // This can be 'a', 'b', 'c', or 'd'
    String user_answer;

    switch (caseValue) {
      case 'A':
        user_answer = currentAnswers[0];
        print("answer assignment : $user_answer");
        break;

      case 'B':
        user_answer = currentAnswers[1];
        print("answer assignment : $user_answer");
        break;

      case 'C':
        user_answer = currentAnswers[2];
        print("answer assignment : $user_answer");
        break;

      case 'D':
        user_answer = currentAnswers[3];
        print("answer assignment : $user_answer");
        break;

      default:
        user_answer = "0"; // Optional: handle the default case
    }

    user_answers.add(user_answer);

    print("answer being added: $user_answer");

    user_answers_string.add(user_answer);
    selected_answer = '0';
  }

  get_user_data(String id) async {
    print("id getting data: $id");

    try {
      var headers = {'Accept': 'application/json'};
      var request = http.Request('GET', Uri.parse('https://db.quilldb.io/users/$id'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        //print("data mil hai ye ${await data}");
        var jsonData = jsonDecode(data);
        return data_to_model(jsonData);
      } else {
        print("data else${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error getting : $e");
    }
  }

  data_to_model(Map<String, dynamic> jsonData) {
    var model = context.read<UserModel>();

    List<QuizHistory> testHistory = (jsonData['quiz_history'] as List)
        .map((item) => QuizHistory.fromJson(item))
        .toList();

    return testHistory;
  }

  updateQuizHistory() async {
    var quiz = Provider.of<Quizhistory>(context, listen: false);
    var model = context.read<UserModel>();
    List<Question> questions = [];
    DateTime now = DateTime.now();
    DateTime onlyDate = DateTime(now.year, now.month, now.day);
    double marks = 0;
    int correct_answers = 0;

    print('');

    try{

      for (int i = 0; i < widget.questions.length; i++) {
        questions.add(
            Question(
              questionText: widget.questions[i],
              options: widget.answers[i],
              correctAnswer: widget.correct_answers[i],
            )
        );

        if (user_answers[i] == widget.correct_answers[i]) {
          marks = marks + 5;
          correct_answers = correct_answers + 1;
        }
        print("${user_answers[i]} / ${widget.correct_answers[i]}");
      }

      QuizHistory quizHistory = QuizHistory(
        subjectName: widget.subject,
        dateTaken: onlyDate,
        markAchieved: marks,
        totalMarks: widget.questions.length.toDouble() * 5,
        questions: questions,
        userAnswers: user_answers_string,
        level: widget.level,
        numOfQues: widget.questions.length,
      );

      print("Quiz to be saved : ${quizHistory}");

      //List<QuizHistory> x = await get_user_data(model.id);
      List<QuizHistory> x = model.quizHistory;

      print("Fetched db of quiz: ${x}");

      x.add(quizHistory);

      print("Added quiz in the db, now its : ${x}");

      print("added to databaase");

      print(model.quizHistory);
      print(quiz.histroy_array);
      int total_questions = questions.length;

      await updateQuizHistoryState(x);
      print("HAHAHA executed");

      await updateGraphData(total_questions, correct_answers);
      print("update graph data executed");

    }catch(e){
      print("error updating history: $e");
    }
  }

  updateDatabase() async {
    var model = context.read<UserModel>();
    var bx    = Provider.of<QandaHistoryModel>(context, listen: false);
    var content = {
      "name"    : model.name ,
      "dob"     : model.DOB ,
      "email"   : model.email ,
      'profile_picture' : model.profilePicture,
      "subject"      : model.subject ,
      "sub_subjects" : model.subsubject ,
      "phone_number" : model.number ,
      "address"      : '',
      "credits_left"      : model.credits_left,
      "credits_recharged" : model.credits_recharged,
      "graph_performance_data" : model.graph_performance_data.map((list) =>
          list.map((item) {
            if (item is DateTime) {
              return item.toIso8601String();
            }
            return item;
          }).toList()).toList(),
      "quiz_history"      : model.quizHistory,
      "total_questions_solved" : bx.total_questions[0],
      "time_spent_practicing": total_time,
    };

    await DronaService(plat).updateUserData(model.id,content);

    model.update_total_questions_solved(total_questions_solved: bx.total_questions[0]);
    model.update_time_spent_practicing(time_spent_practicing: total_time);

    //print("Time elapsed: ${_timer}");
  }

  updateQuizHistoryState(List<QuizHistory> x) async {
    setState(() {
      context.read<UserModel>().updateTestHistory(quizHistory: x);
      Provider.of<Quizhistory>(context, listen: false).updateQuizHistory(histroy_array: x);
    });
    //print("added successfully: $x");
  }

  updateGraphData(int xtotal_questions, int xcorrect_answers) async {
    var bx    = Provider.of<QandaHistoryModel>(context, listen: false);
    var model = context.read<UserModel>();
    var user     = await DronaService(plat).getUserData(model.id);
    var graphPerformanceData = user['graph_performance_data'];
    int time = user['time_spent_practicing'];


    List<int> total_questions = graphPerformanceData[0].cast<int>();
    List<int> correct_answers = graphPerformanceData[1].cast<int>();
    List<DateTime> total_days = graphPerformanceData[2].map<DateTime>((date) {
      return DateTime.parse(date); // Assuming date is in a parsable format (e.g., "2024-08-16")
    }).toList();

    //print("Questions total :$total_questions");
    //print("Correct answer : $correct_answers");
    //print("Total days :${total_days.toString()}");

    //final graph_box = await Hive.openBox('QandA');

    //List<int> total_questions = await graph_box.get('total_questions') ?? [0];
    //List<int> correct_answers = await graph_box.get('correct_answers') ?? [0];
    //List<DateTime> total_days = (await graph_box.get('days') as List<dynamic>?)?.map((e) => e as DateTime).toList() ?? [DateTime.now()];

    // fetch user data, particularly the above 3 filed , append data to it then update the quill db database

    DateTime today = DateTime.now();
    bool updated = false;

    // Check if today's date is already in the list
    for (int i = 0; i < total_days.length; i++) {
      if (
      total_days[i].year == today.year && total_days[i].month == today.month && total_days[i].day == today.day) {
        total_questions[i] += xtotal_questions;
        correct_answers[i] += xcorrect_answers;
        updated = true;
        break;
      }
    }
    if (!updated) {
      total_questions.add(xtotal_questions);
      correct_answers.add(xcorrect_answers);
      total_days.add(today);
    }
    List<List<dynamic>> updated_graphPerformanceData = [
      total_questions,
      correct_answers,
      total_days
    ];
    // await graph_box.put('total_questions', total_questions);
    // await graph_box.put('correct_answers', correct_answers);
    // await graph_box.put('days', total_days);
    setState(() {
        bx.answers         = correct_answers;
        bx.total_questions = total_questions;
        bx.days            = total_days;
        context.read<UserModel>().updateGraphData(graph_performance_data: updated_graphPerformanceData);
        total_time = time + _elapsedTime;
      });

    await updateDatabase();

    //print("Days: ${bx.days}");
    //print("Answers: ${bx.answers}");
    //print("Total_Questions: ${bx.total_questions}");
  }

  show_loading(){
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Curved corners
          ),
          //backgroundColor: Colors.black, // Transparent background
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.85), // Semi-transparent white background
              borderRadius: BorderRadius.circular(20.0),
              shape: BoxShape.rectangle
            ),
            width: 300.0, // Set a fixed width for the container
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Submitting Test ..',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300,color: Colors.white),
                ),
                SizedBox(height: 0.0),
                Container(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Color(0xFF00968A),
                  )
                ),
              ],
            ),
          ),
        );
      },
    );

  }

}
