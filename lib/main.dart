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

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'My Notes',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: FutureBuilder(
        // initialize firebase
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              final userEmailVerified = user?.emailVerified ?? false;

              if (userEmailVerified) {
                print('You are verified user');
              } else {
                print('You need to verify your email first');
              }
              return const Text('Done');
            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}
