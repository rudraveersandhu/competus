import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animations/loading_animations.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../drona_service.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/internationalization.dart';
import '../../main.dart';
import '../../main.dart';
import '../../model/user_model.dart';
import '../../pages/edit_profile/edit_profile_model.dart';

class SettingScreenWeb extends StatefulWidget {
  const SettingScreenWeb({super.key});

  @override
  State<SettingScreenWeb> createState() => _SettingScreenWebState();
}

class _SettingScreenWebState extends State<SettingScreenWeb> {
  late EditProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool check = false;
  bool updated = true;

  final ImagePicker picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProfileModel());

    _model.yourNameTextController ??= TextEditingController();
    _model.yourNameFocusNode ??= FocusNode();

    _model.yourEmailTextController ??= TextEditingController();
    _model.yourEmailFocusNode ??= FocusNode();

    _model.yourAgeTextController ??= TextEditingController();
    _model.yourAgeFocusNode ??= FocusNode();

    _model.yourTitleTextController ??= TextEditingController();
    _model.yourTitleFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          updated = false;
        });
        _image = File(pickedFile.path);
        _uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    var model = context.read<UserModel>();
    if (_image == null) return;

    final uri = Uri.parse('https://db.quilldb.io/upload/');

    // Extract the original file extension
    String fileExtension = path.extension(_image!.path);

    // Customize the file name here
    String customFileName = model.id + (DateTime.now().toString()).trim()+ fileExtension; // Change "custom_name" to your desired name

    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        _image!.path,
        filename: customFileName,
      ));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);

        Map<String, dynamic> parsedResponse = jsonDecode(responseData.body);

        String fileUrl = parsedResponse['file_url'];
        fileUrl = "https://db.quilldb.io" + fileUrl;
        print('Upload successful: $fileUrl');
        setState(() {
          model.updateProfilePhoto(profilePicture: fileUrl);
          updated = true;
        });

        await updateDatabase();

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile Photo updated sucessfully'),
              backgroundColor: Color(0xFF00968A),
              duration: Duration(seconds: 1),
            )
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });


      } else {
        final responseData = await http.Response.fromStream(response);
        print('Upload failed: ${response.statusCode}');
        print('Response body: ${responseData.body}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  updateDatabase() async {
    var model = context.read<UserModel>();
    var content = {

      'profile_picture' : model.profilePicture,

    };

    await DronaService(plat).updateUserData(model.id,content);
  }


  @override
  Widget build(BuildContext context) {
    var model = context.read<UserModel>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,

      body: Container(
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: MediaQuery.sizeOf(context).height * 1.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: Image.network(
              'assets/images/login_bg@2x.png',
            ).image,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
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
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  width: 90.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).darkBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                      width: 80.0,
                      height: 80.0,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        model.profilePicture,
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  model.name,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Lexend',
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  model.email,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Lexend',
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () {
                    print('Button-Login pressed ...');
                    _pickImage();
                  },
                  text: FFLocalizations.of(context).getText(
                    'zoxan2gi' /* Change Photo */,
                  ),
                  options: FFButtonOptions(
                    width: 140.0,
                    height: 40.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Lexend',
                      letterSpacing: 0.0,
                    ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                child: TextFormField(
                  controller: _model.yourNameTextController,
                  focusNode: _model.yourNameFocusNode,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: FFLocalizations.of(context).getText(
                      '3p9y21e2' /* Your Name */,
                    ),
                    labelStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Lexend',
                      letterSpacing: 0.0,
                    ),
                    hintText: FFLocalizations.of(context).getText(
                      'dw9gmjdc' /* Please enter a valid name... */,
                    ),
                    hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Lexend',
                      letterSpacing: 0.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Lexend',
                    letterSpacing: 0.0,
                  ),
                  validator: _model.yourNameTextControllerValidator
                      .asValidator(context),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                child: TextFormField(
                  controller: _model.yourEmailTextController,
                  focusNode: _model.yourEmailFocusNode,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: FFLocalizations.of(context).getText(
                      'z4fstn5l' /* Email Address */,
                    ),
                    labelStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Lexend',
                      letterSpacing: 0.0,
                    ),
                    hintText: FFLocalizations.of(context).getText(
                      'jozgvwyg' /* Your email */,
                    ),
                    hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Lexend',
                      letterSpacing: 0.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Lexend',
                    letterSpacing: 0.0,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _model.yourEmailTextControllerValidator
                      .asValidator(context),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                child: TextFormField(
                  controller: _model.yourAgeTextController,
                  focusNode: _model.yourAgeFocusNode,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: FFLocalizations.of(context).getText(
                      '8h1cjk5a' /* Your Age */,
                    ),
                    labelStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Lexend',
                      letterSpacing: 0.0,
                    ),
                    hintText: FFLocalizations.of(context).getText(
                      '5v21r6gb' /* i.e. 34 */,
                    ),
                    hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Lexend',
                      letterSpacing: 0.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Lexend',
                    letterSpacing: 0.0,
                  ),
                  keyboardType: TextInputType.number,
                  validator: _model.yourAgeTextControllerValidator
                      .asValidator(context),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                child: TextFormField(
                  controller: _model.yourTitleTextController,
                  focusNode: _model.yourTitleFocusNode,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Your Number',
                    labelStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Lexend',
                      letterSpacing: 0.0,
                    ),
                    hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Lexend',
                      letterSpacing: 0.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Lexend',
                    letterSpacing: 0.0,
                  ),
                  validator: _model.yourTitleTextControllerValidator
                      .asValidator(context),
                ),
              ),

              updated ? Padding(
                padding: const EdgeInsets.all(30.0),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      updated = false;
                    });
                    updateDataOnQuillDb(context);
                  },
                  child: Container(
                    width: 230.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    child: Center(
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'i6edcl52' /* Save Changes */,
                        ),
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Lexend',
                          color: FlutterFlowTheme.of(context).textColor,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ) : Padding(
                padding: const EdgeInsets.all(30.0),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      updated = false;
                    });
                    updateDataOnQuillDb(context);
                  },
                  child: Container(
                    width: 230.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    child: Center(
                      child: Container(
                          height: 30,
                          child: LoadingBouncingGrid.square(
                            borderColor: Colors.white,
                            borderSize: 1.0,
                            size: 25.0,
                            backgroundColor: Colors.white,
                            duration: Duration(milliseconds: 800),
                          )),
                    ),
                  ),
                ),
              )
              // updated ? Padding(
              //   padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
              //   child: FFButtonWidget(
              //     onPressed: () {
              //       setState(() {
              //         updated = false;
              //       });
              //       updateDataOnQuillDb(context);
              //
              //     },
              //     text: FFLocalizations.of(context).getText(
              //       'i6edcl52' /* Save Changes */,
              //     ),
              //     options: FFButtonOptions(
              //       width: 230.0,
              //       height: 56.0,
              //       padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              //       iconPadding:
              //           const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              //       color: FlutterFlowTheme.of(context).primary,
              //       textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              //             fontFamily: 'Lexend',
              //             color: FlutterFlowTheme.of(context).textColor,
              //             letterSpacing: 0.0,
              //           ),
              //       elevation: 3.0,
              //       borderSide: const BorderSide(
              //         color: Colors.transparent,
              //         width: 1.0,
              //       ),
              //       borderRadius: BorderRadius.circular(30.0),
              //     ),
              //   ),
              // )
              //     : Padding(
              //   padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
              //   child: FFButtonWidget(
              //     onPressed: () {
              //       setState(() {
              //         updated = false;
              //       });
              //       updateDataOnQuillDb(context);
              //
              //     },
              //     text: FFLocalizations.of(context).getText(
              //       'i6edcl52' /* Save Changes */,
              //     ),
              //     options: FFButtonOptions(
              //       width: 230.0,
              //       height: 56.0,
              //       padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              //       iconPadding:
              //       const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              //       color: FlutterFlowTheme.of(context).primary,
              //       textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              //         fontFamily: 'Lexend',
              //         color: FlutterFlowTheme.of(context).textColor,
              //         letterSpacing: 0.0,
              //       ),
              //       elevation: 3.0,
              //       borderSide: const BorderSide(
              //         color: Colors.transparent,
              //         width: 1.0,
              //       ),
              //       borderRadius: BorderRadius.circular(30.0),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  updateDataOnQuillDb(BuildContext context) async {
    var model = context.read<UserModel>();

    var name  = _model.yourNameTextController;
    var email = _model.yourEmailTextController;
    var age   = _model.yourAgeTextController;
    var title = _model.yourTitleTextController;


    var content = {
      "name": _model.yourNameTextController!.text == '' ? model.name : _model.yourNameTextController!.text,
      "dob": model.DOB,
      "email": _model.yourEmailTextController!.text == '' ? model.email : _model.yourEmailTextController!.text,
      "subjects": [
        model.subject
      ],
      "phone_number": numberLogic(_model.yourTitleTextController!.text)

    };

    updateModelInfo(content, model.id);

  }

  updateModelInfo(content, String id) async {
    var model = context.read<UserModel>();
    var data = await DronaService(plat).updateUserData(id, content);

    String name = data['name'];  // Ensure name is a String
    String email = data['email'] ?? model.email;
    String number = data['phone_number'] ?? model.number;
    List<String> subjects = data['subjects'];

    setState(() {
      context.read<UserModel>().updateData(
          id: model.id,
          name: name,
          email: email,
          number: number,
          profilePicture: model.profilePicture,
          DOB: model.DOB,
          subject: subjects.isNotEmpty ? subjects[0] : model.subject,
          subsubject: model.subsubject,
          address: model.address,
          rank: model.rank,
          credits_left: model.credits_left,
          credits_recharged: model.credits_recharged,
          quizHistory: model.quizHistory,
          graph_performance_data: model.graph_performance_data,
          total_questions_solved: model.total_questions_solved,
          time_spent_practicing: model.time_spent_practicing,
          strongest_subject: model.strongest_subject,
          weakest_subject: model.weakest_subject
      );
      updated = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Details updated sucessfully'),
          backgroundColor: Color(0xFF00968A),
          duration: Duration(seconds: 1),
        )
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }



  numberLogic(String number){
    var model = context.read<UserModel>();
    bool check = _validateNumber(number);
    if(check){
      return number;
    }else{
      return model.number;
    }
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

}