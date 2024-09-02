import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../../model/qanda_history_model.dart';
import '../../../model/user_model.dart';
import '../../../new_screen.dart';
import '../../../spline_charts.dart';
import '/components/pause_card/pause_card_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'm_y_card_model.dart';
export 'm_y_card_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late MYCardModel _model;
  late bool isShowingMainData;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  late ValueNotifier<double> valueNotifier;

  int _counter = 0;
  late int _counter1 ;

  late int _counter2 ;

  // fetch_total_solved_Questions(){
  //   var bx    = Provider.of<QandaHistoryModel>(context);
  //   _counter1 = bx.total_questions[0];
  //
  // }

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

    return Consumer<UserModel>(
        builder: (context, model, child)  {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme
                .of(context)
                .primaryBackground,


            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Welcome Back,',
                                style: FlutterFlowTheme
                                    .of(context)
                                    .displaySmall
                                    .override(
                                    fontFamily: 'Lexend',
                                    letterSpacing: 0.0,
                                    fontSize: height > 700 ? 30: 23
                                ),
                              ),
                              Text('${model.name}',
                                style: FlutterFlowTheme
                                    .of(context)
                                    .displaySmall
                                    .override(
                                    fontFamily: 'Lexend',
                                    letterSpacing: 0.0,
                                    fontSize: height > 700 ? 20: 17
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0,right: 20),
                            child: Icon(
                              Icons.notifications_none_sharp,
                              color: Color(0xFF00968A),
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
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
                                  width: MediaQuery.of(context).size.width * 0.92,
                                  height: height > 700 ? height * 0.2 : height * 0.25 ,
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
                                    borderRadius: BorderRadius.circular(8.0),
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
                                              'DashBoard',
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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 50,),
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
                                                  height: height > 700 ? (height / 6) / 8 : (height / 6) / 6,
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
                          ),
                        ],
                      ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation']!),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(
                              //     builder: (builder) => QuizIntroduction()));
                            },
                            child: Container(
                              width: MediaQuery
                                  .sizeOf(context)
                                  .width * 0.44,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme
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
                                          color: FlutterFlowTheme
                                              .of(context)
                                              .tertiary,
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
                                        // Container(
                                        //   width: (MediaQuery
                                        //       .sizeOf(context)
                                        //       .width * 0.44)/2.8,
                                        //   height: 28.0,
                                        //   decoration: BoxDecoration(
                                        //     color: const Color(0x4D39D2C0),
                                        //     borderRadius: BorderRadius.circular(8.0),
                                        //   ),
                                        //   child: Row(
                                        //     mainAxisSize: MainAxisSize.max,
                                        //     mainAxisAlignment: MainAxisAlignment.center,
                                        //     children: [
                                        //       Text(
                                        //         FFLocalizations.of(context).getText(
                                        //           '0d7w9e0i' /* 4.5%  */,
                                        //         ),
                                        //         textAlign: TextAlign.start,
                                        //         style: FlutterFlowTheme
                                        //             .of(context)
                                        //             .bodyMedium
                                        //             .override(
                                        //           fontFamily: 'Lexend',
                                        //           color: FlutterFlowTheme
                                        //               .of(context)
                                        //               .tertiary,
                                        //           letterSpacing: 0.0,
                                        //         ),
                                        //       ),
                                        //       Icon(
                                        //         Icons.trending_up_rounded,
                                        //         color:
                                        //         FlutterFlowTheme
                                        //             .of(context)
                                        //             .tertiary,
                                        //         size: 24.0,
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ).animateOnPageLoad(
                                animationsMap['containerOnPageLoadAnimation1']!),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(
                              //     builder: (builder) => const QuizIntroduction()));
                            },
                            child: Container(
                              width: MediaQuery
                                  .sizeOf(context)
                                  .width * 0.44,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme
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
                                          color: FlutterFlowTheme
                                              .of(context)
                                              .tertiary,
                                          child: AnimatedFlipCounter(
                                            duration: Duration(milliseconds: 500),
                                            value: _counter2,
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              //letterSpacing: 10.0,
                                              fontWeight: FontWeight.w800,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0,left: 10),
                                          child: Text("Minutes",
                                              style: FlutterFlowTheme
                                                  .of(context)
                                                  .displaySmall
                                                  .override(
                                                fontFamily: 'Lexend',
                                                color:
                                                FlutterFlowTheme
                                                    .of(context)
                                                    .tertiary,
                                                fontSize: 12.0,
                                                letterSpacing: 1.0,)

                                          ),
                                        )],
                                    ),

                                  ],
                                ),
                              ),
                            ).animateOnPageLoad(
                                animationsMap['containerOnPageLoadAnimation1']!),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation2']!),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0,right: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              width: MediaQuery
                                  .sizeOf(context)
                                  .width * 0.44,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme
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
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 12.0),
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
                                    Container(
                                      width: 120,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme
                                            .of(context)
                                            .tertiary,
                                        borderRadius: BorderRadius.circular(6),

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
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(
                              //     builder: (builder) => const QuizIntroduction()));
                            },
                            child: Container(
                              width: MediaQuery
                                  .sizeOf(context)
                                  .width * 0.44,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme
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
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 9.0, 0.0, 12.0),
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
                                    Container(
                                      width: 120,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme
                                            .of(context)
                                            .tertiary,
                                        borderRadius: BorderRadius.circular(6),

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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * .20 ,
                              width: MediaQuery.of(context).size.width * 0.92,
                              child: SplineCharts(
                                height: MediaQuery.of(context).size.height * .20,
                                width: MediaQuery.of(context).size.width * 0.92,
                              )
                          ),
                        ],
                      ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation']!),
                    ),
                    Container(
                      height: 150,
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}