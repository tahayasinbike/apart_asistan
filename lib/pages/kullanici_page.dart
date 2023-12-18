import 'package:apart_asistan/service/auth_service.dart';
import 'package:apart_asistan/utils/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class KullaniciPage extends StatefulWidget {
  const KullaniciPage({Key? key}) : super(key: key);

  @override
  State<KullaniciPage> createState() => _KullaniciPageState();
}

class _KullaniciPageState extends State<KullaniciPage> {
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
  Future<void> signOut()async{
    await AuthService().signOut();
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    CollectionReference siteRef = firebaseFirestore.collection("oguzkent");
    var userKod = siteRef.doc(user!.uid); //{name: taha, surname:bike}
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDial(
            icon: Icons.menu, //icon on Floating action button
            activeIcon: Icons.close, //icon when menu is expanded on button
            backgroundColor: Colors.deepOrangeAccent, //background color of button
            foregroundColor: Colors.white, //font color, icon color in button
            activeBackgroundColor: Colors.deepPurpleAccent, //background color when menu is expanded
            activeForegroundColor: Colors.white,
            visible: true,
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'), // action when menu opens
            onClose: () => print('DIAL CLOSED'), //action when menu closes

            elevation: 8.0, //shadow elevation of button
            shape: CircleBorder(), //shape of button
            
            children: [
              SpeedDialChild( //speed dial child
                child: Icon(Icons.accessibility),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                label: 'First Menu Child',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () => print('FIRST CHILD'),
                onLongPress: () => print('FIRST CHILD LONG PRESS'),
              ),
              SpeedDialChild(
                child: Icon(Icons.brush),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                label: 'Second Menu Child',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () => print('SECOND CHILD'),
                onLongPress: () => print('SECOND CHILD LONG PRESS'),
              ),
              SpeedDialChild(
                child: Icon(Icons.keyboard_voice),
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                label: 'Third Menu Child',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () => print('THIRD CHILD'),
                onLongPress: () => print('THIRD CHILD LONG PRESS'),
              ),

              //add more menu item children here
            ],
          ),
      backgroundColor: CustomColors.bodyColor,
      key: scaffoldKey,
      drawer: const Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: CustomColors.darkColor,
        title: binaNo !="" && kapiNo !="" ? Text("($binaNo-$kapiNo) ",style: const TextStyle(color: CustomColors.lightColor),) : const CircularProgressIndicator(),
        centerTitle: true,
        leading: IconButton(onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        }, icon: const Icon(Icons.miscellaneous_services, color: CustomColors.lightColor,)),
        actions: [IconButton(onPressed: signOut, icon:  const Icon(Icons.logout_outlined, color: CustomColors.lightColor,)),],
      ),
      body: SingleChildScrollView(
        child: 
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Card(
                  
                  color: CustomColors.cardColor,
                              child: ListTile(
                
                title: Text(name +"  " +surname,style: const TextStyle(color: CustomColors.darkColor),),
                subtitle: Text(site,style: const TextStyle(color: CustomColors.darkColor)),
                              ),
                              ),
              ),
            ],
          ),
        
      ),
    /* bottomNavigationBar: BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: CustomColors.lightColor,
      child: IconTheme(data: IconThemeData(
        color: CustomColors.darkColor
      ), child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
           IconButton(onPressed: () {
             
           }, icon: Icon(Icons.wallet)),
           IconButton(onPressed: () {
             
           }, icon: Icon(Icons.chat))
          ],
        ), 
      )),
    ), */
    );
  }
}
