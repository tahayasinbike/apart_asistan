import 'package:apart_asistan/service/auth_service.dart';
import 'package:apart_asistan/utils/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({super.key});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> with SingleTickerProviderStateMixin{
  late AnimationController lottieController;
  final TextEditingController _alici = TextEditingController();
  final TextEditingController _label = TextEditingController();
  bool isTextFieldEmpty = true;
  String? selectedValue;
  late String name = "";
  late String kapiNo = "";
  late String surname = "";
  late String binaNo = "";
  late String adminId = "";
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final User? user = AuthService().currentUser;
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(IconlyLight.arrow_left_2, color: Colors.white,)),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            "Mesaj Yaz",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              height: 1.0,
              decoration: const BoxDecoration(
                color: CustomColors.cardColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    offset: Offset(0, 1),
                    spreadRadius: 0.3,
                  ),
                ],
              ),
            ),
          ),
      ),
      body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              Flexible(
                child: DropdownButtonFormField<String>(
                    
                  icon: const Icon(IconlyLight.arrow_down_2, color: Colors.amber,),
                  hint: const Text("Alıcı",style: TextStyle(color: Colors.grey),),
                  dropdownColor: const Color.fromARGB(255, 54, 53, 53),
                  value: selectedValue,
                  items: [
                     DropdownMenuItem(
                      value: name+" "+surname,
                      child: name !="" && surname !="" ? Text(name+" "+surname) : const Text(""),
                    ),
                    DropdownMenuItem(
                      child: name !="" && surname !="" ? Text("Bütün Site") : const Text(""),
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
          const SizedBox(height: 40,),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white)
            ),
            height: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
              onChanged: (text) {
                setState(() {
                        isTextFieldEmpty = text.isEmpty;
                      });
              },
              cursorColor: Colors.amber,
              style: const TextStyle(color: Colors.white, fontSize: 17),
              controller: _label,
              maxLines: null, // Bu özelliği null olarak ayarlamak, kullanıcıya istediği kadar satır girmesine izin verir.
              decoration: const InputDecoration(
                hintStyle: TextStyle(fontSize: 17,color: Colors.grey),
                hintText: 'Mesajınızı buraya girin',
                border: InputBorder.none
              )
              ),
              
            ),
          ),
          const SizedBox(height: 20,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                
                onPressed: () async{
                 Map<String,dynamic> ekle = {
                    "label":_label.text,
                    "sender":selectedValue,
                    };
                    if (selectedValue != null && _label.text != "") {
                      await adminsRef.doc(adminId).update({
                      "siteGelen": FieldValue.arrayUnion([
                       ekle
                      ])
                      }); 
                      _label.clear();
                      showCustomMessage(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Gerekli alanları doldurunuz."),
                        duration: Duration(seconds: 2),
                       ),
                     );
                    }
                   
              }, child: const Text("Gönder"))
            ],
          ),
        ],
      ),
      )
    );
  }
    showCustomMessage(BuildContext context){
    FToast tostt = FToast();
    tostt.init(context);
    Widget toast = Container(
      width: 70,
      height: 70,
      child: Lottie.network("https://lottie.host/d68b5ed5-15c1-4236-a24b-88210856628a/MWkALsxXxT.json"),
    );
    tostt.showToast(
      positionedToastBuilder: (context, child) => Positioned(child:child,top: MediaQuery.of(context).size.height -200,left: 0,right: 0, ),
      child: toast, toastDuration: Duration(milliseconds: 1600));
    
  }
}
