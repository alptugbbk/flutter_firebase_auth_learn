import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_connection/services/auth_service.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                emailTextField(),
                sizedBox(),
                passwordTextField(),
                sizedBox(),
                loginButton(),
                registerButton(),
                sizedBox(),
                anonimButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton anonimButton() {
    return ElevatedButton(
      onPressed: () async {
        final result = await authService.signInAnonymous();
        if (result != null) {
          Navigator.pushNamed(context, '/homePage');
        } else {
          print('hata');
        }
      },
      child: Text('Misafir'),
    );
  }

  TextButton registerButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/signUp');
      },
      child: Text('SignUp'),
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
      onPressed: signIn,
      child: Text('Login'),
    );
  }

  void signIn() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final result = await authService.signIn(email, password);
      if (result == 'success') {
        Navigator.pushNamed(context, '/homePage');
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
