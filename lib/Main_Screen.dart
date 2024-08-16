import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:my_drona/pages/m_y_profile_page/m_y_profile_page_widget.dart';
import 'package:my_drona/pages/main_screens/dashboard_Screen/dashboard_Screen.dart';
import 'package:my_drona/pages/main_screens/quiz_practice_screen/quiz_practice_screen.dart';
import 'package:my_drona/pages/test_history/test_history.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildIcon(IconData icon, bool isSelected, int index) {
    return Stack(
      alignment: Alignment.center,
      key: ValueKey<int>(isSelected ? index : -index),
      children: [
        if (isSelected)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        Icon(
          icon,
          color: isSelected ? Colors.green : Colors.white,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const QuizPracticeScreen();
      case 2:
        return const TestHistory();
      case 3:
        return MYProfilePageWidget();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        // Main content
        _getPage(_currentIndex),

        // Bottom navigation bar
        Positioned(
            left: 10,
            right: 10,
            bottom: height > 700 ? 45 : 10,
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width - 50,
              decoration: BoxDecoration(
                color: Color(0xFF00968A),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            )
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 10,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animation.value * 120),
                child: child,
              );
            },
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onTabTapped,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Color(0xFF00968A),
                unselectedItemColor: Colors.white,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 100),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: _buildIcon(CupertinoIcons.home, _currentIndex == 0, 0),
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: _buildIcon(CupertinoIcons.search, _currentIndex == 1, 1),
                    ),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: _buildIcon(CupertinoIcons.book, _currentIndex == 2, 2),
                    ),
                    label: 'Your Library',
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: _buildIcon(CupertinoIcons.person_alt, _currentIndex == 3, 3),
                    ),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
