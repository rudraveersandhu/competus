import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_drona/model/QuizHistory.dart';
import 'package:my_drona/model/answer_model.dart';
import 'package:my_drona/model/qanda_history_model.dart';
import 'package:my_drona/pages/splash_screen.dart';
import 'package:provider/provider.dart';
import 'auth/custom_auth/auth_util.dart';
import 'auth/custom_auth/custom_auth_user_provider.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'model/quiz_history_model.dart';
import 'model/user_model.dart';

String plat = ' ';
String device = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  if (!kIsWeb) {
    // Platform-specific code only runs on non-web platforms.
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfoPlugin.windowsInfo;
      print(windowsInfo);
      device = 'windows';
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
      print(linuxInfo);
      device = 'linux';
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await deviceInfoPlugin.macOsInfo;
      print(macInfo);
      device = 'macos';
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      print(androidInfo);
      device = 'android';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      print(iosInfo);
      device = 'ios';
    } else {
      // Handle other platforms, like embedded
      print("Unsupported platform");
    }
  } else {
    // Web-specific code
    plat = 'web';
    print("Platform: $plat");
    print("Device: $device");
    // You can use browser-related checks or web-specific implementations here.
  }
  print("Platform: $plat");
  print("Device: $device");

  await FlutterFlowTheme.initialize();
  await authManager.initialize();

  await Hive.initFlutter();
  var box = await Hive.openBox<QuizHistory>('quizHistoryBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(
          create: (context) => UserModel(),
        ),
        ChangeNotifierProvider<AnswerModel>(
          create: (context) => AnswerModel(),
        ),
        ChangeNotifierProvider<Quizhistory>(
          create: (context) => Quizhistory(),
        ),
        ChangeNotifierProvider<QandaHistoryModel>(
          create: (context) => QandaHistoryModel(),
        ),
      ],
      child: MyAppNavigator(),
    ),
  );

}

class MyAppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Use screen width to decide which app to show
    if (screenWidth > 700) {
      // Web or larger screen
      return const MyWebApp();
    } else {
      // Mobile or smaller screen
      return const MyApp();
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;

  late Stream<MyDronaAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;

    userStream = myDronaAuthUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });

    Future.delayed(
      const Duration(milliseconds: 1000),
          () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
    _themeMode = mode;
    FlutterFlowTheme.saveThemeMode(mode);
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDrona',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('de'),
        Locale('ar'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      home: SplashScreen(plat: plat),
      //MainScreen(),
      //
      //routerConfig: _router,
    );
  }
}


class MyWebApp extends StatefulWidget {
  const MyWebApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyWebApp> createState() => _MyWebAppState();

  static _MyWebAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyWebAppState>()!;
}

class _MyWebAppState extends State<MyWebApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;

  late Stream<MyDronaAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;

    userStream = myDronaAuthUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });

    Future.delayed(
      const Duration(milliseconds: 1000),
          () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
    _themeMode = mode;
    FlutterFlowTheme.saveThemeMode(mode);
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDrona',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('de'),
        Locale('ar'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      home: SplashScreen(plat: plat),
      //MainScreen(),
      //routerConfig: _router,
    );
  }
}
