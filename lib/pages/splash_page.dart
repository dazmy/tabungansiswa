import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tabungan_siswa/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    startLaunch();
    super.initState();
  }

  startLaunch() async {
    final box = Hive.box('box');
    bool isLogin = box.get('isLogin') ?? false;
    Timer(const Duration(seconds: 3), () {
      (isLogin) ? Navigator.pushReplacementNamed(context, '/main') : Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tabungan Siswa', style: primaryTextStyle.copyWith(fontSize: 30, fontWeight: bold),),
            const SizedBox(height: 5,),
            Text('SDN Margadadi 4', style: tertiaryTextStyle.copyWith(fontSize: 25, fontWeight: semiBold),),
          ],
        ),
      ),
    );
  }
}
