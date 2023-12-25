import 'package:apart_asistan/service/auth_service.dart';
import 'package:apart_asistan/utils/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ElevatorGelenKutusu extends StatefulWidget {
  const ElevatorGelenKutusu({Key? key}) : super(key: key);

  @override
  State<ElevatorGelenKutusu> createState() => _ElevatorGelenKutusuState();
}

class _ElevatorGelenKutusuState extends State<ElevatorGelenKutusu> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final User? user = AuthService().currentUser;
  late CollectionReference adminsRef;
  late String adminId = "";

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Future<void> getInfo() async {
    var userInfo = await AuthService().getTitle(user);

    setState(() {
      adminId = userInfo?["adminId"] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (adminId.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(IconlyLight.arrow_left_2, color: Colors.white,)),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            "Asansör Arıza Gelen Kutusu",
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

    CollectionReference adminsRef = firebaseFirestore.collection("admins");
    DocumentReference adminIdRef = adminsRef.doc(adminId);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(IconlyLight.arrow_left_2, color: Colors.white,)),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Asansör Arıza Gelen Kutusu",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: 800,
            child: Column(
              children: [
                SizedBox(height: 20,),
                StreamBuilder<DocumentSnapshot>(
                  stream: adminIdRef.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> asyncSnapshot) {
                    if (!asyncSnapshot.hasData || !asyncSnapshot.data!.exists) {
                      return const Center(child: Text("Document not found"));
                    }

                    Map<String, dynamic>? data =
                        asyncSnapshot.data!.data() as Map<String, dynamic>?;

                    if (data != null && data.containsKey('elevatorBox') && data['elevatorBox'] is List) {
                      List<dynamic> elevatorBoxList = data['elevatorBox'];

                      return Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: elevatorBoxList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (elevatorBoxList[index] is Map<String, dynamic>) {
                              Map<String, dynamic> elevatorBoxItem =
                                  elevatorBoxList[index] as Map<String, dynamic>;
                        
                              return Card(
                                child: ListTile(
                                  title: Text("${elevatorBoxItem["sender"]} ${elevatorBoxItem["adress"]}", maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  subtitle: Text("${elevatorBoxItem["arizaKod"]}"),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      await adminIdRef
                                          .update({
                                            'elevatorBox':
                                                FieldValue.arrayRemove([elevatorBoxItem])
                                          })
                                          .then((value) => print("Item Deleted"))
                                          .catchError(
                                              (error) => print("Failed to delete item: $error"));
                                    },
                                    icon: const Icon(Icons.delete),
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
                      // Handle if 'elevatorBox' does not exist or is not a List
                      return const Center(child: Text("'elevatorBox' not found or is not a List"));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
