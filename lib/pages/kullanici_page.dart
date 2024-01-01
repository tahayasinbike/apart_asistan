import 'package:apart_asistan/pages/admin/all_users.dart';
import 'package:apart_asistan/pages/admin/elevator_gelen_kutusu.dart';
import 'package:apart_asistan/pages/admin/gelen_kutusu.dart';
import 'package:apart_asistan/pages/admin/send_message_apart.dart';
import 'package:apart_asistan/pages/admin/send_message_site.dart';
import 'package:apart_asistan/pages/admin/send_message_user.dart';
import 'package:apart_asistan/pages/alert_page.dart';
import 'package:apart_asistan/pages/elevator_page.dart';
import 'package:apart_asistan/pages/main_page.dart';
import 'package:apart_asistan/pages/message_page.dart';
import 'package:apart_asistan/service/auth_service.dart';
import 'package:apart_asistan/utils/custom_colors.dart';
import 'package:apart_asistan/widgets/custom_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class KullaniciPage extends StatefulWidget {
  const KullaniciPage({Key? key}) : super(key: key);

  @override
  State<KullaniciPage> createState() => _KullaniciPageState();
}

class _KullaniciPageState extends State<KullaniciPage> {
  List<Widget> body = [
    const MainPage(),
    const AlertPage(),
    const ElevatorPage(),
    const MessagePage(),
  ];
  int pageIndex = 0;
  late String name = "";
  late String kapiNo = "";
  late String site = "";
  late String binaNo = "";
  late String surname = "";
  late String? rol = "";
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final User? user = AuthService().currentUser;
  late CollectionReference siteRef; 
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
        site =userInfo["site"];
        binaNo =userInfo["binaNo"];
        surname =userInfo["surname"];
        rol = userInfo["rol"];
     });
  }


  Future<void> signOut()async{
    await AuthService().signOut();
  }
 
  

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  
  @override
  Widget build(BuildContext context) {
    
    CollectionReference siteRef = firebaseFirestore.collection("oguzkent");
    var userKod = siteRef.doc(user!.uid); //{name: taha, surname:bike}
    
    return Scaffold(
      drawer: rol !=null ? SafeArea(
        child:Drawer(
          backgroundColor: const Color.fromARGB(143, 0, 0, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTileMethod(context: context, icon: IconlyLight.add_user, titlee: "Kullanıcı ekle",),
                ListTileMethod(context: context, titlee: "Oturanlar", icon: IconlyLight.user, sayfa: const AllUsers()),
                ListTileMethod(context: context, titlee: "Gelen Kutusu", icon: IconlyLight.message,sayfa: const GelenKutusu()),
                ListTileMethod(context: context, titlee: "Siteye Gönder", icon: IconlyLight.edit, sayfa: const SendMessage()),
                ListTileMethod(context: context, titlee: "Binaya Gönder", icon: IconlyLight.edit, sayfa: const SendMessageApart()),
                ListTileMethod(context: context, titlee: "Kişiye Gönder", icon: IconlyLight.edit, sayfa: const SendMessageUser()),
                ListTileMethod(context: context, titlee: "Asansör Arıza", icon: IconlyLight.danger, sayfa: const ElevatorGelenKutusu())
              ],
            ),
          ),
        ) 
      ) : const SizedBox.shrink(),

      key: scaffoldKey,
      backgroundColor: CustomColors.bodyColor,
      bottomNavigationBar: BottomNavigationBar(
        items: const [BottomNavigationBarItem(
        icon: Icon(IconlyLight.home, color: Colors.grey,),
        activeIcon: Icon(IconlyBold.home, color: Colors.amber,),
          label: "",
          backgroundColor: Colors.black
          
        ),
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.notification, color: Colors.grey,),
          activeIcon: Icon(IconlyBold.notification, color: Colors.amber,),
          label: "",
          backgroundColor: Colors.black
        ),
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.danger, color: Colors.grey,),
          activeIcon: Icon(IconlyBold.danger, color: Colors.amber,),
          label: "",
          backgroundColor: Colors.black
        ),
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.send, color: Colors.grey,),
          activeIcon: Icon(IconlyBold.send, color: Colors.amber,),
          label: "",
          backgroundColor: Colors.black
        )
        
        ],
        currentIndex: pageIndex,
        onTap: (int newPageIndex) {
          setState(() {
            pageIndex = newPageIndex;
          });
        },
        ),
      /* floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDial(
            icon: Icons.menu, //icon on Floating action button
            activeIcon: Icons.close, //icon when menu is expanded on button
            backgroundColor: Color.fromARGB(255, 178, 84, 77), //background color of button
            foregroundColor: Colors.white, //font color, icon color in button
            activeBackgroundColor: Colors.deepPurpleAccent, //background color when menu is expanded
            activeForegroundColor: Colors.white,
            visible: true,
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'), // action when menu opens
            onClose: () => print('DIAL CLOSED'), //action when menu closes

            elevation: 8.0, //shadow elevation of button
            shape: const CircleBorder(
              side: BorderSide(
                width: 2,
                color: Colors.white
              )
            ), //shape of button
            
            children: [
              SpeedDialChild( //speed dial child
                child: const Icon(Icons.notifications_active),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                label: 'Bildirimler',
                labelStyle: const TextStyle(fontSize: 18.0),
                onTap: () => print('FIRST CHILD'),
                onLongPress: () => print('FIRST CHILD LONG PRESS'),
              ),
              SpeedDialChild(
                child: const Icon(Icons.notification_important_outlined),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                label: 'Asansör Arıza Bildir',
                labelStyle: const TextStyle(fontSize: 18.0),
                onTap: () => print('SECOND CHILD'),
                onLongPress: () => print('SECOND CHILD LONG PRESS'),
              ),
              SpeedDialChild(
                child: const Icon(Icons.send),
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                label: 'Yöneticiye mesaj gönder',
                labelStyle: const TextStyle(fontSize: 18.0),
                onTap: () => print('THIRD CHILD'),
                onLongPress: () => print('THIRD CHILD LONG PRESS'),
              ),

              //add more menu item children here
            ],
          ), */
      
      appBar: AppBar(
        
        leading: rol != null ?IconButton(onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },icon: const Icon(IconlyLight.category, color: Colors.grey,),) :const SizedBox.shrink(),
        backgroundColor: CustomColors.appbarColor,
        title: binaNo !="" && kapiNo !="" ? Text("($binaNo-$kapiNo) ",style: const TextStyle(color: CustomColors.lightColor),) : const CircularProgressIndicator(),
        centerTitle: true,
        actions: [IconButton(onPressed: signOut, icon: const Icon(IconlyLight.logout, color: Colors.white,),),],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(4.0), child:Container(
          height: 1.0,
          decoration: const BoxDecoration(
            color: CustomColors.cardColor,
            boxShadow: [BoxShadow(blurRadius: 6,offset: Offset(0, 1), spreadRadius: 0.3)],
          ),
        )),
      ),
      body: body[pageIndex]
    
    );
  }
}
