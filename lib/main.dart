import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tabungan_siswa/pages/auth/login_page.dart';
import 'package:tabungan_siswa/pages/auth/register_page.dart';
import 'package:tabungan_siswa/pages/main/main_page.dart';
import 'package:tabungan_siswa/pages/main/profile/print_page.dart';
import 'package:tabungan_siswa/pages/splash_page.dart';
import 'package:tabungan_siswa/providers/auth_provider.dart';
import 'package:tabungan_siswa/providers/gradepage_provider.dart';
import 'package:tabungan_siswa/providers/homepage_provider.dart';
import 'package:tabungan_siswa/providers/pdf_provider.dart';
import 'package:tabungan_siswa/providers/profile_provider.dart';
import 'package:tabungan_siswa/providers/savings_provider.dart';
import 'package:tabungan_siswa/providers/student_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  var box = await Hive.openBox('box');

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    initializeDateFormatting('id_ID', null).then((_) {
      runApp(const MyApp());
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => HomepageProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => GradepageProvider()),
        ChangeNotifierProvider(create: (context) => SavingsProvider()),
        ChangeNotifierProvider(create: (context) => StudentProvider()),
        ChangeNotifierProvider(create: (context) => PDFProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/main': (context) => const MainPage(),
          '/print': (context) => const PrintPage(),
        },
      ),
    );
  }
}
