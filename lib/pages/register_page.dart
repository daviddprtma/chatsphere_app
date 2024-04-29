import 'package:chatsphere_app/providers/authentication_provider.dart';
import 'package:chatsphere_app/services/cloud_storage_service.dart';
import 'package:chatsphere_app/services/database_service.dart';
import 'package:chatsphere_app/services/media_service.dart';
import 'package:chatsphere_app/services/navigation_service.dart';
import 'package:chatsphere_app/widgets/custom_input_field.dart';
import 'package:chatsphere_app/widgets/rounded_button.dart';
import 'package:chatsphere_app/widgets/rounded_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _registerPageState();
  }
}

class _registerPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloud;
  late NavigationService _navigationService;

  final _registerFormKey = GlobalKey<FormState>();

  String? _email;
  String? _password;
  String? _name;
  PlatformFile? _profileImage;

  Widget buildUI() {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: ListView(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _profileImageField(),
                  SizedBox(
                    height: _deviceHeight * 0.05,
                  ),
                  _registerForm(),
                  SizedBox(
                    height: _deviceHeight * 0.05,
                  ),
                  _registerButton(),
                  SizedBox(
                    height: _deviceHeight * 0.02,
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance
            .get<MediaService>()
            .pickImageFromLibrary()
            .then((_file) => {
                  setState(() {
                    _profileImage = _file;
                  })
                });
      },
      child: () {
        if (_profileImage != null) {
          return RoundedImageFile(
              key: UniqueKey(),
              image: _profileImage!,
              size: _deviceHeight * 0.15);
        } else {
          return RoundedImageNetwork(
              key: UniqueKey(),
              imagePath: "https://i.pravatar.cc/300",
              size: _deviceHeight * 0.15);
        }
      }(),
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextInputField(
                onSaved: (_value) {
                  setState(() {
                    _name = _value;
                  });
                },
                regEx: r'.{8,}',
                hintText: "Name",
                obscureText: false),
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
                regEx: r'.{8,}',
                hintText: "Password",
                obscureText: true),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
        name: "Register",
        height: _deviceHeight * 0.065,
        width: _deviceWidth * 0.65,
        onPressed: () async {
          if (_registerFormKey.currentState!.validate() &&
              _profileImage != null) {
            _registerFormKey.currentState!.save();
            String? _uid =
                await _auth.registerUserEmailAndPassword(_email!, _password!);
            String? _imageURL =
                await _cloud.saveUserImageToStorage(_uid!, _profileImage!);
            await _db.createUser(_uid, _email!, _name!, _imageURL!);
             _navigationService.goBack();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloud = GetIt.instance.get<CloudStorageService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    return buildUI();
  }
}
