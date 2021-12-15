
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaarta/home_page.dart';

Future<void> main() async {
  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
 
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "API_KEY",
        authDomain: "vaarta-b66fe.firebaseapp.com",
        databaseURL: "https://vaarta-b66fe-default-rtdb.firebaseio.com",
        projectId: "vaarta-b66fe",
        storageBucket: "vaarta-b66fe.appspot.com",
        messagingSenderId: "434349618389",
        appId: "1:434349618389:web:413b21260b20ca6786de5c"
    ),
  );}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
      primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
