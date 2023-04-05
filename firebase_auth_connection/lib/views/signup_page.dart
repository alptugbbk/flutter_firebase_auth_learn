import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_connection/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUp> {
  late String email, password, fullname;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                fullnameTextField(),
                sizedBox(),
                emailTextField(),
                sizedBox(),
                passwordTextField(),
                sizedBox(),
                signupButton(),
                sizedBox(),
                loginBackButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField fullnameTextField() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Fullname'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'bilgileri eksiksiz doldurunuz';
        }
      },
      onSaved: (newValue) {
        fullname = newValue!;
      },
    );
  }

  TextButton loginBackButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/loginPage');
      },
      child: Text('login back'),
    );
  }

  ElevatedButton signupButton() {
    return ElevatedButton(
      onPressed: signUp,
      child: Text('SignUp'),
    );
  }

  void signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      formKey.currentState!.reset();
      final result = await authService.signUp(email, password, fullname);
      if (result == 'success') {
        Navigator.pushReplacementNamed(context, '/signUp');
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Hata"),
                content: Text(result!),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Geri Don"))
                ],
              );
            });
      }
    }
  }

  TextFormField passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Şifre'),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'bilgileri eksiksiz doldurunuz';
        }
      },
      onSaved: (newValue) {
        password = newValue!;
      },
    );
  }

  SizedBox sizedBox() {
    return SizedBox(
      height: 20,
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Email'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'bilgileri eksiksiz doldurunuz';
        }
      },
      onSaved: (newValue) {
        email = newValue!;
      },
    );
  }
}
