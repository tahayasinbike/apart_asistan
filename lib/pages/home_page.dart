import 'package:apart_asistan/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
   const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController ratingController = TextEditingController();

  final User? user= AuthService().currentUser;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  
  Future<void> signOut()async{
    await AuthService().signOut();
  }

  Widget _title(){
    return const Text("Firebase Auth");
  }

  Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut, child:const Text("Sign Out"));
  }

  Widget _userId(){
    return Text(user?.uid ?? "null");
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference moviesRef = firebaseFirestore.collection("movies");
    var babaRef = moviesRef.doc("Baba");
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _userId(),
            _signOutButton(),
            
            
            /* ElevatedButton(onPressed: () async{
              var response = await babaRef.get();     //response documentSnapshot dönüyor veriyi snapshota koyuyor bizde kullanmak için .data() yaparız
              dynamic map = response.data();          //burda bize gelen {name: Baba, year: 2023, rating: 3}
              print(map["name"]);                     // bu şekilde Babayı bastırdık  
            }, child: const Text("Get Document SnapShot")),
            
            
            ElevatedButton(onPressed: () async{
              var response = await moviesRef.get();
              var list = response.docs; 
              print(list[1].data());             //farkları bu diğer bütün docları listeye koyuyor ondan sonra .data
            }, child: const Text("Get Query SnapShot")), */


            //Text("${babaRef.id}"),
            //Text("${babaRef.path}"),

            StreamBuilder<DocumentSnapshot>(
              stream: babaRef.snapshots(), //ben neyi dinliycem kardeşim
              builder:(BuildContext context, AsyncSnapshot asyncSnapshot){
                return Text("${asyncSnapshot.data.data()}");     //firebaseden gelen document asyncSnapshota kondu önce asyncSnap ı açıp ondan sonda docu açıp içindeki mapa ulaşıyoruz
              }  //bu verileri dinleyince napıcam
              ),
            StreamBuilder<QuerySnapshot>(
              stream: moviesRef.snapshots(), //ben neyi dinliycem kardeşim
              builder:(BuildContext context, AsyncSnapshot asyncSnapshot){
                

                if (asyncSnapshot.hasError) {
                  return const Center(child: Text("Hata olustu Tekrar Deneyiniz"),);  //hata olduysa texti bastır
                } else {
                  if (asyncSnapshot.hasData) {        //data gelmişse datayı yoldaysa circularprogress
                  List<DocumentSnapshot> listOfDocumentSnapShot= asyncSnapshot.data.docs;
                    return Flexible(
                  child: ListView.builder(
                    itemCount: listOfDocumentSnapShot.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(

                          title: Text("${listOfDocumentSnapShot[index]["name"]}"),

                          subtitle: Text("${listOfDocumentSnapShot[index]["rating"]}"),

                          trailing: IconButton(onPressed: () async{

                          await listOfDocumentSnapShot[index].reference.delete();
                          
                          },
                          icon: const Icon(Icons.delete)),
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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 100),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(hintText: "Filmin adini giriniz"),
                      ),
                      TextFormField(
                        controller: ratingController,
                        decoration: const InputDecoration(hintText: "Filmin ratingini giriniz"),
                      ),
                    ],
                  )
                  ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async{
       /*  Map<String,dynamic> movieData = {   //set içinde kullandığımızdan isnt used diyor
          "name":nameController.text,
          "rating":ratingController.text
        }; */
        //await moviesRef.doc(nameController.text).set(movieData); //şimdilik film doc adı ile namesi aaynı olsun yaptık ve hepsini günceller
        await moviesRef.doc(nameController.text).update({"rating":ratingController.text, "saat":300}); // bu sayede belirli istediğimizi diğerleri sabit kalcak şekilde güncelleyebiliriz ayrıca olmayan bişeyi de eklyebiliriz mesela saat
      
      },
      child: const Text("Ekle"),
      ),
    );
  }
}