import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../drona_service.dart';
import '../../flutter_flow/flutter_flow_animations.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../main.dart';
import '../../model/quiz_history_model.dart';
import '../../model/user_model.dart';
import '../../pages/splash_screen.dart';
import '../../quiz_history_screen.dart';

class TestHistoryScreenWeb extends StatefulWidget {
  const TestHistoryScreenWeb({super.key});

  @override
  State<TestHistoryScreenWeb> createState() => _TestHistoryScreenWebState();
}

class _TestHistoryScreenWebState extends State<TestHistoryScreenWeb> with TickerProviderStateMixin {
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

  final TextEditingController _dateController = TextEditingController();

  getSubjects() {
    var model = context.read<UserModel>();
    sub = model.subject;

    setState(() {
      _filteredQuizHistory = model.quizHistory;
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    _dateController.dispose();
    for (var controller in _fadeControllers) {
      controller.dispose();
    }
    super.dispose();
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked =
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade300, // Change the primary color
            ),
            dialogTheme: DialogTheme( shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
            )
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      //print(_dateController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
        builder: (context, model, child) {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,

            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/images/login_bg@2x.png'),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Container(
                              width: 200,
                              child: TextField(
                                decoration: InputDecoration(
                                    prefixIcon: Icon(CupertinoIcons.search,size: 20,),
                                    hintText: 'Search for anything',
                                    hintStyle: TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none
                                    )
                                ),
                              )
                          ),
                        ),


                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5,right: 5,top: 2
                              ),
                              child: Icon(CupertinoIcons.book,
                                size: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5,right: 5,top: 2
                              ),
                              child: Icon(CupertinoIcons.rocket,
                                size: 18,
                              ),
                            ),
                            Padding(

                              padding: const EdgeInsets.only(
                                  left: 5,right: 5,top: 2
                              ),
                              child: Icon(CupertinoIcons.settings,
                                size: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Container(
                                height: 30,
                                child: VerticalDivider(
                                  thickness: .5,
                                  color: Colors.black,

                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2, left: 1, right: 1),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Color(0xFF00968A),
                                backgroundImage: NetworkImage(model.profilePicture),
                                onBackgroundImageError: (exception, stackTrace) {
                                  print('Could not load image.');
                                },
                                child: model.profilePicture == null
                                    ? Icon(Icons.error_outline, color: Colors.white, size: 16)
                                    : null, // Remove child, since backgroundImage handles the image loading
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: PopupMenuButton<String>(
                                color: Color(0xFF00968A),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black, // Adjust arrow color if needed
                                ),
                                onSelected: (String value) {
                                  // Handle option selection
                                  print(value);
                                },
                                itemBuilder: (BuildContext context) {
                                  List<IconData> iconsList = [
                                    CupertinoIcons.person,
                                    CupertinoIcons.rocket,
                                    CupertinoIcons.settings,
                                    CupertinoIcons.star,
                                    CupertinoIcons.arrow_left_circle,
                                  ];

                                  return ['Profile', 'Feedback', 'Settings', 'Star', 'Logout']
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key; // Get the index
                                    String option = entry.value; // Get the option

                                    return PopupMenuItem<String>(
                                      value: option,
                                      child: Container(
                                        width: 150.0, // Set the width of the popup menu item
                                        child: Row(
                                          children: [
                                            Icon(
                                              iconsList[index],
                                              size: 14,
                                              color: Colors.white,
                                            ), // Use the index to select the corresponding icon
                                            SizedBox(width: 8.0), // Add some space between the icon and text
                                            Text(
                                              option,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                elevation: 0, // No shadow
                              ),
                            ),
                          ],
                        ),


                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0,top: 28),
                    child: Text(
                      'Quiz History',
                      style: FlutterFlowTheme.of(context).displaySmall.override(
                          fontFamily: 'Lexend',
                          letterSpacing: 0.0,
                          fontSize: 30,
                          // Reduces the gap between the lines
                          lineHeight: 1,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
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
                              setState(() {
                                _selectDate(context);
                              });
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

                  // GestureDetector(
                  //   onTap: (){
                  //     printAPIdata();
                  //   },
                  //   child: Container(
                  //     height: 30,
                  //     width: 100,
                  //     decoration: BoxDecoration(
                  //         color: Color(0xFF00968A),
                  //       borderRadius: BorderRadius.circular(30)
                  //     ),
                  //     child: Center(
                  //       child: Text("TEST API",
                  //       style: TextStyle(
                  //         color: Colors.white
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height/1.5,
                      child: ListView.builder(
                        itemCount: _filteredQuizHistory.length,
                        itemBuilder: (context, index) {
                          //print("History Length: ${_filteredQuizHistory.length}");
                          final quizHistory = _filteredQuizHistory[index];
                          final List<String> questions = quizHistory.questions.map((question) => question.questionText).toList();
                          final List<List<String>> answers = quizHistory.questions.map((question) => question.options).toList();
                          final List<String> correctAnswers = quizHistory.questions.map((question) => question.correctAnswer).toList();
                          List<String> userAnswers = quizHistory.userAnswers;
                          String level = quizHistory.level;
                          int num_of_ques = quizHistory.numOfQues;

                          return Slidable(
                            endActionPane: ActionPane(

                              motion: ScrollMotion(),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Container(
                                    width: 215,
                                    child: Column(
                                      children: [
                                        SlidableAction(
                                          onPressed: ((context) {
                                            get_history_then_delete(index);
                                          }

                                          ),

                                          backgroundColor: Colors.black.withRed(400),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          icon: Icons.delete,
                                          label: 'Delete',
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomLeft: Radius.circular(25)),

                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            child: optionCards(
                                quizHistory.subjectName,
                                quizHistory.markAchieved.toString(),
                                quizHistory.totalMarks.toString(),
                                questions,
                                answers,
                                correctAnswers,
                                userAnswers,
                                level,
                                num_of_ques
                            ),


                          );

                          // return optionCards(
                          //   quizHistory.subjectName,
                          //   quizHistory.markAchieved.toString(),
                          //   quizHistory.totalMarks.toString(),
                          //   questions,
                          //   answers,
                          //   correctAnswers,
                          //   userAnswers,
                          //   level,
                          //   num_of_ques
                          // );
                        },
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        }
    );
  }

  printAPIdata(){
    var model = context.read<UserModel>();
    print(model.subject);
    print(model.subsubject);
    var x = DronaService(plat).fetchAPiQuestions(1,"UGC NET","");
    print(x);
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
        width: MediaQuery.of(context).size.width,

        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 15),
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

  get_history_then_delete(int index) async {
    var model = context.read<UserModel>();

    final user_box = await Hive.openBox('user');

    var headers = {'Accept': 'application/json'};
    var request = http.Request('GET', Uri.parse('https://db.quilldb.io/users/${model.id}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      //print("data mil hai ye ${await data}");
      var jsonData = jsonDecode(data);

      fetch_history(jsonData,index);

    } else {

      var data = await response.stream.bytesToString();

      var jsonData = jsonDecode(data);

      //print("data else${jsonData}");

      //print(jsonData['detail']);

      if(jsonData['detail'].toString() == "404: User not found"){

        await user_box.put('id','');
        String plat = await getPlatform();

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => SplashScreen(plat: plat),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const curve = Curves.ease;
              var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve)));
              return FadeTransition(
                opacity: fadeAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 700), // Adjust duration to make it slower
          ),
        );
      }
    }
  }

  getPlatform() async {
    String plat = '';
    if (!kIsWeb) {
      // Platform-specific code only runs on non-web platforms.
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

      if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await deviceInfoPlugin.windowsInfo;
        print(windowsInfo);
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
        print(linuxInfo);
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macInfo = await deviceInfoPlugin.macOsInfo;
        print(macInfo);
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        print(androidInfo);
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        print(iosInfo);
      } else {
        // Handle other platforms, like embedded
        print("Unsupported platform");
      }
    } else {
      // Web-specific code
      plat = 'web';
      return plat;
      // You can use browser-related checks or web-specific implementations here.
    }
  }

  fetch_history(Map<String, dynamic> jsonData,int index){
    var model = context.read<UserModel>();
    List<QuizHistory> testHistory = (jsonData['quiz_history'] as List)
        .map((item) => QuizHistory.fromJson(item))
        .toList();

    testHistory.removeAt(index);

    setState(() {
      model.updateTestHistory(quizHistory: testHistory);
      _filteredQuizHistory = testHistory;
    });

    updateDatabase();

  }

  updateDatabase() async {
    var model = context.read<UserModel>();

    var content = {
      "quiz_history"      : model.quizHistory,
    };

    await DronaService(plat).updateUserData(model.id,content);

    print("database updated");
  }
}
