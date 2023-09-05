import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/palette.dart';
import 'package:laravel_smapp/providers/light_mode_provider.dart';
import 'package:laravel_smapp/screens/all_posts_screen.dart';
import 'package:laravel_smapp/screens/home_screen.dart';
import 'package:laravel_smapp/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const AllPostsScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    Palette palette = Palette.fromDarkMode(context);
    bool isDarkMode = Provider.of<LightMode>(context, listen: true).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        actions: [
          // light mode
          IconButton(
            onPressed: () {
              context.read<LightMode>().changeLightMode();
            },
            icon: isDarkMode
                ? Icon(
                    Icons.light_mode,
                    color: palette.iconColor,
                  )
                : Icon(
                    Icons.dark_mode,
                    color: palette.iconColor,
                  ),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: palette.iconColor,
        unselectedItemColor: palette.buttonColor,
        selectedLabelStyle: TextStyle(color: palette.primaryColor),
        backgroundColor: palette.bgColor,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: palette.iconColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.all_inclusive,
              color: palette.iconColor,
            ),
            label: 'Global',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: palette.iconColor,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
