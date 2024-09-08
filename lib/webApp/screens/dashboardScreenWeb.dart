import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:marquee_text/marquee_direction.dart';
import 'package:marquee_text/marquee_text.dart';

import 'package:marquee_text/vertical_marquee_text.dart';
import 'package:my_drona/webApp/main_screen_web.dart';
import 'package:my_drona/webApp/spiderChartWidget.dart';
import 'package:provider/provider.dart';

import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';


import '../../flutter_flow/flutter_flow_animations.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../main.dart';
import '../../model/user_model.dart';
import '../../new_screen.dart';
import '../../pages/main_screens/dashboard_Screen/m_y_card_model.dart';
import '../../spline_charts.dart';

class DashboardScreenWeb extends StatefulWidget {
  const DashboardScreenWeb({super.key});

  @override
  State<DashboardScreenWeb> createState() => _DashboardScreenWebState();
}

class _DashboardScreenWebState extends State<DashboardScreenWeb> with TickerProviderStateMixin {
  late MYCardModel _model;
  late bool isShowingMainData;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  late ValueNotifier<double> valueNotifier;

  int _counter = 0;
  late int _counter1 ;

  late int _counter2 ;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var model = context.read<UserModel>();
    print(model.total_questions_solved);

    _counter1 = model.total_questions_solved;
    _counter2 = model.time_spent_practicing;
  }

  String name = '';
  @override
  void initState() {
    super.initState();
    var model = context.read<UserModel>();
    isShowingMainData = true;
    //fetch_total_solved_Questions();
    _model = createModel(context, () => MYCardModel());


    valueNotifier = ValueNotifier(model.credits_left);
    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _counter = 004;
        });
      }
    });

    animationsMap.addAll({
      'rowOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.4, 1.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 49.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
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
            begin: const Offset(0.0, 51.0),
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
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 80.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 80.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 69.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 80.0.ms,
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

  changeRank(int rank){
    setState(() {
      _counter = rank;
    });
  }

  @override
  void dispose() {
    _model.dispose();
    valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    List<String> stringList = [
      ' 1) Who is responsible for regulating elections in India?\n',
      '\n',
      ' 2) What is the process of electing a new judge?\n',
      '\n',
      ' 3) How is a new law approved and passed?\n',
      '\n',
      ' 4) How is the budget made and released?\n',
      '\n',
      ' 5) What are the new criminal laws?\n',
      '\n',
      ' 6) Compare Nyaya Sanhita vs IPC?\n',
    ];


    return Consumer<UserModel>(
        builder: (context, model, child)  {

          return Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: height,
                  width: width,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
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
                          padding: const EdgeInsets.only(left: 30.0,top: 30,bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dashboard',
                                  style: FlutterFlowTheme.of(context).displaySmall.override(
                                      fontFamily: 'Lexend',
                                      letterSpacing: 0.0,
                                      fontSize: 30,
                                      // Reduces the gap between the lines
                                      lineHeight: 1,
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                                Text(
                                  "Here's your exam analytics and data",
                                  style: FlutterFlowTheme.of(context).displaySmall.override(
                                      fontFamily: 'Lexend',
                                      letterSpacing: 0.0,
                                      fontSize: 14,
                                      lineHeight: 2
                                  ),
                                ),


                            ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2,right: 40),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 45,
                                    child: Icon(
                                      CupertinoIcons.bell,

                                      size: 28,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        color: Colors.red
                                      ),
                                      child: Center(child: Padding(
                                        padding: const EdgeInsets.only(bottom: 1.0,right: 1),
                                        child: Text("+3",style: TextStyle(color: Colors.white,fontSize: 10),),
                                      ),),
                                    ),
                                  )
                                ],
                              ),
                            ),

                          ],
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => NewScreen(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        var begin = 0.0;
                                        var end = 1.0;
                                        var curve = Curves.easeInOut;

                                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                        var scaleAnimation = animation.drive(tween);
                                        var rotateAnimation = Tween(begin: 0.0, end: 2.0 * 3.141592653589793).animate(animation);
                                        var flipAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);

                                        return AnimatedBuilder(
                                          animation: animation,
                                          child: child,
                                          builder: (context, child) {
                                            return Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.identity()
                                                ..rotateX(flipAnimation.value * 3.141592653589793)
                                                ..scale(scaleAnimation.value),
                                              child: child,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.37,
                                      height: height * 0.3 ,
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 6.0,
                                            color: Colors.black,//Color(0x4B1A1F24),
                                            offset: Offset(
                                              0.0,
                                              2.0,
                                            ),

                                          )
                                        ],
                                        color: Color(0xFF00968A),
                                        borderRadius: BorderRadius.circular(25.0),
                                        border: Border.all(color: dark_mode ? Colors.white : Color(0xFF00968A),
                                        width: .5
                                        )
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,

                                        children: [
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  model.name,
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                      fontFamily: 'Lexend',
                                                      color: FlutterFlowTheme.of(context).textColor,
                                                      letterSpacing: 0.0,
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(21.0, 0.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  "Plan : ",
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                      fontFamily: 'Lexend',
                                                      color: FlutterFlowTheme.of(context).textColor,
                                                      letterSpacing: 0.0,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w300),
                                                ),
                                                Text(
                                                  "Basic",
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                      fontFamily: 'Lexend',
                                                      color: Colors.white70,
                                                      letterSpacing: 0.0,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(21.0, 0.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  "Subject : ",
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                      fontFamily: 'Lexend',
                                                      color: FlutterFlowTheme.of(context).textColor,
                                                      letterSpacing: 0.0,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w300),
                                                ),
                                                Text(
                                                  model.subject,
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                      fontFamily: 'Lexend',
                                                      color: Colors.white70,
                                                      letterSpacing: 0.0,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 60,),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0,top: 10),
                                                    child: Text(
                                                      "National Rank:",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0, top: 5),
                                                    child: Container(
                                                      height: (height / 6) / 5 ,
                                                      width: MediaQuery.of(context).size.width/5,
                                                      color: Colors.white38,
                                                      child: AnimatedFlipCounter(
                                                        hideLeadingZeroes: false,
                                                        wholeDigits: 6,
                                                        duration: Duration(
                                                            milliseconds: 500
                                                        ),
                                                        value: int.parse(model.rank.toString().padLeft(6, '0')),
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          //letterSpacing: 9.0,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top:0,
                                      right: 5,
                                      bottom: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 40.0),
                                        child: SimpleCircularProgressBar(
                                          size: 120,
                                          valueNotifier: valueNotifier,
                                          maxValue: model.credits_recharged,
                                          progressStrokeWidth: 6,
                                          backStrokeWidth: 4,
                                          mergeMode: true,
                                          animationDuration: 2,
                                          onGetText: (value) {
                                            return Text(
                                              '${value.toInt()} \n Credits left',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14),
                                              textAlign: TextAlign.center,
                                            );
                                          },
                                          progressColors: [
                                            Colors.white,
                                            Colors.white,
                                          ],
                                          backColor: Colors.black.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation']!),
                            ),
                            Row(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10,right: 4),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigator.push(context, MaterialPageRoute(
                                          //     builder: (builder) => QuizIntroduction()));
                                        },
                                        child: Container(
                                          width: MediaQuery
                                              .sizeOf(context)
                                              .width * 0.2,
                                          decoration: BoxDecoration(

                                            color: dark_mode? FlutterFlowTheme
                                                .of(context)
                                                .primaryBackground : FlutterFlowTheme
                                                .of(context)
                                                .secondaryBackground,

                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x3F14181B),
                                                offset: Offset(
                                                  0.0,
                                                  3.0,
                                                ),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(25.0),
                                              border: Border.all(color: dark_mode ? Color(0xFF00968A) : Colors.white)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 8.0, 0.0, 12.0),
                                                  child: Text("Total Questions \nSolved",
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme
                                                        .of(context)
                                                        .displaySmall
                                                        .override(
                                                      fontFamily: 'Lexend',
                                                      color:
                                                      FlutterFlowTheme
                                                          .of(context)
                                                          .tertiary,
                                                      fontSize: height > 700 ? 18.0 : 17,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      height:  height > 700 ? (height / 6) / 7 : (height / 6) / 6,
                                                      width: MediaQuery.of(context).size.width / 6,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(25)),
                                                        color: FlutterFlowTheme
                                                            .of(context)
                                                            .tertiary,
                                                      ),
                                                      child: AnimatedFlipCounter(
                                                        duration: Duration(milliseconds: 500),
                                                        value: _counter1,
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          //letterSpacing: 10.0,
                                                          fontWeight: FontWeight.w800,
                                                          height: 1.3,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),
                                        ).animateOnPageLoad(
                                            animationsMap['containerOnPageLoadAnimation1']!),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigator.push(context, MaterialPageRoute(
                                          //     builder: (builder) => const QuizIntroduction()));
                                        },
                                        child: Container(
                                          width: MediaQuery
                                              .sizeOf(context)
                                              .width * 0.2,
                                          decoration: BoxDecoration(
                                            color: dark_mode? FlutterFlowTheme
                                                .of(context)
                                                .primaryBackground : FlutterFlowTheme
                                                .of(context)
                                                .secondaryBackground,
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x3F14181B),
                                                offset: Offset(
                                                  0.0,
                                                  3.0,
                                                ),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(25.0),
                                            border: Border.all(color: dark_mode ? Color(0xFF00968A) : Colors.white)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 8.0, 0.0, 12.0),
                                                  child: Text("Time Spent \nPracticing",
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme
                                                        .of(context)
                                                        .displaySmall
                                                        .override(
                                                      fontFamily: 'Lexend',
                                                      color:
                                                      FlutterFlowTheme
                                                          .of(context)
                                                          .tertiary,
                                                      fontSize: height > 700 ? 18.0 : 16,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        height: height > 700 ? (height / 6) / 7 : (height / 6) / 6,
                                                        width: MediaQuery.of(context).size.width / 6,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(25)),
                                                          color: FlutterFlowTheme
                                                              .of(context)
                                                              .tertiary,
                                                        ),

                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            AnimatedFlipCounter(
                                                              duration: Duration(milliseconds: 500),
                                                              value: _counter2,
                                                              textStyle: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 16,
                                                                //letterSpacing: 10.0,
                                                                fontWeight: FontWeight.w800,
                                                                height: 1.3,
                                                              ),
                                                            ),
                                                            Text("  Minutes",
                                                                style: FlutterFlowTheme
                                                                    .of(context)
                                                                    .displaySmall
                                                                    .override(
                                                                    fontFamily: 'Lexend',
                                                                    fontSize: 12.0,
                                                                    letterSpacing: 1.0,
                                                                    color: Colors.white
                                                                )

                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ]
                                                ),

                                              ],
                                            ),
                                          ),
                                        ).animateOnPageLoad(
                                            animationsMap['containerOnPageLoadAnimation1']!),
                                      ).animateOnPageLoad(
                                          animationsMap['containerOnPageLoadAnimation2']!),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10,left: 4),
                                      child: GestureDetector(
                                        onTap: () {

                                        },
                                        child: Container(
                                          width: MediaQuery
                                              .sizeOf(context)
                                              .width * 0.2,
                                          decoration: BoxDecoration(
                                            color: dark_mode? FlutterFlowTheme
                                                .of(context)
                                                .primaryBackground : FlutterFlowTheme
                                                .of(context)
                                                .secondaryBackground,
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x3F14181B),
                                                offset: Offset(
                                                  0.0,
                                                  3.0,
                                                ),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(25.0),
                                              border: Border.all(color: dark_mode ? Color(0xFF00968A) : Colors.white)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 8.0, 0.0, 12.0),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text("Strongest \nSubject",
                                                      textAlign: TextAlign.start,
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .displaySmall
                                                          .override(
                                                        fontFamily: 'Lexend',
                                                        color:
                                                        FlutterFlowTheme
                                                            .of(context)
                                                            .tertiary,
                                                        fontSize: height > 700 ? 18.0 : 16,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 120,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme
                                                        .of(context)
                                                        .tertiary,
                                                    borderRadius: BorderRadius.circular(25),

                                                  ),
                                                  child: Center(
                                                    child: Text("History",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500
                                                      ),),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ).animateOnPageLoad(
                                            animationsMap['containerOnPageLoadAnimation1']!),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigator.push(context, MaterialPageRoute(
                                          //     builder: (builder) => const QuizIntroduction()));
                                        },
                                        child: Container(
                                          width: MediaQuery
                                              .sizeOf(context)
                                              .width * 0.2,
                                          decoration: BoxDecoration(
                                            color: dark_mode? FlutterFlowTheme
                                                .of(context)
                                                .primaryBackground : FlutterFlowTheme
                                                .of(context)
                                                .secondaryBackground,
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x3F14181B),
                                                offset: Offset(
                                                  0.0,
                                                  3.0,
                                                ),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(25.0),
                                              border: Border.all(color: dark_mode ? Color(0xFF00968A) : Colors.white)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 9.0, 0.0, 12.0),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text("Needs \nImprovement",
                                                      textAlign: TextAlign.start,
                                                      style: FlutterFlowTheme.of(context).displaySmall.override(
                                                        fontFamily: 'Lexend',
                                                        color:
                                                        FlutterFlowTheme
                                                            .of(context)
                                                            .tertiary,
                                                        fontSize: height > 700 ? 18.0 : 16,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Container(
                                                  width: 120,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme
                                                        .of(context)
                                                        .tertiary,
                                                    borderRadius: BorderRadius.circular(10),

                                                  ),
                                                  child: const Center(
                                                    child: Text("Psychology",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500
                                                      ),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ).animateOnPageLoad(
                                            animationsMap['containerOnPageLoadAnimation1']!),
                                      ).animateOnPageLoad(
                                          animationsMap['containerOnPageLoadAnimation2']!),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),


                        Padding(
                          padding: const EdgeInsets.only(top: 20,left: 30,right: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.push(context, MaterialPageRoute(
                                    //     builder: (builder) => const QuizIntroduction()));
                                  },
                                  child: Container(
                                    width: MediaQuery
                                        .sizeOf(context)
                                        .width * 0.25,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme
                                          .of(context)
                                          .secondaryBackground ,
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x3F14181B),
                                          offset: Offset(
                                            0.0,
                                            3.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(25.0),
                                      border: Border.all(color: Color(0xFF00968A))
                                    ),
                                    child: SpiderChartWidget(
                                      height: MediaQuery.of(context).size.height * .30,
                                      width: MediaQuery.of(context).size.width * 0.30,),
                                  ).animateOnPageLoad(
                                      animationsMap['containerOnPageLoadAnimation1']!),
                                ).animateOnPageLoad(
                                    animationsMap['containerOnPageLoadAnimation2']!),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: MediaQuery.of(context).size.height * .3 ,
                                  width: MediaQuery.of(context).size.width * 0.23,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(25)),
                                    color: Color(0xFF00968A),
                                      border: Border.all(color: dark_mode ? Colors.white : Color(0xFF00968A),
                                          width: .5
                                      )
                                  ),
                                  child: Column(

                                    children: [
                                      Text("Recent doubts",
                                        style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),),
                                      Divider(thickness: .5,),
                                      Expanded(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.22,
                                          child: VerticalMarqueeText(
                                            textDirection: TextDirection.ltr,
                                            text: TextSpan(
                                              children: <InlineSpan>[
                                                for (String str in stringList)
                                                  TextSpan(
                                                    text: str,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w200,
                                                      overflow: TextOverflow.ellipsis
                                                    )
                                                  ),
                                              ],
                                            ),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w200,
                                                overflow: TextOverflow.ellipsis
                                            ),
                                            textAlign: TextAlign.left,
                                            speed: 5,
                                            marqueeDirection: MarqueeDirection.btt,
                                            alwaysScroll: true,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  height: MediaQuery.of(context).size.height * .30 ,
                                  width: MediaQuery.of(context).size.width * 0.28,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),

                                  child: SplineCharts(
                                    height: MediaQuery.of(context).size.height * .30,
                                    width: MediaQuery.of(context).size.width * 0.28,
                                  )
                              ),
                            ],
                          ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation']!),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}