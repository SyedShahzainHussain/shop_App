import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_application_1/Models/https_exception.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:provider/provider.dart";

import "../Provider/Auth.dart";

enum AuthMode { login, signUp }

class AuthScreen extends StatelessWidget {
  static const routeName = "/Auth";
  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                      Color.fromRGBO(215, 188, 117, 1).withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1])),
          ),
          SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // vertical

                  crossAxisAlignment: CrossAxisAlignment.center, // horizontal
                  children: [
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 94.0),
                        transform: Matrix4.rotationZ(-8 * pi / 100)
                          ..translate(-10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.deepOrange.shade900,
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.black26,
                                  offset: Offset(0, 2))
                            ]),
                        child: const Text(
                          'MyShop',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Flexible(
                      child: AuthCard(),
                      flex: deviceSize.width > 700 ? 2 : 1,
                    )
                  ]),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _form = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.login;
  Map<String, dynamic> _authData = {
    "email": "",
    "password": "",
  };

  bool _isLodaing = false;
  final _passwordController = TextEditingController();

  void _showDialogError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("An Error Occured"),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OKAY"))
          ],
        );
      },
    );
  }

  void _submitData() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLodaing = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false)
            .LogIn(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .SignUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = "Authenticated Failed";
      if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Your password is invalid.Please enter correct password";
      } else if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "this email is already in use";
      }
      _showDialogError(errorMessage);
    } catch (error) {
      var errorMesages = "Could not authenticated you. please try again later";
      _showDialogError(errorMesages);
    }

    setState(() {
      _isLodaing = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: SingleChildScrollView(
        child: Container(
          height: _authMode == AuthMode.signUp ? 330 : 280,
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.signUp ? 330 : 280),
          width: deviceSize.width * 0.85,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _form,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid Email';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _authData['email'] = newValue;
                  },
                ),
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is to short';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _authData['password'] = newValue;
                  },
                ),
              ),
              if (_authMode == AuthMode.signUp)
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Confirm Password"),
                    enabled: _authMode == AuthMode.signUp,
                    obscureText: true,
                    validator: _authMode == AuthMode.signUp
                        ? (value) {
                            if (value != _passwordController.text) {
                              return "Passwords do not match";
                            }
                          }
                        : null,
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              if (_isLodaing)
                SpinKitFadingCircle(
                  color: Colors.yellow,
                )
              else
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: _submitData,
                    child: Text(
                        _authMode == AuthMode.login ? 'LOGIN' : "SIGN UP")),
              TextButton(
                style: ElevatedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 30.0),
                ),
                onPressed: _switchAuthMode,
                child: Text(
                    '${_authMode == AuthMode.login ? "SIGN UP" : "LOGIN"}'),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
