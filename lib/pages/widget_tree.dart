import 'package:apart_asistan/pages/home_page.dart';
import 'package:apart_asistan/pages/kullanici_page.dart';
import 'package:apart_asistan/pages/login_page.dart';
import 'package:apart_asistan/service/auth_service.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: AuthService().authStateChanges, 
    builder:(context, snapshot) {
      if (snapshot.hasData) {
        return KullaniciPage();
      } else {
        return const LoginPage();
      }
    },);
  }
}