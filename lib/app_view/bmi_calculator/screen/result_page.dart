
import 'package:flutter/material.dart';

import '../component/bottom_button.dart';
import '../component/reusable_card.dart';
import '../constant.dart';

class ResultPage extends StatelessWidget {
  ResultPage({
    required this.interpretation,
    required this.bmiResult,
    required this.resultText
  });


  final String bmiResult;
  final String resultText;
  final String interpretation;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFEB1555),
            centerTitle: true,
            title:const Text('BMI Calculator'),

          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(15),
                child: const Center(
                  child: Text(
                    'Your result',
                    style: kresultTitleTextStyle,

                  ),
                ),
              ),),
              Expanded(
                flex: 5,
                child: ReusableCard(
                  colour: kactiveCardColor,
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(resultText.toUpperCase(),
                        style:kresultTextStyle ,),
                      Text(bmiResult,style: kBMITextStyle,),
                      Text(interpretation,
                        style: kbodyTextStyle,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),

                ),),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0,left: 8.0,right: 8.0),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black54,
                  child: BottomButton(
                    buttonTitle: 'Re-Calculate',
                    onTap:(){
                      Navigator.pop(context);

                    },),
                ),
              ),
            ],
          )
      ),
    );
  }
}
