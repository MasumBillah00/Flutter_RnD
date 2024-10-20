
import 'package:flutter/material.dart';

import '../constant.dart';

class BottomButton extends StatelessWidget{
  BottomButton({ required this.onTap, required this.buttonTitle});


  final void Function() onTap;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(bottom: 10,),
        height: kbottomContainerHeight,
        color: kbottomContainerColor,
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,

        child: Center(
          child: Text(buttonTitle,style: klargeButtonTextStyle,
          ),
        ),
      ),
    );
  }
}