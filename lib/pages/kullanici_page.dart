import 'package:apart_asistan/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class KullaniciPage extends StatefulWidget {
  const KullaniciPage({Key? key}) : super(key: key);

  @override
  State<KullaniciPage> createState() => _KullaniciPageState();
}

class _KullaniciPageState extends State<KullaniciPage> {
  late String title = "";
  late String kapiNo = "";
  late String site = "";
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
        title = userInfo?["name"] ?? "";
        kapiNo = userInfo!["kapiNo"];
        site =userInfo["site"];
     });
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    CollectionReference siteRef = firebaseFirestore.collection("oguzkent");
    var userKod = siteRef.doc(user!.uid); //{name: taha, surname:bike}
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [

            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: title !="" ? Text("$title ($kapiNo) ",style: TextStyle(color: Colors.black),) : CircularProgressIndicator(),
        centerTitle: true,
        leading: IconButton(onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        }, icon: Icon(Icons.miscellaneous_services)),
        actions: [IconButton(onPressed: signOut, icon: Icon(Icons.logout_outlined)),],
      ),
      body: Center(
        child: Text(site, style: TextStyle(color: Colors.black),),
      ),
    );
  }
}
