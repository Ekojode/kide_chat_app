import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  void _submitAuthForm(String email, String password, String? userName,
      bool isLoginMode, File? userProfilePic) async {
    UserCredential userCredential1;
    setState(() {
      _isLoading = true;
    });
    try {
      if (isLoginMode) {
        userCredential1 = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential1 = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child("${userCredential1.user!.uid}.jpg");

        ref.putFile(userProfilePic!).whenComplete(
          () async {
            final userImage = await ref.getDownloadURL();
            await FirebaseFirestore.instance
                .collection("users")
                .doc(userCredential1.user!.uid)
                .set(
              {
                "username": userName,
                "email": email,
                "userimage": userImage,
              },
            );
          },
        );
      }
    } on PlatformException catch (error) {
      String errorMessage = "An error occurred, Please check login credentials";
      if (error.message != null) {
        errorMessage = error.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Text(errorMessage),
        ),
      );
      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (err) {
      // String errorMessage = "An error occurred, Please check login credentials";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Text(err.toString()),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : AuthForm(submitAuthForm: _submitAuthForm),
    );
  }
}
