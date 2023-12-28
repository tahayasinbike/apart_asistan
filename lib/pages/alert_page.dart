import 'package:apart_asistan/service/auth_service.dart';
import 'package:apart_asistan/utils/custom_colors.dart';
import 'package:apart_asistan/widgets/mesaj_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final User? user = AuthService().currentUser;
  late CollectionReference adminsRef;
  late String adminId = "";
  late String name = "";
  late String kapiNo = "";
  late String surname = "";
  late String binaNo = "";

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Future<void> getInfo() async {
    var userInfo = await AuthService().getTitle(user);

    setState(() {
      adminId = userInfo?["adminId"] ?? "";
      name = userInfo?["name"] ?? "";
      kapiNo = userInfo!["kapiNo"];
      binaNo =userInfo["binaNo"];
      surname =userInfo["surname"];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (adminId.isEmpty) {
      // Handle the case where adminId is empty
      return Scaffold(
         backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(IconlyLight.arrow_left_2, color: Colors.white,)),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            "Gelen Kutusu",
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
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    CollectionReference siteRef = firebaseFirestore.collection("oguzkent");
    CollectionReference adminsRef = firebaseFirestore.collection("admins");
    DocumentReference adminIdRef = adminsRef.doc(adminId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          const SizedBox(height: 40,),
          const SizedBox(
            child: Text("Yöneticiden Gelen Mesajlarım", style: TextStyle(color: CustomColors.cardColor, fontSize: 20),),
          ),
          const SizedBox(height: 20,),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
          ),//yönetimden gelen mesajlar
           SizedBox(height: 20,),
          const SizedBox(
            child: Text("Apartman İçi Mesajlar", style: TextStyle(color: CustomColors.cardColor, fontSize: 20),),
          ),
          const SizedBox(height: 20,),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            
          ),//binaya gelen yönetim mesajları
          const SizedBox(height: 20,),
          const SizedBox(
            child: Text("Site İçi Mesajlarım", style: TextStyle(color: CustomColors.cardColor, fontSize: 20),),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: StreamBuilder(
              stream: adminIdRef.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> asyncSnapshot) {
                    if (!asyncSnapshot.hasData || !asyncSnapshot.data!.exists) {
                      return const Center(child: Text("Document not found"));
                    }

                    Map<String, dynamic>? data =
                        asyncSnapshot.data!.data() as Map<String, dynamic>?;

                    if (data != null && data.containsKey('siteGelen') && data['siteGelen'] is List) {
                      List<dynamic> gelenBoxList = data['siteGelen'];

                      return Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: gelenBoxList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (gelenBoxList[index] is Map<String, dynamic>) {
                              Map<String, dynamic> gelenBoxItem =
                                  gelenBoxList[index] as Map<String, dynamic>;
                        
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                useSafeArea: true,
                                context: context, 
                                builder: (context) {
                                  return Dialog(
                                    child: SizedBox(
                                      height: 400,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: ListView(
                                          children: [
                                             Center(child: Text("${gelenBoxItem["sender"]}",style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                             Center(child: Text("${gelenBoxItem["label"]}",style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                                             const SizedBox(height: 15),
                                             Text("${gelenBoxItem["label"]}",style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                             const SizedBox(height: 20),
                                             
                                             
                                          ],
                                        ),
                                        ),
                        
                                    ),
                                  );
                                },);
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text("${gelenBoxItem["sender"]}"),
                                    subtitle: Text("${gelenBoxItem["label"]}",overflow: TextOverflow.ellipsis,),
                                    trailing: IconButton(
                                      onPressed: () async {
                                        await adminIdRef
                                            .update({
                                              'siteGelen':
                                                  FieldValue.arrayRemove([gelenBoxItem])
                                            })
                                            .then((value) => print("Item Deleted"))
                                            .catchError(
                                                (error) => print("Failed to delete item: $error"));
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      );
                    } else {
                      // Handle if 'siteGelen' does not exist or is not a List
                      return const Center(child: Text("'siteGelen' not found or is not a List"));
                    }
                  },),
          ),//siteye gelen yönetim mesajları
        ],
      ),
    );
  }
}