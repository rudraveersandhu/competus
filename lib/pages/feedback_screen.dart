import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_drona/Main_Screen.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../flutter_flow/internationalization.dart';

class FeedbackScreen extends StatefulWidget {
  final String plat;
  const FeedbackScreen({
    super.key,
    required this.plat
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            height: MediaQuery.sizeOf(context).height * 1.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: Image.asset(
                  'assets/images/login_bg@2x.png',
                ).image,
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);

                          },

                            child: Icon(Icons.arrow_back_ios_new)),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24.0, 30, 24.0, 20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (Theme.of(context).brightness == Brightness.dark)
                              Image.asset(
                                'assets/blogo.png',
                                width: 130.0,
                                height: 120.0,
                                fit: BoxFit.contain,
                              ),
                            if (!(Theme.of(context).brightness ==
                                Brightness.dark))
                              Image.asset(
                                'assets/flogo.png',
                                width: 130.0,
                                height: 120.0,
                                fit: BoxFit.fitWidth,
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Icon(CupertinoIcons.list_bullet_indent,
                        color: Colors.transparent,),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Feedback Forum',
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                  fontFamily: 'Lexend',
                                  fontSize: 28.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "Your feedback matters to us.",
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                    fontFamily: 'Lexend',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 0.0),
                              child: TextFormField(
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                    fontFamily: 'Lexend',
                                    letterSpacing: 0.0,
                                  ),
                                  hintText:
                                  "Feel free to share your reviews or suggest features you would like. ",
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                    fontFamily: 'Lexend',
                                    letterSpacing: 0.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  contentPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      20.0, 24.0, 20.0, 24.0),

                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Lexend',
                                  letterSpacing: 0.0,
                                ),
                                minLines: 15,
                                maxLines: 15,

                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0,right: 0),
                                child: FFButtonWidget(
                                  onPressed: () {
                                    send_feedback();

                                    print('Button-Login pressed ...');
                                  },
                                  text: 'Submit Feedback',
                                  options: FFButtonOptions(
                                    width: MediaQuery.of(context).size.width-50,
                                    height: 50.0,
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color:
                                    FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
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
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  send_feedback() {
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
                  'Feedback Submitted !',
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MainScreen(plat: widget.plat,)
                          ),
                        );

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
}

