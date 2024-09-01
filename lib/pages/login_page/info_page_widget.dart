import 'package:flutter/cupertino.dart';
import '../../drona_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'exam_selection_screen.dart';
import 'login_page_model.dart';
export 'login_page_model.dart';

class InfoPageWidget extends StatefulWidget {
  final String number;
  final String plat;
  const InfoPageWidget({super.key,
    required this.number,
    required this.plat,


  });

  @override
  State<InfoPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<InfoPageWidget> {
  late LoginPageModel _model;

  String uid      = "";
  bool   check    = false;
  bool   verified = false;
  bool   rescheck = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());
    _model.emailAddressLoginTextController ??= TextEditingController();
    _model.emailAddressLoginFocusNode ??= FocusNode();
    _dobController.text = '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
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
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24.0, 24.0, 24.0, 20.0),
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
                            if (!(Theme.of(context).brightness ==
                                Brightness.dark))
                              Image.asset(
                                'assets/flogo.png',
                                width: 120.0,
                                height: 120.0,
                                fit: BoxFit.fitWidth,
                              ),
                          ],
                        ),
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
                                    'Welcome',
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
                                    Container(
                                      width: MediaQuery.of(context).size.width-50,
                                      child: Text(
                                        'Enter the following details to create your account',
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily: 'Lexend',
                                              fontSize: 15.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),  ),
                              Container(
                                decoration: const BoxDecoration(),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 20.0, 0.0, 0.0),
                                  child: TextFormField(
                                    controller: _nameController,
                                    focusNode: _model.emailAddressLoginFocusNode,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Lexend',
                                            letterSpacing: 0.0,
                                          ),
                                      hintText:'Enter name here...',
                                      hintStyle:
                                      FlutterFlowTheme.of(context)
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
                                        borderSide:
                                        const BorderSide(
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
                                      prefixIcon: const Icon(
                                        CupertinoIcons.person,
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Lexend',
                                          letterSpacing: 0.0,
                                        ),
                                    validator: _model
                                        .emailAddressLoginTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 10.0, 0.0, 0.0),
                                  child: TextFormField(
                                    controller: _emailController,
                                    //focusNode: _mode l.emailAddressLoginFocusNode,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                        fontFamily: 'Lexend',
                                        letterSpacing: 0.0,
                                      ),
                                      hintText:'Email',
                                      hintStyle:
                                      FlutterFlowTheme.of(context)
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
                                        borderSide:
                                        const BorderSide(
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
                                      prefixIcon: const Icon(
                                        CupertinoIcons.mail,
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: 'Lexend',
                                      letterSpacing: 0.0,
                                    ),
                                    validator: _model
                                        .emailAddressLoginTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 20.0),
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _selectDate(context);
                                    });
                                  },
                                  child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width-50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: FlutterFlowTheme.of(context).secondaryBackground
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: Icon(CupertinoIcons.calendar,color: Colors.grey.shade500,),
                                        ),
                                        Text(_dobController.text == '' ? "Date of birth" : _dobController.text,
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                            fontFamily: 'Lexend',
                                            letterSpacing: 0.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () {
                                  if(_nameController.text != '' && _dobController.text != ''){
                                    Navigator.pushReplacement(context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) =>
                                            ExamSelectionScreen(
                                              streamCount: 6,
                                              name:_nameController.text,
                                              email:_emailController.text,
                                              dob: _dobController.text,
                                              number: widget.number, plat: widget.plat,
                                            ),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          const curve = Curves.ease;
                                          var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve)));

                                          return FadeTransition(
                                            opacity: fadeAnimation,
                                            child: child,
                                          );
                                        },
                                        transitionDuration: const Duration(milliseconds: 700),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Cant go forward, Fields incomplete, Kindly fill the required fields'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                  // _validateNumber(_phoneController.text);
                                  // if(check){
                                  //   start_verification(_phoneController.text);
                                  // }else{
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(
                                  //       content: Text('Verification failed. Fill all the details'),
                                  //       backgroundColor: Colors.red,
                                  //     ),
                                  //   );
                                  // }
                                  print('Page 2 hai betettty');
                                },
                                text:  'Next',
                                options: FFButtonOptions(
                                  width: MediaQuery.of(context).size.width-40,
                                  height: 50.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(fontFamily: 'Lexend', letterSpacing: 0.0,),
                                  elevation: 3.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
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
        ],
      ),
    );
  }

  bool _validateNumber(String number) {
    final numberRegExp = RegExp(
      r'^\d{10}$', // Example for a 10-digit number validation
    );
    setState(() {
      check = numberRegExp.hasMatch(number);
    });
    return numberRegExp.hasMatch(number);
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
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      print(_dobController.text);
    }
  }
}
