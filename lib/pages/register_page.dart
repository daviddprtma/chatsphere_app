import 'package:chatsphere_app/services/media_service.dart';
import 'package:chatsphere_app/widgets/rounded_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _registerPageState();
  }
}

class _registerPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;

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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_profileImageField()],
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }
}
