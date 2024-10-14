
// import 'dart:io';
//
// import 'package:flutter/material.dart';
//
// import '../../model/todo_task_model.dart';
//
// class ImageDesign extends StatelessWidget {
//   final String? imagePath;
//   final File? imageFile;
//
//   const ImageDesign({
//     super.key,
//     this.imagePath,
//     this.imageFile,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 150,
//       width: 140,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.blue,
//           width: 2,
//         ),
//         shape: BoxShape.rectangle,
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: imageFile != null
//             ? Image.file(
//           imageFile!,
//           fit: BoxFit.cover,
//         )
//             : imagePath != null
//             ? Image.file(
//           File(imagePath!),
//           fit: BoxFit.cover,
//         )
//             : const Icon(Icons.image, size: 50, color: Colors.grey),
//       ),
//     );
//   }
// }
//
// class Image_Design extends StatelessWidget {
//   const Image_Design({
//     super.key,
//     required this.item,
//   });
//
//   final TodoTaskModel item;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       height: 150,
//       width: 140,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.blue,
//           width: 2,
//         ),
//         shape: BoxShape.rectangle,
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Image.file(
//           File(item.image),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
//
import 'dart:io';

import 'package:flutter/material.dart';

import '../../model/todo_task_model.dart';

class ImageDesign extends StatelessWidget {
  final String? imagePath;
  final File? imageFile;
  final TodoTaskModel? item;

  const ImageDesign({
    super.key,
    this.imagePath,
    this.imageFile,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    // Determine which image source to use
    final file = imageFile ?? (item != null ? File(item!.image) : null);
    final path = imagePath ?? (item?.image);

    return Container(
      height: 150,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue,
          width: 2,
        ),
        shape: BoxShape.rectangle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: file != null
            ? Image.file(
          file,
          fit: BoxFit.cover,
        )
            : path != null
            ? Image.file(
          File(path),
          fit: BoxFit.cover,
        )
            : const Icon(Icons.image, size: 50, color: Colors.grey),
      ),
    );
  }
}
