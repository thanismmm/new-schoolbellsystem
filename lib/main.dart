import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_bell_system/new_test/schedule_provider.dart';
import 'package:school_bell_system/page/new_login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBZc24kMMnjmseB16AkERUJyri2qjkgm8o",
      appId: "1:540039261850:android:6d855dc003336d22c9b923",
      messagingSenderId: "540039261850",
      projectId: "schoolbell-1145",
      databaseURL: "https://schoolbell-1145-default-rtdb.asia-southeast1.firebasedatabase.app",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScheduleProvider(),
      child: MaterialApp(
        title: 'School Bell Schedule',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
        // Add any additional async operations here
        future: Future.delayed(const Duration(seconds: 2)), // Simulate loading
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
              return LoginPage();
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      ),
    );
  }
}