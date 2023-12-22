import 'package:apart_asistan/utils/custom_colors.dart';
import 'package:apart_asistan/widgets/mesaj_container.dart';
import 'package:flutter/material.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          const SizedBox(height: 40,),
          const SizedBox(
            child: Text("Yöneticiden Gelen Mesajlarım", style: TextStyle(color: CustomColors.cardColor, fontSize: 20),),
          ),
          const SizedBox(height: 20,),
          mesajContainer(150,Colors.white),//yönetimden gelen mesajlar
          const SizedBox(height: 20,),
          const SizedBox(
            child: Text("Apartman İçi Mesajlar", style: TextStyle(color: CustomColors.cardColor, fontSize: 20),),
          ),
          const SizedBox(height: 20,),
          mesajContainer(200,Colors.white),//binaya gelen yönetim mesajları
          const SizedBox(height: 20,),
          const SizedBox(
            child: Text("Site İçi Mesajlarım", style: TextStyle(color: CustomColors.cardColor, fontSize: 20),),
          ),
          const SizedBox(height: 20),
          mesajContainer(150,Colors.white),//siteye gelen yönetim mesajları
        ],
      ),
    );
  }
}