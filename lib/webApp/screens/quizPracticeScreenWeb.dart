import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

import '../../drona_service.dart';
import '../../flutter_flow/flutter_flow_animations.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../main.dart';
import '../../model/user_model.dart';
import '../../pages/quiz_screens/quiz_introduction.dart';

class QuizPracticeScreenWeb extends StatefulWidget {
  const QuizPracticeScreenWeb({super.key});

  @override
  State<QuizPracticeScreenWeb> createState() => _QuizPracticeScreenWebState();
}

class _QuizPracticeScreenWebState extends State<QuizPracticeScreenWeb> with TickerProviderStateMixin {
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

    return Consumer<UserModel>(
        builder: (context, model, child)  {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: FlutterFlowTheme.of(context).primaryBackground,
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
                          'Quiz Practice',
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
                      Expanded(
                        child: FutureBuilder<List<String>>(
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
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              filteredSubjects = snapshot.data!.where((subject) {
                                return subject
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase());
                              }).toList();

                              return SingleChildScrollView(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Wrap(
                                      // Vertical space between the rows
                                      children: List.generate(
                                        filteredSubjects.length,
                                            (index) {
                                          if (index < dropdownValues.length && index < questionCountValues.length) {
                                            return optionCards(filteredSubjects[index], '100', index); // Pass the index
                                          } else {
                                            return SizedBox(height: 30); // Handle gracefully
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        });


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
        width: MediaQuery.of(context).size.width/2.8,
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
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: subtitle,
                      style: FlutterFlowTheme.of(context).displaySmall.override(
                        fontFamily: 'Lexend',
                        color: textColor,
                        letterSpacing: 0.0,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: '\n', // Force a new line
                      style: TextStyle(
                        fontSize: 22, // Same font size to maintain height consistency
                      ),
                    ),
                  ],
                ),
                maxLines: 2, // Ensures only 2 lines are shown
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
                    width: 150,
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