import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/image_picker/image_picker_bloc.dart';
import '../../bloc/image_picker/image_picker_event.dart';

class CustomDropdownButton extends StatefulWidget {
  const CustomDropdownButton({super.key});

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String? _selectedImageOption;
  //Color _hoverColor = Colors.grey[300]!; // Color when hovered

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: DropdownButton<String>(
        value: _selectedImageOption,
        hint: const Text("Select Image",style: TextStyle(color: Colors.white),),
        items:  [
          DropdownMenuItem(
            value: 'Gallery',
            child: Container(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(12),
              //   border: Border.all(
              //     color: Colors.amber,
              //     width: 2,
              //   ),
              //   shape: BoxShape.rectangle,
              // ),

              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: const Row(
                children: [
                  Icon(Icons.photo_library, color: Colors.amber), // Custom icon for gallery
                  SizedBox(width: 8), // Spacing between icon and text
                  Text(
                    'Gallery',
                    style: TextStyle(
                      color: Colors.amber, // Text color
                      fontWeight: FontWeight.bold, // Text style
                    ),
                  ),
                ],
              ),
            ),
          ),
          const DropdownMenuItem(
            value: 'Camera',
            child: Row(
              children: [
                Icon(Icons.camera_alt, color: Colors.amber), // Custom icon for camera
                SizedBox(width: 8), // Spacing between icon and text
                Text(
                  'Camera',
                  style: TextStyle(
                    color: Colors.amber, // Text color
                    fontWeight: FontWeight.bold, // Text style
                  ),
                ),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _selectedImageOption = value;
          });
          if (value == 'Gallery') {
            context
                .read<ImagePickerBloc>()
                .add(GalleryPicker());
          } else if (value == 'Camera') {
            context
                .read<ImagePickerBloc>()
                .add(CameraCapture());
          }

        },
        dropdownColor: Colors.blueGrey,
        iconEnabledColor: Colors.amber, // Color of the dropdown icon when enabled
        iconDisabledColor: Colors.grey, // Color of the dropdown icon when disabled
        iconSize: 35, // Size of the dropdown icon
        underline: Container(
          height: 2,
          color: Colors.amber, // Color of the underline

        ),
        style: const TextStyle(
          color: Colors.white, // Text color for selected item
          fontSize: 16, // Font size
        ),
        // Custom icon for the dropdown
        icon: const Icon(
          Icons.arrow_drop_down_sharp,
          //size: 35,
        ),
      ),
    );
  }
}