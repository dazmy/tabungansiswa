import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tabungan_siswa/pages/main/class/class_page.dart';
import 'package:tabungan_siswa/pages/main/home/home_page.dart';
import 'package:tabungan_siswa/pages/main/profile/profile_page.dart';
import 'package:tabungan_siswa/providers/homepage_provider.dart';
import 'package:tabungan_siswa/theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = const [
    HomePage(),
    ClassPage(),
    ProfilePage(),
  ];

  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget customButtonNav() {
      return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: backgroundColorPrimary,
        unselectedItemColor: tertiaryTextColor,
        unselectedFontSize: 0,
        selectedFontSize: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 35,), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.class_, size: 32,), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 40,), label: ''),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: customButtonNav(),
      // floatingActionButton: (currentIndex == 1) ? FloatingActionButton(onPressed: () {}, backgroundColor: backgroundColorPrimary, child: const Icon(Icons.add, size: 30,),) : const SizedBox(),
    );
  }
}
