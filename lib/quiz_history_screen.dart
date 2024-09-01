import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'model/answer_model.dart';

class QuizHistoryScreen extends StatefulWidget {
  final String subject;
  final List<String> questions;
  final List<String> correct_answers;
  final List<List<String>> answers;
  final List<String> selected_answers;
  const QuizHistoryScreen({
    super.key,
    required this.questions,
    required this.answers,
    required this.subject,
    required this.correct_answers,
    required this.selected_answers
  });

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  final PageController _pageController = PageController();

  int _seconds = 0;
  int q_index  = 0; // Start at 1 since it's 1-based index

  List<String> user_answers = []  ;
  String    selected_answer = '0' ;

  int current_page = 0;

  @override
  void initState() {
    super.initState();
    print(widget.selected_answers);
    print(widget.correct_answers);
    user_answers.clear();
    selected_answer = '0';
    q_index = 1;
    _seconds = 0;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Check if the PageController has any positions
    //   if (_pageController.hasClients) {
    //     print("page controller has clients");
    //     final currentPage = _pageController.page?.toInt() ?? 0;
    //     setState(() {
    //       q_index = currentPage + 1;
    //       });
    //     }else{
    //     print("page controller do not have any clients");
    //   }
    //   });
    }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                  'Quit Test History ?',
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
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),

                      child: Center(
                        child: TextButton(
                          child: Text('Yes',
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.of(context).pop(); // Close the QuestionScreen
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



  @override
  Widget build(BuildContext context) {
    //print("Answers: ${widget.answers}");
    var question = Provider.of<AnswerModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [

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
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black54,
                        border: Border.all(color: Colors.white54),
                      ),
                      child: Center(
                        child: Text(
                          "Time",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
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
                            return buildQuestionPage(context, widget.questions[index], question, index);
                          },
                        ),
                      ),
                    ],
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
                              borderRadius: BorderRadius.circular(20),
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
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: GestureDetector(
                        onTap: () {
                          if (_pageController.page?.toInt() == widget.questions.length ) {
                            // Handle end of quiz
                          } else {
                            //user_answers.add(selected_answer);
                            //Provider.of<AnswerModel>(context, listen: false).all_false();
                            //selected_answer = '0';
                            _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                          }
                          setState(() {
                            current_page = _pageController.page!.toInt();
                          });

                          //print("${widget.questions.length}/$current_page");
                          //print(_pageController.page?.toInt());

                        },
                        child: current_page < widget.questions.length -2   ? Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: .5)),
                          child: Center(
                            child: Text(
                              'Next',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ) :
                          GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width / 3.2,
                            decoration: BoxDecoration(
                                color: Colors.black54.withGreen(41),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white, width: .5)),
                            child: Center(
                              child: Text(
                                'Exit',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    color: Colors.white),
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
    List<String> currentAnswers = widget.answers[index];

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 100,
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 1.4,
              width: MediaQuery.of(context).size.width - 60,
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 90,
              height: (MediaQuery.of(context).size.height / 1.4) / 2.3,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height / 1.4 / 2.4,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 20),
                    child: Text(
                      questionText,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height/2.4,
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
                    currentAnswers[0],
                  index
                ),
                buildAnswerOption(
                    context,
                    question,
                    selected_answer == 'B',
                    'B)',
                    currentAnswers[1],
                  index
                ),
                buildAnswerOption(
                    context,
                    question,
                    selected_answer == 'C',
                    'C)',
                    currentAnswers[2],
                  index
                ),
                buildAnswerOption(
                    context,
                    question,
                    selected_answer == 'D',
                    'D)',
                    currentAnswers[3],
                  index
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget buildAnswerOption(
      BuildContext context,
      AnswerModel question,
      bool isSelected,
      String number,
      String option,
      int index) {

    //bool check = answerText == widget.selected_answers[index];
    return QuestionHistoryBlock(
      number: number,
      option: option,
      correctAnswer : widget.correct_answers[index],
      //block_color: check ? Color(0xFF00968A).withBlue(600) : Colors.white54,
        textColor: isSelected ? Colors.white : Colors.white,
      userAnswer: widget.selected_answers[index],
    );
  }
  }

class QuestionHistoryBlock extends StatefulWidget {
  final String option;
  final String correctAnswer;
  final String number;
  final String userAnswer;
  final Color textColor;


  const QuestionHistoryBlock({
    super.key,
    required this.number,
    required this.option,
    required this.correctAnswer,
    required this.userAnswer,
    required this.textColor,

  });

  @override
  State<QuestionHistoryBlock> createState() => _QuestionHistoryBlockState();
}

class _QuestionHistoryBlockState extends State<QuestionHistoryBlock> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build( BuildContext context ) {
    String ans = widget.correctAnswer + ")";
    return Center(
      child: Container(
        height: (MediaQuery.of(context).size.height / 2.5) / 6,
        width: MediaQuery.of(context).size.width - 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.option == widget.correctAnswer ? Colors.green : widget.option == widget.userAnswer ? Colors.red.shade300 : Colors.white54,
          border: Border.all(
            color: Colors.white,
            width: .5,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 120,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("${widget.number} ${widget.option}",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: widget.textColor,
                    ),
                  ),
                ),
              ),
            ),
            widget.number == ans ? const Positioned(
              top: 0,
              bottom: 0,
              right: 10,
              child: Icon(Icons.done),
            ): Container(),

          ],
        ),
      ),
    );
  }
}

