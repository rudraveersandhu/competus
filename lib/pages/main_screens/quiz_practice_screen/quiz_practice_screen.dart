import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import '../../../drona_service.dart';
import '../../../main.dart';
import '../../../model/subject.dart';
import '../../../model/user_model.dart';
import '../../quiz_screens/quiz_introduction.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
export 'm_y_budgets_model.dart';

class QuizPracticeScreen extends StatefulWidget {
  const QuizPracticeScreen({super.key});

  @override
  State<QuizPracticeScreen> createState() => _QuizPracticeScreenState();
}

class _QuizPracticeScreenState extends State<QuizPracticeScreen>
    with TickerProviderStateMixin {
  late List<String> filteredSubjects;
  late Future<List<String>> futureSubjects;
  List<String> questionCountValues = [];

  //List<String> questionCountValues = List.generate(5, (index) => "30 questions");

  late List<Animation<double>> _fadeAnimations;
  bool isToggleOn = false;
  final List<String> dropdownOptions = ['Easy', 'Medium', 'Hard'];
  TextEditingController searchController = TextEditingController();

  String searchQuery = '';

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};
  late List<AnimationController> _fadeControllers;
  int _selectedIndex = -1;

  late String sub;
  late List<String> dropdownValues; // List to store dropdown values for each option card

  getSubjects() async {

    var model = context.read<UserModel>();

    sub = model.subject;

  }

  @override
  void initState() {
    super.initState();
    getSubjects();
    futureSubjects = DronaService(plat).getTopicsForSubject(sub);


    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });

    futureSubjects.then((subjects) {
      // Initialize these lists based on the number of subjects
      questionCountValues = List.generate(subjects.length, (index) => "30 questions");
      dropdownValues = List<String>.filled(subjects.length, 'Easy'); // Adjust based on subject count
      setState(() {}); // Update the UI with the new list lengths
    });

    // Initialize controllers and animations
    _fadeControllers = List<AnimationController>.generate(
      16,
          (int index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _fadeAnimations = _fadeControllers
        .map((controller) =>
        Tween<double>(begin: 0, end: 1).animate(controller))
        .toList();

    animationsMap.addAll({
      // (Your animation map configuration)
    });

    setupAnimations(
      animationsMap.values
          .where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        title: Text(
          'Quiz Practice',
          style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 30,
              fontWeight: FontWeight.w300),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: FlutterFlowTheme.of(context).primaryBackground,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Subjects',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF00968A),
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
              FutureBuilder<List<String>>(
                future: futureSubjects,

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        child: LoadingBouncingGrid.square(
                          borderColor: Color(0xFF00968A),
                          borderSize: 1.0,
                          size: 40.0,
                          backgroundColor: Color(0xFF00968A),
                          duration: Duration(milliseconds: 800),
                        ));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    filteredSubjects = snapshot.data!.where((subject) {
                      return subject
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                    }).toList();

                    return Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ListView.builder(
                      itemCount: filteredSubjects.length,
                      itemBuilder: (context, index) {
                        if (index < dropdownValues.length && index < questionCountValues.length) {
                          return optionCards(filteredSubjects[index], '100', index); // Pass the index
                        } else {
                          return SizedBox(
                            height: 30,
                          ); // Return an empty widget or handle gracefully
                        }
                      },
                    )

                  );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget optionCards(String topic, String marks, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => QuizIntroduction(
              topic: topic,
              level: dropdownValues[index],
              question_count: questionCountValues[index]
            ),
          ),
        );
      },
      child: optionCard(
        context: context,
        title: "Total Questions : 30 ",
        subtitle: topic,
        description1: "Max Marks : ",
        description2: "Max Marks : ",
        description3: marks,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        textColor: FlutterFlowTheme.of(context).textColor,
        dropdownValue: dropdownValues[index],
        onDropdownChanged: (String? newValue) {
          if (newValue != null) {

            setState(() {
              dropdownValues[index] = newValue;
            });

          }
        },
        questionCountValue: questionCountValues[index],
        onQuestionCountChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              questionCountValues[index] = newValue;
            });
          }
        },
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
    required String dropdownValue,
    required void Function(String?)? onDropdownChanged,
    required String questionCountValue, // Receive the specific question count value
    required void Function(String?)? onQuestionCountChanged, // Function to handle question count changes
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
      child: Container(
        width: 100.0,
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
                padding:
                const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      Text(
                        description3,
                        textAlign: TextAlign.end,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Lexend',
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white24,
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_downward, color: Colors.white),
                        iconSize: 20,
                        elevation: 16,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Lexend',
                          color: Colors.white,
                        ),
                        dropdownColor: FlutterFlowTheme.of(context).primary,
                        underline: Container(
                          height: 0,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                        onChanged: onDropdownChanged,
                        items: dropdownOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width /3.3,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white24,
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: questionCountValue,
                        icon: Icon(Icons.arrow_downward, color: Colors.white),
                        iconSize: 20,
                        elevation: 16,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Lexend',
                          color: Colors.white,
                        ),
                        dropdownColor: FlutterFlowTheme.of(context).primary,
                        underline: Container(
                          height: 0,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                        onChanged: onQuestionCountChanged,
                        items: ["30 questions", "50 questions", "100 questions"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

