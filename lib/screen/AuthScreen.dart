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

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.login;
  Map<String, dynamic> _authData = {
    "email": "",
    "password": "",
  };

  bool _isLodaing = false;
  final _passwordController = TextEditingController();
  AnimationController? _controller;
  // Animation<Size>? _heightAnimation;
  Animation<double>? _opacity;
  Animation<Offset>? _offset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // _heightAnimation = Tween(
    //         begin: Size(double.infinity, 280), end: Size(double.infinity, 330))
    //     .animate(
    //         CurvedAnimation(parent: _controller!, curve: Curves.easeInOutBack));
    _opacity = Tween(begin: 0.0, end: 1.1).animate(_controller!);
    _offset = Tween<Offset>(begin: Offset(0.0, -1.5), end: Offset(0.0, 0.0))
        .animate(_controller!);

    // _heightAnimation!.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller!.dispose();
  }

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
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller!.reverse();
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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutBack,
        height: _authMode == AuthMode.signUp ? 330 : 270,
        // height: _heightAnimation!.value.height,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signUp ? 330 : 270),
        // minHeight: _heightAnimation!.value.height),
        width: deviceSize.width * 0.85,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
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
              TextFormField(
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
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.signUp ? 60 : 0,
                  maxHeight: _authMode == AuthMode.signUp ? 120 : 0,
                ),
                child: FadeTransition(
                  opacity: _opacity!,
                  child: SlideTransition(
                    position: _offset!,
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
              const SizedBox(
                height: 10,
              ),
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
