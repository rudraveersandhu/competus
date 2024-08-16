import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_drona/quiz_history_screen.dart';
import 'package:provider/provider.dart';

import 'flutter_flow/flutter_flow_animations.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'model/subject.dart';
import 'model/user_model.dart';

class TestHistory extends StatefulWidget {
  const TestHistory({super.key});

  @override
  State<TestHistory> createState() => _TestHistoryState();
}

class _TestHistoryState extends State<TestHistory>
    with TickerProviderStateMixin {
  late Future<List<Subject>> futureSubjects;
  List<NeatCleanCalendarEvent> events = [];


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

  getSubjects() async {
    var model = context.read<UserModel>();
    sub = model.subject;
  }

  @override
  void initState() {
    super.initState();
    getSubjects();
    //futureSubjects = DronaService().getallSubjects(sub);

    _fadeControllers = List<AnimationController>.generate(
      16, (int index) => AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    ),
    );

    _fadeAnimations = _fadeControllers
        .map((controller) => Tween<double>(begin: 0, end: 1).animate(controller))
        .toList();




    animationsMap.addAll({
      'circleImageOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 19.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 50.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 50.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 50.0.ms,
            duration: 600.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textFieldOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textFieldOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 40.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textFieldOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 60.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'buttonOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 40.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'buttonOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 40.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("test history screen");
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0,top: 20),
          child: Text(
              'Test History',
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 30,
                  fontWeight: FontWeight.w300
              )
          ),
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: Image.asset(
              'assets/images/login_bg@2x.png',
            ).image,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '"Subjects:"',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon( Icons.search,
                    color: Color(0xFF00968A),
                  ),
                  suffixIcon:Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        _addNewEvent();

                      },
                      child: Icon( Icons.calendar_month_outlined,
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
            Divider(height: 1,),
            Consumer<UserModel>(
              builder: (context, quizHistoryProvider, child) {
                print(quizHistoryProvider.quizHistory);
                return Container(
                  height: MediaQuery.of(context).size.height/1.5,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: quizHistoryProvider.quizHistory.length,
                    itemBuilder: (context, index) {

                      final quizHistory = quizHistoryProvider.quizHistory[index];
                      final List<String> questions = quizHistoryProvider.quizHistory[index].questions.map((question) => question.questionText).toList();
                      final List<List<String>> answers = quizHistoryProvider.quizHistory[index].questions.map((question) => question.options).toList();
                      final List<String> correct_answers = quizHistoryProvider.quizHistory[index].questions.map((question) => question.correctAnswer).toList();
                      List<String> userAnswers = quizHistory.userAnswers;

                      print("Questions hai: $questions");
                      print("");
                      return optionCards(
                        quizHistory.subjectName,
                        quizHistory.markAchieved.toString(),
                        quizHistory.totalMarks.toString(),
                        questions,
                        answers,
                        correct_answers,
                        userAnswers,
                      );
                      return ListTile(
                        title: Text('Subject: ${quizHistory.subjectName}'),
                        subtitle: Text('Marks: ${quizHistory.markAchieved} / ${quizHistory.totalMarks}'),
                      );
                    },
                  ),
                );
              },
            )
            // Add other widgets here
          ],
        ),
      ),
    );
  }

  Widget optionCards(
      String SubjectName,
      String achieved_marks,
      String total_marks,
      var questions ,
      var answers,
      var correct_answers,
      var userAnswers
      ) {
    return GestureDetector(
      onTap: (){

        Navigator.push(context, MaterialPageRoute(
            builder: (builder) =>  QuizHistoryScreen(
              subject  : SubjectName,
              questions: questions,
              answers  : answers,
              correct_answers: correct_answers,
              selected_answers: userAnswers,
            )
        ));
      },
      child: optionCard(
        context: context,
        title: "Total Questions : 30 ",
        subtitle: SubjectName,
        description1: "Scored :",
        description2: "Max Scores :",
        description3: total_marks,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        textColor: FlutterFlowTheme.of(context).textColor,
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
                    fontSize: 22
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(2.0, 4.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                            description3,
                            textAlign: TextAlign.end,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Lexend',
                              color:  Colors.white,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w300,
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
                              color:  Colors.white,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),

                      ],
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

  addEvents(String note, DateTime str, DateTime en ) async {
    final box = await Hive.openBox('Events');
    var des = box.get('des') ?? <String>[];
    var start = box.get('start') ?? <DateTime>[];
    var end = box.get('end') ?? <DateTime>[];

    des.add(note);
    start.add(str);
    end.add(en);

    box.put('des', des);
    box.put('start', start);
    box.put('end', end);
    print("Stored to Hive successfully");

  }


  void _handleNewDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formattedDate = formatter.format(date);
    print('Date selected: $formattedDate');
  }

  void _handleNewEvent(NeatCleanCalendarEvent event) {
    print('Event selected: ${event.summary}');
  }

  void _addNewEvent() {
    DateTime? startDate;
    DateTime? endDate;
    String note = '';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Select Date of Exam'),
          content: Container(
            height: 350,
            width: 340,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withOpacity(.9),
            ),
            child:  Calendar(
              startOnMonday: true,
              weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
              //eventsList: widget.events,
              isExpandable: true,
              eventDoneColor: Colors.green,
              selectedColor:Color(0xFF00968A),
              selectedTodayColor: Color(0xFF00968A),
              todayColor: Colors.blue,
              eventColor: Colors.orange,
              locale: 'en_EN',
              todayButtonText: '',
              allDayEventText: 'Ganztägig',
              multiDayEndText: 'Ende',
              isExpanded: true,
              expandableDateFormat: 'EEEE, dd. MMMM yyyy',
              datePickerType: DatePickerType.date,
              onDateSelected: _handleNewDate,
              onEventSelected: _handleNewEvent,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },

              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

}