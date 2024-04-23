import 'package:chatsphere_app/providers/authentication_provider.dart';
import 'package:chatsphere_app/services/navigation_service.dart';
import 'package:chatsphere_app/widgets/custom_input_field.dart';
import 'package:chatsphere_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  String? _email;
  String? _password;
  late AuthenticationProvider _authenticationProvider;
  late NavigationService _navigationService;

  final _loginFormKey = GlobalKey<FormState>();

  Widget _buildUI() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pageTitle(),
            SizedBox(
              height: _deviceHeight * 0.04,
            ),
            _loginForm(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            _loginButton(),
            _registerAccount()
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Container(
        height: _deviceHeight * 0.10,
        child: Text(
          'ChatSphere',
          style: TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.w600),
        ));
  }

  Widget _loginForm() {
    return Container(
      height: _deviceHeight * 0.18,
      child: Form(
          key: _loginFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextInputField(
                    onSaved: (_value) {
                      setState(() {
                        _email = _value;
                      });
                    },
                    regEx:
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    hintText: "Email",
                    obscureText: false),
                CustomTextInputField(
                  onSaved: (_value) {
                    setState(() {
                      _password = _value;
                    });
                  },
                  regEx: r".{8,}",
                  hintText: "Password",
                  obscureText: true,
                )
              ],
            ),
          )),
    );
  }

  Widget _loginButton() {
    return RoundedButton(
        name: "Login",
        height: _deviceHeight * 0.065,
        width: _deviceWidth * 0.65,
        onPressed: () {
          if (_loginFormKey.currentState!.validate()) {            
            _loginFormKey.currentState!.save();
            _authenticationProvider.loginUsingEmailAndPassword(_email!, _password!);
          }
        });
  }

  Widget _registerAccount() {
    return GestureDetector(
        onTap: () {
          // print("clicked!");
        },
        child: Container(
          child: Text(
            'Don\'t have an account?',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    _navigationService = GetIt.instance.get<NavigationService>();
    return _buildUI();
  }
}
