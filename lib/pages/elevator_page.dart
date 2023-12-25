import 'package:apart_asistan/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

class ElevatorPage extends StatefulWidget {
  const ElevatorPage({super.key});

  @override
  State<ElevatorPage> createState() => _ElevatorPageState();
}

class _ElevatorPageState extends State<ElevatorPage> with SingleTickerProviderStateMixin{
  late AnimationController lottieController;
  final TextEditingController _sender = TextEditingController();
  final TextEditingController _label = TextEditingController();
  String? selectedValue;
  late String name = "";
  late String kapiNo = "";
  late String surname = "";
  late String binaNo = "";
  late String adminId = "";
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final User? user = AuthService().currentUser;
  late CollectionReference siteRef;
  late CollectionReference adminsRef;
  @override
  void initState() {
    super.initState();
    getInfo();
    lottieController = AnimationController(
      vsync: this,
    );
    lottieController.addStatusListener((status) async{
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        lottieController.reset();
      }
    });
  }
  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }
  Future<void> getInfo()async{
     var userInfo =await AuthService().getTitle(user);
     setState(() {
        name = userInfo?["name"] ?? "";
        kapiNo = userInfo!["kapiNo"];
        binaNo =userInfo["binaNo"];
        surname =userInfo["surname"];
        adminId =userInfo["adminId"];
     });
  }
  @override
  Widget build(BuildContext context) {
    CollectionReference siteRef = firebaseFirestore.collection("oguzkent");
    CollectionReference adminsRef = firebaseFirestore.collection("admins");
    var userKod = siteRef.doc(user!.uid); //{name: taha, surname:bike}
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          SizedBox(height: 40,),
          Center(
            child: const SizedBox(
              child: Text(
                "Asansör Arıza Bildir",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 30,),
          Row(
            children: [
              Flexible(
                child: DropdownButtonFormField<String>(
                    
                  icon: const Icon(IconlyLight.arrow_down_2, color: Colors.amber,),
                  hint: const Text("Gönderen",style: TextStyle(color: Colors.grey),),
                  dropdownColor: const Color.fromARGB(255, 54, 53, 53),
                  value: selectedValue,
                  items: [
                     DropdownMenuItem(
                      value: name+" "+surname,
                      child: name !="" && surname !="" ? Text(name+" "+surname) : const Text(""),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bilgileri Eksiksiz Doldurunuz";
                    } else {}
                  },
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    prefixIcon: Icon(IconlyLight.user, color: Colors.amber),
                     
                    
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30,),
          TextField(
            textCapitalization: TextCapitalization.characters, // sadece büyük karakter
            controller: _label,
            style: TextStyle(color: Colors.white, fontSize: 17),
            decoration: InputDecoration(
              hintText: "Bina Adı",
              hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
              prefixIcon: Icon(IconlyLight.home, color: Colors.amber,),
            ),

          ),
          const SizedBox(height: 40,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                
                onPressed: () async{
                 Map<String,dynamic> ekle = {
                    "arizaKod":_label.text,
                    "sender":selectedValue,
                    "adress": binaNo+"-"+kapiNo
                    };
                    if (selectedValue != null && _label.text != "") {
                      await adminsRef.doc(adminId).update({
                      "elevatorBox": FieldValue.arrayUnion([
                       ekle
                      ]),
                      
                      }); 
                      
                      showCustom(context);
                      _label.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Gerekli alanları doldurunuz."),
                        duration: Duration(seconds: 2),
                       ),
                     );
                    }
                    }, 
                child: const Text("Bildir")),
              
            ],
          ),
        ],
      ),
    );
  }
  
  showCustom(BuildContext context){
    FToast tost = FToast();
    tost.init(context);
    Widget toast = Container(
      width: 70,
      height: 70,
      child: Lottie.network("https://lottie.host/d68b5ed5-15c1-4236-a24b-88210856628a/MWkALsxXxT.json"),
    );
    tost.showToast(
      positionedToastBuilder: (context, child) => Positioned(child:child,top: MediaQuery.of(context).size.height -200,left: 0,right: 0, ),
      child: toast, toastDuration: Duration(milliseconds: 1600));
    
  }
}