import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  //!ANONİM(MİSAFİR)
  Future signInAnonymous() async {
    try {
      final result = await firebaseAuth.signInAnonymously();
      print(result.user!.uid);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //!SİGNUP
  Future signUp(String email, String password, String fullname) async {
    String errors;
    try {
      var userResult = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      try {
        final resultData = firebaseFirestore.collection("Users").add({
          "email": email,
          "fullname": fullname,
        });
      } catch (e) {
        print(e);
      }
      errors = 'success';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          errors = "Mail Zaten Kayitli.";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          errors = "Gecersiz Mail";
          break;
        default:
          errors = "Bir Hata Ile Karsilasildi, Birazdan Tekrar Deneyiniz.";
          break;
      }
    }
    return errors;
  }

  //!LOGİN
  Future signIn(String email, String password) async {
    String errors;
    try {
      final userResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      print(userResult.user!.email);
      errors = 'success';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          errors = "Kullanici Bulunamadi";
          break;
        case "wrong-password":
          errors = "Hatali Sifre";
          break;
        case "user-disabled":
          errors = "Kullanici Pasif";
          break;
        default:
          errors = "Bir Hata Ile Karsilasildi, Birazdan Tekrar Deneyiniz.";
          break;
      }
    }
    return errors;
  }
}
