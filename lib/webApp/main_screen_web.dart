import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:my_drona/webApp/screens/ProfilePageWeb.dart';
import 'package:my_drona/webApp/screens/dashboardScreenWeb.dart';
import 'package:my_drona/webApp/screens/feedbackScreenWeb.dart';
import 'package:my_drona/webApp/screens/quizPracticeScreenWeb.dart';
import 'package:my_drona/webApp/screens/settingScreenWeb.dart';
import 'package:my_drona/webApp/screens/testHistoryScreenWeb.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../main.dart';
bool dark_mode =false;
class MainScreenWeb extends StatefulWidget {


  MainScreenWeb({super.key,

  });

  @override
  State<MainScreenWeb> createState() => _MainScreenWebState();
}

class _MainScreenWebState extends State<MainScreenWeb> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;


  ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    }
    );
  }

  Widget _buildOption(IconData icon, String option, int index, Color textColor) {
    bool isSelected = _currentIndex == index;

    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10,bottom: 5),
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF00968A) : Colors.transparent,
            borderRadius: BorderRadius.circular(10)
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? textColor : Colors.grey.shade600,
              ),
              const SizedBox(width: 15),
              Text(
                option,
                style: TextStyle(
                  color: isSelected ? textColor : Colors.grey.shade600,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const DashboardScreenWeb();
      case 1:
        return const QuizPracticeScreenWeb();
      case 2:
        return const TestHistoryScreenWeb();
      case 3:
        return ProfileWeb(plat: plat);
      case 4:
        return FeedbackScreenWeb();
      case 5:
        return SettingScreenWeb();

      default:
        return const DashboardScreenWeb();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isDarkMode,
        builder: (context, isDark, _) {
      final theme = isDark ? ThemeData.dark() : ThemeData.light();
      return Theme(
          data: theme,
          child: Scaffold(
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.19,
            color: isDark ? FlutterFlowTheme
                .of(context).darkBackground : FlutterFlowTheme.of(context).primaryBackground,  // Background color for the sidebar
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    dark_mode
                        ? 'assets/blogo.png'
                        : 'assets/flogo.png',
                    width: 110.0,
                    height: 100.0,
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOption(CupertinoIcons.home, 'Home', 0, Colors.white),
                      _buildOption(CupertinoIcons.book, 'Quiz Practice', 1, Colors.white),
                      _buildOption(CupertinoIcons.calendar, 'Quiz History', 2, Colors.white),
                      _buildOption(CupertinoIcons.person, 'Profile', 3, Colors.white),
                      //_buildOption(CupertinoIcons.settings, 'Settings', 4, Colors.white),
                      SizedBox( height: 10 ),

                      Divider(
                        height: 1,
                      ),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0,right: 10,bottom: 5,top: 20),
                                  child: Container(
                                    child: Row(

                                      children: [
                                        Icon(
                                          CupertinoIcons.question_circle,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          "Help Center",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: _buildOption(CupertinoIcons.rocket, 'Feedback', 4, Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: _buildOption(CupertinoIcons.settings, 'Settings', 5, Colors.white),
                                ),

                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 250,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Color(0xFF00968A),
                                    ),
                                  ),
                                  Container(
                                    width: 250,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      image: DecorationImage(
                                        image: AssetImage("assets/texture.jpeg"), // Replace with your image path
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.2), // Adjust opacity here
                                          BlendMode.dstATop,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 20,
                                    right: 20,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 130,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(13),
                                            color: isDark ? FlutterFlowTheme
                                                .of(context).darkBackground : FlutterFlowTheme.of(context).primaryBackground,
                                          ),
                                          child: Center(
                                              child: Text("Upgrade Plan",
                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),
                                              ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 30.0,right: 10,bottom: 50),
                              child: Container(
                                child: Row(

                                  children: [
                                    Icon(
                                      CupertinoIcons.moon_stars,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      "Dark mode",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: AdvancedSwitch(
                                          controller: isDarkMode,
                                          onChanged: (value){
                                            setState(() {
                                              dark_mode = value;
                                            });
                                            print("Dark mode: $dark_mode");
                                          },
                                          activeColor: Color(0xFF005C54)
                                      ),
                                    )
                                  ],
                                ),),
                            ),

                          ],
                        ),
                      ),





                    ],
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1, color: Colors.grey),
          Expanded(
            child: _getPage(_currentIndex),
          ),
        ],
      ),
    ),
      );
        }
    );
  }
}
