// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaarta/login_controller.dart';

var sourceList = [];
final googleSignIn = GoogleSignIn();
final auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();
final controller = Get.put(LoginController());

GoogleSignInAccount user = controller.getuser();
var userDatabaseReference = databaseReference.child(user.id);
var articleDatabaseReference =
        databaseReference.child(user.id).child('articles');
var articleSourcesDatabaseReference =
        databaseReference.child(user.id).child('sources');