import 'package:ftc_application/blocs/loginBloc/login.dart';
import 'package:ftc_application/config/ui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FocusNode _numberFocus  = FocusNode();
  final FocusNode _passFocus = FocusNode();
  bool _showPassword = false;
  bool _memberLoginIn = false;

  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _memberLoginIn = false;
            });
          } else if (state is LoginFinished) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          }
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            key: _scaffoldKey,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    config.Colors().accentColor(.8),
                    config.Colors().mainColor(1),
                  ],
                ),
              ),
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: 30),
                      Image.asset(
                        'assets/images/logoFTC.png',
                        width: 240,
                        height: 240,
                      ),
                      Text('تسجيل الدخول',
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .merge(TextStyle(color: Colors.white))),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          controller: _usernameController,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: _numberFocus,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(context, _numberFocus, _passFocus);
                          },
                          decoration: InputDecoration(
                            labelText: 'الرقم الجامعي',
                            labelStyle: Theme.of(context).textTheme.body1.merge(
                                  TextStyle(color: Colors.white),
                                ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            prefixIcon: Icon(
                              UiIcons.envelope,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          controller: _passwordController,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.text,
                          obscureText: !_showPassword,
                          textInputAction: TextInputAction.done,
                          focusNode: _passFocus,
                          decoration: new InputDecoration(
                            labelText: 'كلمة المرور',
                            labelStyle: Theme.of(context).textTheme.body1.merge(
                                  TextStyle(color: Colors.white),
                                ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            prefixIcon: Icon(
                              UiIcons.padlock_1,
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              color: Colors.white.withOpacity(0.4),
                              icon: Icon(_showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 45),
                      _memberLoginIn
                          ? CircularProgressIndicator()
                          : RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 70),
                              onPressed: () => _onLoginButtonPressed(),
                              child: Text('تسجيل الدخول',
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .merge(TextStyle(color: Colors.white))),
                              color: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  _onLoginButtonPressed() {
    BlocProvider.of<LoginBloc>(context).add(
      LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
    setState(() {
      _memberLoginIn = true;
    });
  }
}
