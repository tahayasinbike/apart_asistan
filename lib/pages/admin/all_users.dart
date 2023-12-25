import 'package:apart_asistan/utils/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _InBoxState();
}

class _InBoxState extends State<AllUsers> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference siteRef; 
  @override
  Widget build(BuildContext context) {
    CollectionReference siteRef = firebaseFirestore.collection("oguzkent");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(IconlyLight.arrow_left_2, color: Colors.white,)),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Bütün Kullanıcılar", style: TextStyle(color: Colors.white, fontSize: 17),),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: 800,
            child: Column(
              children: [
                SizedBox(height: 20,),
                 StreamBuilder<QuerySnapshot>(
                stream: siteRef.snapshots(), //ben neyi dinliycem kardeşim
                builder:(BuildContext context, AsyncSnapshot asyncSnapshot){
                  
            
                  if (asyncSnapshot.hasError) {
                    return const Center(child: Text("Hata olustu Tekrar Deneyiniz"),);  //hata olduysa texti bastır
                  } else {
                    if (asyncSnapshot.hasData) {        //data gelmişse datayı yoldaysa circularprogress
                      List<DocumentSnapshot> listOfDocumentSnapShot= asyncSnapshot.data.docs;
                   return Flexible(
                     child: ListView.builder(
                       itemCount: listOfDocumentSnapShot.length, //kullanıcı idleri olduğu kısım
                       itemBuilder: (BuildContext context, int index) {
                       Map<String, dynamic>? data = listOfDocumentSnapShot[index].data() as Map<String, dynamic>?;
                       String name = data?["name"] ?? "";
                       String binaNo = data?["binaNo"] ?? "";
                       String kapiNo = data?["kapiNo"] ?? "";
                       String surname = data?["surname"] ?? "";
                       String site = data?["site"] ?? "";
                       String tel = data?["tel"] ?? "";
                       
                     
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
                                          Center(child: Text(binaNo+"  "+kapiNo,style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                          Center(child: Text(site,style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                                          const SizedBox(height: 15),
                                          Text(name+" "+surname,style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 20),
                                          Text(tel,style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                                          
                                          
                                       ],
                                     ),
                                     ),
                     
                                 ),
                               );
                             },);
                         },
                         child: Card(
                           child: ListTile(
                             title: Text(name+" "+surname),
                             subtitle: Text(binaNo+"  "+kapiNo),
                             trailing: IconButton(
                             onPressed: () async {
                               await listOfDocumentSnapShot[index].reference.delete();
                             },
                             icon: const Icon(Icons.delete),
                           ),
                         ),
                         ),
                       );
                                         },
                                       ),
                   );
                    }else{
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  }
                    //firebaseden gelen document asyncSnapshota kondu önce asyncSnap ı açıp ondan sonda docu açıp içindeki mapa ulaşıyoruz
                }  //bu verileri dinleyince napıcam
                ),
              ],
            ),
          ),
          ),
      ),
      
    );
  }
}