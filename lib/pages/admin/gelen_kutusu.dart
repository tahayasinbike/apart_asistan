import 'package:apart_asistan/service/auth_service.dart';
import 'package:apart_asistan/utils/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class GelenKutusu extends StatefulWidget {
  const GelenKutusu({Key? key}) : super(key: key);

  @override
  State<GelenKutusu> createState() => _GelenKutusuState();
}

class _GelenKutusuState extends State<GelenKutusu> {
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

                    if (data != null && data.containsKey('gelenBox') && data['gelenBox'] is List) {
                      List<dynamic> gelenBoxList = data['gelenBox'];

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
                                             Center(child: Text("${gelenBoxItem["adress"]}",style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
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
                                              'gelenBox':
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
                      // Handle if 'gelenBox' does not exist or is not a List
                      return const Center(child: Text("'gelenBox' not found or is not a List"));
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
/* import 'package:apart_asistan/service/auth_service.dart';
import 'package:apart_asistan/utils/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GelenKutusu extends StatefulWidget {
  const GelenKutusu({super.key});

  @override
  State<GelenKutusu> createState() => _GelenKutusuState();
}

class _GelenKutusuState extends State<GelenKutusu> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final User? user = AuthService().currentUser;
  late CollectionReference adminsRef;
  late String adminId = "";
  @override
  void initState() {
    super.initState();
    getInfo();
  }
  Future<void> getInfo()async{
     var userInfo =await AuthService().getTitle(user);

     setState(() {
        adminId = userInfo?["adminId"] ?? "";
     });
  }
  @override
  Widget build(BuildContext context) {
    CollectionReference adminsRef = firebaseFirestore.collection("admins");
    DocumentReference adminIdRef = adminsRef.doc(adminId);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Gelen Kutusu", style: TextStyle(color: Colors.black, fontSize: 17),),
      bottom: PreferredSize(preferredSize: const Size.fromHeight(4.0), child:Container(
          height: 1.0,
          decoration: const BoxDecoration(
            color: CustomColors.cardColor,
            boxShadow: [BoxShadow(blurRadius: 6,offset: Offset(0, 1), spreadRadius: 0.3)],
          ),
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: 800,
            child: Column(
              children: [
               
                  StreamBuilder<DocumentSnapshot>(//Text("${asyncSnapshot.data.data()["gelenBox"][0]["label"]}"); 
              stream: adminIdRef.snapshots(), //ben neyi dinliycem kardeşim
              builder:(BuildContext context, AsyncSnapshot asyncSnapshot){
                     //firebaseden gelen document asyncSnapshota kondu önce asyncSnap ı açıp ondan sonda docu açıp içindeki mapa ulaşıyoruz
                return Flexible(
                  child: ListView.builder(
                    itemCount: asyncSnapshot.data.data()["gelenBox"].length,
                    itemBuilder: (BuildContext context, int index) {
                      if (asyncSnapshot.hasError) {
                       return const Center(child: Text("Hata olustu Tekrar Deneyiniz"),);  //hata olduysa texti bastır
                      }else{
                        if (asyncSnapshot.hasData) {
                          return Card(
                        child: ListTile(

                          title: Text("${asyncSnapshot.data.data()["gelenBox"][index]["sender"]}"),

                          subtitle: Text("${asyncSnapshot.data.data()["gelenBox"][index]["label"]}"),

                          trailing: IconButton(onPressed: () async{

                          await asyncSnapshot.data.data()["gelenBox"][index].reference.delete();
                          
                          },
                          icon: const Icon(Icons.delete)),
                        ),
                      );
                        }else{
                          return const Center(child: CircularProgressIndicator(),);
                        }
                         }
                      
                    },
                  ),
                
                ); 
              }
              ),
              ],
            ),
          ),
          ),
          
      ),
    );
  }
} */