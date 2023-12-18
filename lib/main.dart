import 'package:apart_asistan/firebase_options.dart';
import 'package:apart_asistan/pages/home_page.dart';
import 'package:apart_asistan/pages/login_page.dart';
import 'package:apart_asistan/pages/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        "/widgetTree" : (context) => const WidgetTree(),
        "/loginPage" :(context) => const LoginPage(),
        "/homePage" :(context) => HomePage()
      },
      home: const WidgetTree(),
    );
  }
}

