// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_flicks/constans.dart';
import 'package:quick_flicks/models/user.dart' as model;
import 'package:quick_flicks/views/screens/auth/login_screen.dart';
import 'package:quick_flicks/views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;
  late Rx<File?> _pickedImage = Rx<File?>(null); // Observable for the picked image

  File? get ProfilePhoto => _pickedImage.value; // Getter for the profile photo
  User get user => _user.value!; // Getter for the current user

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, setInitialScreen); // Set initial screen based on auth state
  }

  // Set the initial screen based on whether the user is logged in or not
  void setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  // Function to pick an image from the gallery
  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture', 'You have successfully selected your profile picture!');
      _pickedImage.value = File(pickedImage.path); // Update the observable with the selected image
    }
  }

  // Function to upload the image to Firebase Storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child("ProfilePics")
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // Function to register a new user
  void registerUser(String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && image != null) {
        // Create user in Firebase Auth
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Upload the profile photo to Firebase Storage
        String downloadUrl = await _uploadToStorage(image);

        // Create a user model
        model.User user = model.User(
          name: username,
          email: email,
          uid: cred.user!.uid,
          profilePhoto: downloadUrl,
        );

        // Save the user to Firestore
        await firestore.collection("users").doc(cred.user!.uid).set(user.toJson());

      } else {
        Get.snackbar("Error Creating Account", "Please enter all the fields");
      }
    } catch (e) {
      Get.snackbar("Error Creating Account", e.toString());
    }
  }

  // Function to log in the user
  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        print("Login successful");
      } else {
        Get.snackbar("Error Logging in", "Please enter all the fields");
      }
    } catch (e) {
      Get.snackbar("Error Logging in", e.toString());
    }
  }

  // Function to sign out the user
  void signOut() async {
    await firebaseAuth.signOut();
  }
}
