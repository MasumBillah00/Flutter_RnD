import 'package:flutter/material.dart';
import '../constant.dart';

class IconContent extends StatelessWidget {
  IconContent({this.icon, this.lable});
  final IconData? icon;
  final String? lable;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 80.0,
          color: Colors.white,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          lable??'',
          style: klabelTextStyle,
        ),
      ],
    );
  }
}
