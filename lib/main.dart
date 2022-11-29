// marterial ui
import 'package:flutter/material.dart';
// firebase core
import 'package:firebase_core/firebase_core.dart';
// firebase auth
import 'package:firebase_auth/firebase_auth.dart';
// firebase options
import 'firebase_options.dart';

/* Views */
// Login View
import 'package:mynotes/views/login_view.dart';
// Registration View
import 'package:mynotes/views/registration_view.dart';
// Verify Email View
import 'package:mynotes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'My Notes',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // initialize firebase
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              final userEmailVerified = user?.emailVerified ?? false;

              if (userEmailVerified) {
                print('Email is virified');
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

            return const Text('Done');
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
