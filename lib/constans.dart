import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quick_flicks/controllers/auth_controller.dart';
import 'package:quick_flicks/views/screens/add_video_screen.dart';
import 'package:quick_flicks/views/screens/profile_screen.dart';
import 'package:quick_flicks/views/screens/search_screen.dart';
import 'package:quick_flicks/views/screens/video_screen.dart';

List pages = [
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  const Text("message Screen"),
  ProfileScreen(uid: authController.user.uid),
];

//color
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

//firebase constant

var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

//controler
var authController = AuthController.instance;
