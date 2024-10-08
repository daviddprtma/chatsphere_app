import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  String _barTitle;
  Widget? primaryAction;
  Widget? secondaryAction;
  Widget? thirdAction;
  Widget? fourthAction;
  double? fontSize;

  late double _deviceHeight;
  late double _deviceWidth;

  TopBar(this._barTitle,
      {this.primaryAction, this.secondaryAction, this.thirdAction, this.fourthAction, this.fontSize = 35});

  @override
  Widget _buildUI() {
    return Container(
      height: _deviceHeight * 0.10,
      width: _deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (secondaryAction != null) secondaryAction!,
          _titleBar(),
          if (thirdAction != null) thirdAction!,
          if (primaryAction != null) primaryAction!
        ],
      ),
    );
  }

  Widget _titleBar(){
    return Text(
      _barTitle,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize ,
        fontWeight: FontWeight.w700,
      ),
    );
  
  }

  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }
}
