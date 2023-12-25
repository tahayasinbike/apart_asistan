import 'package:apart_asistan/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
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
  bool isTextFieldEmpty = true;
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
          const SizedBox(height: 40),
          const SizedBox(
            child: Text(
              "Yöneticiye Mesaj Gönder",
              style: TextStyle(color: Colors.white, fontSize: 20),
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
                    "adress": binaNo+"-"+kapiNo
                    };
                    if (selectedValue != null && _label.text != "") {
                      await adminsRef.doc(adminId).update({
                      "gelenBox": FieldValue.arrayUnion([
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
