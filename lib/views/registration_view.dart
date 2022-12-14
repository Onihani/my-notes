// dart
import 'dart:developer' as devtools show log;
// marterial ui
import 'package:flutter/material.dart';
// firebase auth
import 'package:firebase_auth/firebase_auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _handleRegistrationBtnPress() async {
    // get the user email ans password from their respective inputs
    final email = _email.text;
    final password = _password.text;

    try {
      // create user on firebase
      final createdUserCredentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // print user info
      devtools.log(createdUserCredentials.toString());
    } on FirebaseAuthException catch (firebaseAuthError) {
      switch (firebaseAuthError.code) {
        case 'weak-password':
          devtools.log(
              "Password should be at least 8 characters long.\nPassword should have at least one symbol or number");
          break;
        case 'email-already-in-use':
          devtools.log(
              "There is an existing account associated with this email. Please login instead.");
          break;
        case 'invalid-email':
          devtools.log('Please enter a valid email address');
          break;
        default:
          devtools.log("An error occured while registering");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: _handleRegistrationBtnPress,
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login/',
                (route) => false,
              );
            },
            child: const Text('Already having an account? Login here!'),
          )
        ],
      ),
    );
  }
}
