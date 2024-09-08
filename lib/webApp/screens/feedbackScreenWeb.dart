import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Main_Screen.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../main.dart';
import '../../model/user_model.dart';

class FeedbackScreenWeb extends StatefulWidget {
  const FeedbackScreenWeb({super.key});

  @override
  State<FeedbackScreenWeb> createState() => _FeedbackScreenWebState();
}

class _FeedbackScreenWebState extends State<FeedbackScreenWeb> {
  @override
  Widget build(BuildContext context) {


    return Consumer<UserModel>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Column(

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
                Column(
                  //mainAxisSize: MainAxisSize.max,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Row(
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
                                      width: 500,
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
                                      borderRadius: BorderRadius.circular(25.0),
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
              ],
            ),
          );
        });

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
                                  MainScreen()
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
