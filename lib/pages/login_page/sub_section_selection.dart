import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_drona/drona_service.dart';
import 'package:provider/provider.dart';
import '../../Main_Screen.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../model/quiz_history_model.dart';
import '../../model/subject.dart';
import '../../model/user_model.dart';

class SubSectionSelection extends StatefulWidget {
  final String name;
  final String email;
  final String dob;
  final String number;
  final String selected_subject;
  final int options;

  const SubSectionSelection({
    super.key,
    required this.name,
    required this.email,
    required this.dob,
    required this.number,
    required this.selected_subject,
    required this.options
  });

  @override
  State<SubSectionSelection> createState() => _SubSectionSelectionState();
}

class _SubSectionSelectionState extends State<SubSectionSelection> with TickerProviderStateMixin{
  late Future<List<Subject>> futureSubjects;
  String _selectedSubject = '';

  bool _showOptions = false;
  bool _showNextButton = false;

  int _selectedIndex = -1;

  late List<AnimationController> _fadeControllers;
  late List<Animation<double>> _fadeAnimations;
  late AnimationController _nextButtonController;
  late Animation<double> _nextButtonFadeAnimation;

  @override
  void dispose() {
    for (final controller in _fadeControllers) {
      controller.dispose();
    }
    _nextButtonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureSubjects = DronaService().getSubjects();

    _fadeControllers = List<AnimationController>.generate(
      16, (int index) => AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    ),
    );

    _fadeAnimations = _fadeControllers
        .map((controller) => Tween<double>(begin: 0, end: 1).animate(controller))
        .toList();

    _nextButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _nextButtonFadeAnimation = Tween<double>(begin: 0, end: 1).animate(_nextButtonController);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final model = context.read<UserModel>();
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            height > 700 ? SizedBox(height: 20,) : Container(),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: Image.asset('assets/images/login_bg@2x.png').image,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 20.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (Theme.of(context).brightness == Brightness.dark)
                                Image.asset(
                                  'assets/blogo.png',
                                  width: 120.0,
                                  height: 120.0,
                                  fit: BoxFit.contain,
                                ),
                              if (!(Theme.of(context).brightness == Brightness.dark))
                                Image.asset(
                                  'assets/flogo.png',
                                  width: 120.0,
                                  height: 120.0,
                                  fit: BoxFit.fitWidth,
                                ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 150,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: DefaultTextStyle(
                                style:  TextStyle(
                                  fontSize: height > 700 ? 32 : 30,
                                  fontFamily: 'Bobbers',
                                ),
                                child: AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      "Which optional subject are you preparing for?",
                                      textStyle: TextStyle(
                                        fontSize: height > 700 ? 32 : 30,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness == Brightness.dark ?  Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                  onFinished: () {
                                    setState(() {
                                      _showOptions = true;
                                    });
                                    for (int i = 0; i < _fadeControllers.length; i++) {
                                      Future.delayed(Duration(milliseconds: i * 150), () {
                                        _fadeControllers[i].forward();
                                      });
                                    }
                                    // Future.delayed(Duration(milliseconds: _fadeControllers.length * 150 + 500), () {
                                    //   _nextButtonController.forward();
                                    // });
                                  },
                                  onTap: () {
                                    print("Tap Event");
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
        
                        Positioned(
                          top: height > 700 ? MediaQuery.of(context).size.height/3.2 : MediaQuery.of(context).size.height/2.3,
                          left: 0,
                          right: 0,
                          bottom: height > 700 ? MediaQuery.of(context).size.height/3.9 : MediaQuery.of(context).size.height/6.2,
                          child: SizedBox(
                            height: 400,
                            child: FutureBuilder<List<Subject>>(
                              future: futureSubjects,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: Container());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (snapshot.hasData) {
                                  List<Subject> subjects = snapshot.data!;
        
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: subjects.length,
                                    itemBuilder: (context, index) {
                                      //final stream = subjects[index];
                                      Subject subject = subjects[index];
                                      return AnimatedBuilder(
                                        animation: _fadeAnimations[index],
                                        builder: (context, child) {
                                          return Opacity(
                                            opacity: _fadeAnimations[index].value,
                                            child: GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  _selectedIndex = index;
                                                  _selectedSubject = subject.name;
                                                  _showNextButton = true;
                                                  _nextButtonController.forward();
                                                });
                                                print(_selectedSubject);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width - 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: _selectedIndex == index ? FlutterFlowTheme.of(context).tertiary : Colors.white,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        subject.name,
                                                        style: TextStyle(
                                                          color: _selectedIndex == index ? Colors.white : Colors.black,
                                                          fontWeight: _selectedIndex == index ? FontWeight.w600 : null,
                                                          letterSpacing: 2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  return Center(child: Text('No subjects found'));
                                }
                              },
                            ),
                          ),
                        ),
        
                        Positioned(
                          top: height > 700 ? MediaQuery.of(context).size.height/1.4 : MediaQuery.of(context).size.height/1.2,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FadeTransition(
                                opacity: _nextButtonFadeAnimation,
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  text: 'Back',
                                  options: FFButtonOptions(
                                    width: MediaQuery.of(context).size.width /2.2,
                                    height: 45.0,
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      fontFamily: 'Lexend',
                                      letterSpacing: 0.0,
                                    ),
                                    elevation: 3.0,
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                              FadeTransition(
                                opacity: _nextButtonFadeAnimation,
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    List<QuizHistory> quizHistory = [];
                                    if (_selectedSubject.isNotEmpty) {
                                      //await updateDataOnQuillDb();
                                      await updateDataOnQuillDb(
                                          widget.name,
                                          widget.email,
                                          widget.dob,
                                          widget.number,
                                          widget.selected_subject,
                                          _selectedSubject,
                                          quizHistory,
                                          "https://www.shareicon.net/data/128x128/2016/05/24/770126_man_512x512.png"
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
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please fill in all required fields'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  text: 'Next',
                                  options: FFButtonOptions(
                                    width: MediaQuery.of(context).size.width /2.2,
                                    height: 45.0,
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      fontFamily: 'Lexend',
                                      letterSpacing: 0.0,
                                    ),
                                    elevation: 3.0,
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  updateDataOnQuillDb(
      String name,
      String email,
      String dob,
      String number,
      String subject,
      String sub_subjects,
      List<QuizHistory> quizHistory,
      String profilePicture
      ) async {

    String rank = "4267";
    double crLeft = 300;
    double crRect = 300;
    List<List<dynamic>> graph_performance_data = [
      <int>[], // First list for integers
      <int>[], // Second list for integers
      <DateTime>[] // Third list for DateTime objects
    ];
    var content = {
      "name"    : name ,
      "dob"     : dob ,
      "email"   : email ,
      'profile_picture' : profilePicture,
      "subject" : subject ,
      "sub_subjects" : sub_subjects ,
      "phone_number" : number ,
      "address"      : '',
      "credits_left"      : crLeft,
      "credits_recharged" : crRect,
      "graph_performance_data": graph_performance_data,
      "quiz_history": quizHistory,
      "total_questions_solved" : 0,
      "time_spent_practicing": 0,
      "strongest_subject" : 'Less-Data',
      "weakest_subject" : 'Less-Data'
    };

    await DronaService()
        .create_user(
        content,
        context,
        name,
        dob,
        email,
        subject,
        sub_subjects,
        number,
        crLeft,
        crRect,
        profilePicture,
        graph_performance_data

    );
  }
}

class SlideDownPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideDownPageRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 0.0);
      const end = Offset(0.0, 1.0);
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
