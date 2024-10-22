
import 'package:flutter/material.dart';

// class Card_Widget extends StatelessWidget {
//   const Card_Widget({
//     super.key,
//     required this.item,
//     //required this.title,
//   });
//
//
//
//   final TodoTaskModel item;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.grey[800],
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: ListTile(
//         title: Text_Widget(item: item),
//       ),
//     );
//   }
// }

class CustomText extends StatelessWidget {
  final String text;
  final bool isSelected;

  const CustomText({
    super.key,
    required this.text,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: isSelected ? Colors.red : Colors.amber.shade800,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}


class DCustomText extends StatefulWidget {
  final String text;
  final bool isSelected;
  final bool showSeeMore; // New parameter

  const DCustomText({
    super.key,
    required this.text,
    this.isSelected = false,
    this.showSeeMore = true, // Default value to true
  });

  @override
  _DCustomTextState createState() => _DCustomTextState();
}

class _DCustomTextState extends State<DCustomText> {
  bool _isExpanded = false;

  String _formatText(List<String> words) {
    String formattedText = '';
    for (int i = 0; i < words.length; i++) {
      if (i > 0 && i % 3 == 0) {
        formattedText += '\n';
      }
      formattedText += words[i] + ' ';
    }
    return formattedText.trim();
  }

  @override
  Widget build(BuildContext context) {
    List<String> words = widget.text.split(' ');
    String displayText = _isExpanded ? widget.text : _formatText(words.take(3).toList());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayText,
          style: TextStyle(
            color: widget.isSelected ? Colors.amber.shade100 : Colors.white70,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.showSeeMore && words.length > 3)
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'See less' : 'See more',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
      ],
    );
  }
}
