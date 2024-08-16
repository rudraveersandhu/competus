import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_drona/model/subject.dart';
import 'package:my_drona/pages/login_page/sub_section_selection.dart';
import 'package:provider/provider.dart';
import '../../drona_service.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../model/quiz_history_model.dart';
import '../../model/stream_model.dart';
import '../../model/user_model.dart';


class ExamSelectionScreen extends StatefulWidget {
  final int streamCount;
  final String name;
  final String email;
  final String dob;
  final String number;

  const ExamSelectionScreen({
    super.key,
    required this.streamCount,
    required this.name,
    required this.email,
    required this.dob,
    required this.number
  });

  @override
  State<ExamSelectionScreen> createState() => _ExamSelectionScreenState();
}

class _ExamSelectionScreenState extends State<ExamSelectionScreen> with TickerProviderStateMixin {
  late Future<List<StreamModel>> futureStreams;

  late Subject netStreams;
  String _selectedSubject = '';
  String? _selectedNETSub;
  bool _showOptions = false;
  bool _showNextButton = false;
  int netItems = 0;
  int _selectedIndex = -1;




  late List<AnimationController> _fadeControllers;
  late List<Animation<double>> _fadeAnimations;
  late AnimationController _nextButtonController;
  late Animation<double> _nextButtonFadeAnimation;



  List<StreamModel> getNetSubjects(List<StreamModel> streams) {
    return streams.where((stream) => stream.isNetStream()).toList();
  }


  @override
  void dispose() {
    for (final controller in _fadeControllers) {
      controller.dispose();}

    _nextButtonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureStreams = DronaService().getStreams();

    _fadeControllers = List<AnimationController>.generate(
      widget.streamCount, (int index) => AnimationController(
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
    print(Theme.of(context).brightness);
    var height = MediaQuery.of(context).size.height;

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
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 20.0),
                        child: Column(
                          children: [
                            Row(
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
                                    "Which Competitive exam do you want to prepare for?",
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
                      if (_showOptions)
                        Positioned(
                          top: height > 700 ? MediaQuery.of(context).size.height/3.2 : MediaQuery.of(context).size.height/2.3,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: FutureBuilder<List<StreamModel>>(
                            future: futureStreams,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(child: Text('No streams found'));
                              } else {
                                final streams = snapshot.data!;
                                return Container(
                                  height: 600, // Adjust the height as needed
                                  child: ListView.builder(
                                    itemCount: streams.length,
                                    itemBuilder: (context, index) {
                                      final stream = streams[index];
                                      return AnimatedBuilder(
                                        animation: _fadeAnimations[index],
                                        builder: (context, child) {
                                          return Opacity(
                                            opacity: _fadeAnimations[index].value,
                                            child: GestureDetector(
                                              onTap: () async {
                                                var model = context.read<UserModel>();
                                                setState(() {
                                                  model.subject = stream.stream;
                                                  _selectedIndex = index;
                                                  _selectedSubject = stream.stream;
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
                                                        stream.stream,
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
                                  ),
                                );
                              }
                            },
                          ),
                        ),
        
                      Positioned(
                        top: height > 700 ? MediaQuery.of(context).size.height/1.5 : MediaQuery.of(context).size.height/1.2,
                        left: 20,
                        right: 20,
                        child: AnimatedOpacity(
                          opacity: _showNextButton ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: FFButtonWidget(
                            onPressed: () async {
                              List<QuizHistory> quizHistory = [];
                              if (_selectedSubject.isNotEmpty && (_selectedSubject != 'NET' || _selectedNETSub != null)) {
        
                                await updateDataOnQuillDb(
                                    widget.name,
                                    widget.email,
                                    widget.dob,
                                    widget.number,
                                    _selectedSubject,
                                    "",
                                    "https://www.shareicon.net/data/128x128/2016/05/24/770126_man_512x512.png",
                                    quizHistory
                                );
        
        
                              } else if(_selectedSubject == 'NET'){
        
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => SubSectionSelection(
                                        name: widget.name,
                                        email: widget.email,
                                        dob: widget.dob,
                                        number: widget.number,
                                        selected_subject: _selectedSubject,
                                        options: netItems,
                                      ),
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
        
                              else {
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
                              width: MediaQuery.of(context).size.width - 40,
                              height: 50.0,
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
                      ),
                    ],
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
      String profilePicture,
      List<QuizHistory> quizHistory
      ) async {

      String rank = "4267";
      double crLeft = 300;
      double crRect = 300;
      List<List<dynamic>> graph_performance_data = [
        <int>[], // First list for integers
        <int>[], // Second list for integers
        <DateTime>[] // Third list for DateTime object
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

      print(content);

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
