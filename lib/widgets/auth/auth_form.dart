import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
          String email, String password, String? userName, bool isLoginMode)
      submitAuthForm;
  const AuthForm({Key? key, required this.submitAuthForm}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoginMode = true;
  String? _userEmail;
  String? _userUserName;
  String? _userPassword;
  File? storedImage;

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    widget.submitAuthForm(
        _userEmail!.trim(), _userPassword!.trim(), _userUserName, _isLoginMode);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoginMode ? const SizedBox() : const UserImagePicker(),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email field cannot be empty";
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return "Please enter a valid email!";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: "Email Address"),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  _isLoginMode
                      ? const SizedBox()
                      : TextFormField(
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return "Username must be at least 4 characters";
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: "Username"),
                          onSaved: (value) {
                            _userUserName = value;
                          },
                        ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return "Password must be at least 7 characters";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _trySubmit,
                    child: Text(_isLoginMode ? "Login" : "Sign Up"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoginMode = !_isLoginMode;
                      });
                    },
                    child: Text(_isLoginMode
                        ? "Create New Account"
                        : "Login to an existing account"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
