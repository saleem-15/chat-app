import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../api/firebase_api.dart';
import '../helpers/user_image_picker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File? image,
    bool isLogin,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        isLoading = true;
      });

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final imageRef = FirebaseStorage.instance.ref().child('user_image').child('${authResult.user!.uid}.jpg');

        await imageRef.putFile(image!).whenComplete(() => null);

        final imageUrl = await imageRef.getDownloadURL();

        await FirebaseApi.addNewUser(username, authResult.user!.uid, email, imageUrl);
      }
    } on FirebaseAuthException catch (error) {
      String msg;
      setState(() {
        isLoading = false;
      });
      log(error.code);

      switch (error.code) {
        case 'email-already-in-use':
          msg = 'The email is already in use';
          break;
        case 'wrong-password':
          msg = 'wrong password';
          break;

        case 'user-not-found':
          msg = 'There is no user with this email';
          break;

        default:
          msg = error.code;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 7),
        ),
      );
    }on PlatformException catch (error) {
      var msg = 'An error occured, please check your credentials!';
      setState(() {
        isLoading = false;
      });

      if (error.message != null) {
        msg = error.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.purple,
                Colors.red,
              ],
            ),
          ),
        ),
        AuthForm(_submitAuthForm, isLoading)
      ]),
    );
  }
}

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {super.key});

  final bool isLoading;

  final void Function(
    String email,
    String password,
    String userName,
    File? image,
    bool isLogin,
  ) submitFn;
  // the name of the function is "submitFn"

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  double height = 0;
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    // this line unfocus whatever the widget that has focus
    // we use it to close the keyboard if it was open
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      // if the user is new and didnt pick an image
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please pick an image'),
        ),
      );

      return;
    }

    if (isValid!) {
      //i think save() calls "onSave" methods for all text fields
      _formKey.currentState!.save();

      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  UserImagePicker(
                    imagePickFn: _pickedImage,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null) return null;

                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enteravalid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                  ),
                  AnimatedContainer(
                    height: height,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    child: TextFormField(
                      validator: (value) {
                        if (_isLogin) return null;

                        if (value == null) return null;

                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (newValue) {
                        _userName = newValue!;
                      },
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null) return null;

                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least7characters long.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (newValue) {
                      _userPassword = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  TextButton(
                    child: Text(_isLogin ? 'Create new account' : 'I already have an account'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        if (!_isLogin) {
                          height = 60;
                        } else {
                          height = 0;
                        }
                      });
                    },
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
