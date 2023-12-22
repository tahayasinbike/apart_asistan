import 'package:apart_asistan/service/auth_service.dart';
import 'package:apart_asistan/utils/custom_colors.dart';
import 'package:apart_asistan/widgets/custom_texts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String name = "";
  late String kapiNo = "";
  late String site = "";
  late String binaNo = "";
  late String surname = "";
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final User? user = AuthService().currentUser;
  late CollectionReference siteRef; 
  @override
  void initState() {
    super.initState();
    getInfo();
  }
  Future<void> getInfo()async{
     var userInfo =await AuthService().getTitle(user);
     setState(() {
        name = userInfo?["name"] ?? "";
        kapiNo = userInfo!["kapiNo"];
        site =userInfo["site"];
        binaNo =userInfo["binaNo"];
        surname =userInfo["surname"];
     });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: 
          Padding(
            padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,//baştan başlatıyor
              children: [
                Card(
                  
                  color: CustomColors.cardColor,
                              child: ListTile(
                
                title: Text(name +"  " +surname,style: const TextStyle(color: CustomColors.darkColor),),
                subtitle: Text(site,style: const TextStyle(color: CustomColors.darkColor)),
                              ),
                              ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 15),
                  child: Container(child: Row(
                    children: [
                      customText("AİDAT \nDETAYLARIM", CustomColors.cardColor, 25),
                       Padding(
                         padding: const EdgeInsets.only(left:150),
                         child: Icon(IconlyLight.wallet, color: Colors.white,size: 50,),
                       )
                    ],
                  )),),
                
                Stack(
                  children:[
                    Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: CustomColors.lightColor),
                      color: CustomColors.darkColor,
                      borderRadius: const BorderRadius.all(Radius.elliptical(35, 30))
                    ),
                    width: double.infinity,
                    height: 300,

                  ),
                     Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      decoration:  BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: CustomColors.lightColor),
                        color: CustomColors.darkColor,
                        borderRadius: const BorderRadius.all(Radius.elliptical(35, 30))
                      ),
                      width: double.infinity,
                      height: 300,
                      
                      
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Container(
                      alignment: Alignment.topLeft,
                      decoration:  BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: CustomColors.lightColor),
                        color: CustomColors.darkColor,
                        borderRadius: const BorderRadius.all(Radius.elliptical(35, 30))
                      ),
                      width: double.infinity,
                      height: 300,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          
                          children: [
                           
                          ],
                        ),
                      ),
                      
                    ),
                  ),
                  ] 
                ),

              ]
            ),
          ),
        
      );
  }
}