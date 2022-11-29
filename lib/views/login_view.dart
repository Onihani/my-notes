// marterial ui
import 'package:flutter/material.dart';
// firebase auth
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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

  void _handleLoginBtnPress() async {
    // get the user email ans password from their respective inputs
    final email = _email.text;
    final password = _password.text;

    try {
      // create user on firebase
      final loggedUserCredentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // print user info
      print(loggedUserCredentials);
    } on FirebaseAuthException catch (firebaseAuthError) {
      switch (firebaseAuthError.code) {
        case 'user-not-found':
          print("Invalid email or password");
          break;
        case 'wrong-password':
          print("Invalid credentials provided");
          break;
        default:
          print("An error occured while authenticating");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
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
            onPressed: _handleLoginBtnPress,
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/register/', (route) => false);
            },
            child: const Text('Not registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}
