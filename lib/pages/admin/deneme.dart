import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:apart_asistan/service/auth_service.dart';
import 'package:apart_asistan/utils/custom_colors.dart';

class SendMessageApart extends StatefulWidget {
  const SendMessageApart({Key? key}) : super(key: key);

  @override
  State<SendMessageApart> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessageApart> with SingleTickerProviderStateMixin {
  late AnimationController lottieController;
  final TextEditingController _label = TextEditingController();
  bool isTextFieldEmpty = true;
  String? selectedValue;
  late String name = "";
  late String kapiNo = "";
  late String surname = "";
  late String binaNo = "";
  late String adminId = "";
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<String> dropdownItems = [];

  final User? user = AuthService().currentUser;

  @override
  void initState() {
    super.initState();
    getInfo();
    lottieController = AnimationController(
      vsync: this,
    );
    lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        lottieController.reset();
      }
    });
  }

  Future<void> getInfo() async {
    var userInfo = await AuthService().getTitle(user);
    setState(() {
      name = userInfo?["name"] ?? "";
      kapiNo = userInfo!["kapiNo"];
      binaNo = userInfo["binaNo"];
      surname = userInfo["surname"];
      adminId = userInfo["adminId"];
    });
    CollectionReference siteRef = firebaseFirestore.collection("oguzkent");
    QuerySnapshot<Object?> querySnapshot = await siteRef.get(); // Fetch the data once

    List<String> items = querySnapshot.docs
        .map((doc) => doc.get("binaNo") as String?) // Use "binaNo" or adjust accordingly
        .where((item) => item != null)
        .cast<String>()
        .toList();

    setState(() {
      dropdownItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(IconlyLight.arrow_left_2, color: Colors.white),
              ),
              backgroundColor: Colors.black,
              centerTitle: true,
              title: const Text(
                "Binaya Mesaj Yaz",
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          icon: const Icon(IconlyLight.arrow_down_2, color: Colors.amber),
                          hint: const Text(
                            "Alıcı Bina",
                            style: TextStyle(color: Colors.grey),
                          ),
                          dropdownColor: const Color.fromARGB(255, 54, 53, 53),
                          value: selectedValue,
                          items: dropdownItems.map((String binaNo) {
                            return DropdownMenuItem(
                              value: binaNo,
                              child: Text(binaNo),
                            );
                          }).toList(),
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
                  const SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.white)),
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
                        maxLines: null,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                            hintText: 'Mesajınızı buraya girin',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> ekle = {
                            "label": _label.text,
                            "sender": selectedValue,//1A vs..
                          };
                          if (selectedValue != null && _label.text != "") {
                            CollectionReference adminsRef = firebaseFirestore.collection("admins");
                            await adminsRef.doc(adminId).update({
                              "$selectedValue": FieldValue.arrayUnion([ekle])
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
                        },
                        child: const Text("Gönder"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      }


  showCustomMessage(BuildContext context) {
    FToast tostt = FToast();
    tostt.init(context);
    Widget toast = Container(
      width: 70,
      height: 70,
      child: Lottie.network("https://lottie.host/d68b5ed5-15c1-4236-a24b-88210856628a/MWkALsxXxT.json"),
    );
    tostt.showToast(
      positionedToastBuilder: (context, child) =>
          Positioned(top: MediaQuery.of(context).size.height - 200, left: 0, right: 0, child: child),
      child: toast,
      toastDuration: const Duration(milliseconds: 1600),
    );
  }
