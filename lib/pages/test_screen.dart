// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart'; // For kIsWeb
//
// import 'package:provider/provider.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'dart:io' if (kIsWeb) 'dart:html';
//
// import '../flutter_flow/flutter_flow_util.dart';
// import '../main.dart';
// import '../model/QuizHistory.dart';
// import '../model/answer_model.dart';
// import '../model/qanda_history_model.dart';
// import '../model/user_model.dart'; // for platform specific code
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   GoRouter.optionURLReflectsImperativeAPIs = true;
//   usePathUrlStrategy();
//
//   if (!kIsWeb) {
//     // Platform-specific code (non-web platforms)
//     DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//
//     if (Platform.isWindows) {
//       WindowsDeviceInfo windowsInfo = await deviceInfoPlugin.windowsInfo;
//       print(windowsInfo);
//       device = 'windows';
//     } else if (Platform.isLinux) {
//       LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
//       print(linuxInfo);
//       device = 'linux';
//     } else if (Platform.isMacOS) {
//       MacOsDeviceInfo macInfo = await deviceInfoPlugin.macOsInfo;
//       print(macInfo);
//       device = 'macos';
//     } else if (Platform.isAndroid) {
//       AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
//       print(androidInfo);
//       device = 'android';
//     } else if (Platform.isIOS) {
//       IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
//       print(iosInfo);
//       device = 'ios';
//     } else {
//       print("Unsupported platform");
//     }
//   } else {
//     // Web-specific code
//     plat = 'web';
//     print("Platform: $plat");
//   }
//
//   await FlutterFlowTheme.initialize();
//   await authManager.initialize();
//
//   await Hive.initFlutter();
//   var box = await Hive.openBox<QuizHistory>('quizHistoryBox');
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<UserModel>(
//           create: (context) => UserModel(),
//         ),
//         ChangeNotifierProvider<AnswerModel>(
//           create: (context) => AnswerModel(),
//         ),
//         ChangeNotifierProvider<Quizhistory>(
//           create: (context) => Quizhistory(),
//         ),
//         ChangeNotifierProvider<QandaHistoryModel>(
//           create: (context) => QandaHistoryModel(),
//         ),
//       ],
//       child: MyAppNavigator(),
//     ),
//   );
// }
//
// class MyAppNavigator extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Get screen width
//     double screenWidth = MediaQuery.of(context).size.width;
//
//     // Use screen width to decide which app to show
//     if (screenWidth > 800) {
//       // Web or larger screen
//       return const MyWebApp();
//     } else {
//       // Mobile or smaller screen
//       return const MyApp();
//     }
//   }
// }
