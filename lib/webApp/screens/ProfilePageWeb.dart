import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../drona_service.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/internationalization.dart';
import '../../main.dart';
import '../../model/user_model.dart';
import '../../pages/edit_profile/edit_profile_widget.dart';
import '../../pages/feedback_screen.dart';
import '../../pages/login_page/login_page_widget.dart';
import '../../pages/m_y_profile_page/m_y_profile_page_model.dart';
import '../../pages/notifications_settings/notifications_settings_widget.dart';
import '../../pages/transfer_complete/transfer_complete_widget.dart';
import '../../pages/tutorial_p_r_o_f_i_l_e/tutorial_p_r_o_f_i_l_e_widget.dart';
import '../main_screen_web.dart';

class ProfileWeb extends StatefulWidget {
  const ProfileWeb({super.key, required String plat});

  @override
  State<ProfileWeb> createState() => _ProfileWebState();
}

class _ProfileWebState extends State<ProfileWeb> {
  late MYProfilePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MYProfilePageModel());
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
    String customFileName = model.id + '-' +(DateTime.now().toString()).trim()+ fileExtension; // Change "custom_name" to your desired name

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
        });

        await updateDatabase();


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
    var content = {'profile_picture' : model.profilePicture,};
    await DronaService(plat).updateUserData(model.id,content);
  }

  @override
  Widget build(BuildContext context) {

    var model = context.read<UserModel>();

    return Consumer<UserModel>(
        builder: (context, model, child) {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: dark_mode ? FlutterFlowTheme
                .of(context).darkBackground :FlutterFlowTheme
                .of(context)
                .primaryBackground,
            body: SingleChildScrollView(
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
                  //Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                      width: MediaQuery
                          .sizeOf(context)
                          .width * 1.0,
                      height: 220.0,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 6.0,
                            color: Color(0x4B1A1F24),
                            offset: Offset(
                              0.0,
                              2.0,
                            ),
                          )
                        ],
                        color: Color(0xFF00968A),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height/20,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  children: [
                                    Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: FlutterFlowTheme
                                          .of(context)
                                          .primary,
                                      elevation: 2.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          width: 65.0,
                                          height: 65.0,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.network(
                                            model.profilePicture,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: (){
                                            print("clicked");
                                            _pickImage();
                                          },
                                          child: Icon(Icons.add_circle,
                                            color: Colors.white,),
                                        ))
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Container(
                                    width: 44.0,
                                    height: 44.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0x40000000),
                                      borderRadius: BorderRadius.circular(
                                          8.0),
                                    ),
                                    child: FlutterFlowIconButton(
                                      borderColor: Colors.transparent,
                                      borderRadius: 30.0,
                                      buttonSize: 46.0,
                                      icon: Icon(
                                        Icons.login_rounded,
                                        color: FlutterFlowTheme
                                            .of(context)
                                            .textColor,
                                        size: 25.0,
                                      ),
                                      onPressed: () async {
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(builder: (
                                                builder) =>  LoginPageWidget(stream_count: 0, plat: plat,)));
                                      },
                                    ),
                                  ),
                                )

                              ],
                            ),
                            Padding(
                              padding:
                              const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(model.name
                                    ,
                                    style: FlutterFlowTheme
                                        .of(context)
                                        .headlineSmall
                                        .override(
                                      fontFamily: 'Lexend',
                                      color: FlutterFlowTheme
                                          .of(context)
                                          .textColor,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 0.0),
                                child: Text(
                                  model.email,
                                  style: FlutterFlowTheme
                                      .of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Lexend',
                                    color: const Color(0xB3FFFFFF),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 0.0),
                                child: Text(
                                  model.number,
                                  style: FlutterFlowTheme
                                      .of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Lexend',
                                    color: const Color(0xB3FFFFFF),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.fromSTEB(
                            20.0, 12.0, 20.0, 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                'f1bvbey3' /* My Account */,
                              ),
                              style: FlutterFlowTheme
                                  .of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Lexend',
                                letterSpacing: 0.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                      top: 10
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileWidget(
                                id: model.id, plat: plat,)
                          ),
                        );
                      },
                      child: Container(
                        height: 53,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 43,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.blueGrey.shade100, width: 2),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 14),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'i61y9ibx' /* Edit Profile */,
                                ),
                                style: FlutterFlowTheme
                                    .of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Lexend',
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30.0,
                                buttonSize: 46.0,
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Color(0xFF95A1AC),
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfileWidget(id: model.id, plat: plat,)
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const ChangePasswordWidget()),
                  //       );
                  //     },
                  //     child: Container(
                  //       height: 53,
                  //       width: MediaQuery
                  //           .of(context)
                  //           .size
                  //           .width - 43,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         border: Border.all(
                  //             color: Colors.blueGrey.shade100, width: 2),
                  //       ),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.only(left: 16.0, top: 14),
                  //             child: Text(
                  //               'Change Pasword',
                  //               style: FlutterFlowTheme
                  //                   .of(context)
                  //                   .bodyMedium
                  //                   .override(
                  //                 fontFamily: 'Lexend',
                  //                 letterSpacing: 0.0,
                  //               ),
                  //             ),
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsets.only(right: 5.0),
                  //             child: FlutterFlowIconButton(
                  //               borderColor: Colors.transparent,
                  //               borderRadius: 30.0,
                  //               buttonSize: 46.0,
                  //               icon: const Icon(
                  //                 Icons.chevron_right_rounded,
                  //                 color: Color(0xFF95A1AC),
                  //                 size: 25.0,
                  //               ),
                  //               onPressed: () {
                  //                 Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) =>
                  //                           EditProfileWidget(id: model.id,)
                  //                   ),
                  //                 );
                  //               },
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                        top: 10
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (
                                  context) => const NotificationsSettingsWidget()),
                        );
                      },
                      child: Container(
                        height: 53,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 43,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.blueGrey.shade100, width: 2),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 14),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  '6w6wv95p' /* Notification Settings */,
                                ),
                                style: FlutterFlowTheme
                                    .of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Lexend',
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30.0,
                                buttonSize: 46.0,
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Color(0xFF95A1AC),
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfileWidget(id: model.id, plat: plat,)
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                        top: 10
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TutorialPROFILEWidget()),
                        );
                      },
                      child: Container(
                        height: 53,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 43,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.blueGrey.shade100, width: 2),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 14),
                              child: Text(
                                'My Drona Tutorial',
                                style: FlutterFlowTheme
                                    .of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Lexend',
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30.0,
                                buttonSize: 46.0,
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Color(0xFF95A1AC),
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfileWidget(id: model.id, plat: plat,)
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                        top: 10
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TransferCompleteWidget()),
                        );
                      },
                      child: Container(
                        height: 53,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 43,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.blueGrey.shade100, width: 2),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 14),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'eojlfs66' /* Privacy Policy */,
                                ),
                                style: FlutterFlowTheme
                                    .of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Lexend',
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30.0,
                                buttonSize: 46.0,
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Color(0xFF95A1AC),
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfileWidget(
                                              id: model.id,
                                              plat: plat,)
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                        top: 10
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  FeedbackScreen(plat: plat,)),
                        );
                      },
                      child: Container(
                        height: 53,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 43,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.blueGrey.shade100, width: 2),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 14),
                              child: Text(
                                'Feedback',
                                style: FlutterFlowTheme
                                    .of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Lexend',
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30.0,
                                buttonSize: 46.0,
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Color(0xFF95A1AC),
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfileWidget(
                                              id: model.id,
                                              plat: plat,)
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),



                  if (!(Theme
                      .of(context)
                      .brightness == Brightness.dark))
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 20.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          await delete_account();
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (builder) =>  LoginPageWidget(stream_count: 0, plat: plat,)));
                          // setDarkModeSetting(context, ThemeMode.dark);
                        },
                        text: 'Delete Account',
                        options: FFButtonOptions(
                          width: 180.0,
                          height: 40.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: Colors.red,
                          textStyle: FlutterFlowTheme
                              .of(context)
                              .titleSmall
                              .override(
                            fontFamily: 'Lexend',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                          elevation: 2.0,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  if (Theme
                      .of(context)
                      .brightness == Brightness.dark)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 24.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          await delete_account();
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (builder) =>  LoginPageWidget(stream_count: 0, plat: plat)));

                          //setDarkModeSetting(context, ThemeMode.light);
                        },
                        text: 'Delete Account',
                        options: FFButtonOptions(
                          width: 180.0,
                          height: 40.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: Colors.red,
                          textStyle: FlutterFlowTheme
                              .of(context)
                              .titleSmall
                              .override(
                            fontFamily: 'Lexend',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                          elevation: 2.0,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),

                  // if (!(Theme
                  //     .of(context)
                  //     .brightness == Brightness.dark))
                  //   Padding(
                  //     padding: const EdgeInsetsDirectional.fromSTEB(
                  //         0.0, 20.0, 0.0, 0.0),
                  //     child: FFButtonWidget(
                  //       onPressed: () async {
                  //         print_id();
                  //         //await delete_account();
                  //         // Navigator.pushReplacement(context, MaterialPageRoute(
                  //         //     builder: (builder) => const LoginPageWidget(stream_count: 0,)));
                  //         // setDarkModeSetting(context, ThemeMode.dark);
                  //       },
                  //       text: 'print user id and num',
                  //       options: FFButtonOptions(
                  //         width: 180.0,
                  //         height: 40.0,
                  //         padding: const EdgeInsetsDirectional.fromSTEB(
                  //             0.0, 0.0, 0.0, 0.0),
                  //         iconPadding:
                  //         const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  //         color: Colors.blue,
                  //         textStyle: FlutterFlowTheme
                  //             .of(context)
                  //             .titleSmall
                  //             .override(
                  //           fontFamily: 'Lexend',
                  //           color: Colors.white,
                  //           letterSpacing: 0.0,
                  //         ),
                  //         elevation: 2.0,
                  //         borderSide: const BorderSide(
                  //           color: Colors.transparent,
                  //           width: 1.0,
                  //         ),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //       ),
                  //     ),
                  //   ),
                  // if (Theme
                  //     .of(context)
                  //     .brightness == Brightness.dark)
                  //   Padding(
                  //     padding: const EdgeInsetsDirectional.fromSTEB(
                  //         0.0, 24.0, 0.0, 0.0),
                  //     child: FFButtonWidget(
                  //       onPressed: () async {
                  //         print_id();
                  //         // await delete_account();
                  //         // Navigator.pushReplacement(context, MaterialPageRoute(
                  //         //     builder: (builder) => const LoginPageWidget(stream_count: 0,)));
                  //         //setDarkModeSetting(context, ThemeMode.light);
                  //       },
                  //       text: 'print user id and num',
                  //       options: FFButtonOptions(
                  //         width: 180.0,
                  //         height: 40.0,
                  //         padding: const EdgeInsetsDirectional.fromSTEB(
                  //             0.0, 0.0, 0.0, 0.0),
                  //         iconPadding:
                  //         const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  //         color: Colors.blue,
                  //         textStyle: FlutterFlowTheme
                  //             .of(context)
                  //             .titleSmall
                  //             .override(
                  //           fontFamily: 'Lexend',
                  //           color: Colors.white,
                  //           letterSpacing: 0.0,
                  //         ),
                  //         elevation: 2.0,
                  //         borderSide: const BorderSide(
                  //           color: Colors.transparent,
                  //           width: 1.0,
                  //         ),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          );
        }
    );
  }

  delete_account() async {

    final user_box = await Hive.openBox('user');
    var model = context.read<UserModel>();

    await user_box.put('id','');
    await DronaService(plat).delete_user_account(model.id);

  }

  print_id() async {
    final user_box = await Hive.openBox('user');
    var id = await user_box.get('id');
    print(id);
  }
}
