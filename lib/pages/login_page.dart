import 'package:apart_asistan/service/auth_service.dart';
import 'package:apart_asistan/utils/custom_colors.dart';
import 'package:apart_asistan/utils/input_decoration.dart';
import 'package:apart_asistan/widgets/custom_sized_box.dart';
import 'package:apart_asistan/widgets/custom_texts.dart';
import 'package:apart_asistan/widgets/top_image_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = "";
  bool isLogin = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> singInWithEmailAndPass()async {
    try {
      await AuthService().signIn(email: _emailController.text, password: _passwordController.text);
    }on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }
  Future<void> createUserWithEmailAndPass()async {
    try {
      await AuthService().signUp(email: _emailController.text, password: _passwordController.text);
    }on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }
  Widget _errorMessage(){
    return Text(errorMessage == "" ? "" : "Humm ? $errorMessage", style: TextStyle(color: Colors.white),);
  }
  Widget _girisyap(){
    return ElevatedButton(onPressed: isLogin ? singInWithEmailAndPass : createUserWithEmailAndPass, 
    child:Text("Giris Yap"));
  }
  Widget _kayitol(){
    return TextButton(onPressed: () {
      AuthService().signUp(email: _emailController.text, password: _passwordController.text);
    }, child: Text("Kayit Ol"));
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    String topImage = "assets/tepe.png";
    //String homeImage = "assets/home.png";
    return Scaffold(
      backgroundColor: CustomColors.darkColor,
      body: appBody(height, topImage),
    );
  }

  SingleChildScrollView appBody(double height, String topImage){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topImageContainer(height, topImage),
           Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              titleText("Merhaba, \nHosgeldin"),
              customSizedBox(20),
              emailTextField(),
              customSizedBox(20),
              passwordTextField(),
              _errorMessage(),
              customSizedBox(20),
              _girisyap(),
              customSizedBox(20),
              _kayitol()
          
            ],
          ),
          )
        ],
      ),
    );
  }



TextFormField emailTextField() {
    return TextFormField(
      controller: _emailController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
      },
      style: const TextStyle(color: Colors.white),
      decoration: customInputDecoration("Email"),
    );
  }
  TextFormField passwordTextField() {
    return TextFormField(
      controller: _passwordController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
      },
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: customInputDecoration("Sifre"),
    );
  }
}



