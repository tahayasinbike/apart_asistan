import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signIn({required String email, required String password}) async{
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }
  Future<void> signUp({required String email, required String password}) async{
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }
  Future<void> signOut()async{
    await _firebaseAuth.signOut();
  }
  
  Future<Map<String, dynamic>?> getTitle(User? user)async{
    CollectionReference siteRef = _firebaseFirestore.collection("oguzkent");
    var userDoc = siteRef.doc(user!.uid); //{name: taha, surname:bike}
    var response = await userDoc.get() as DocumentSnapshot<Map<String, dynamic>>;
    return response.data();
  }
}
