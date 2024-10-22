import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../ulitis/image_picker_itilis.dart';
import 'image_picker_event.dart';
import 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final ImagePickerUtils imagePickerUtils;

  ImagePickerBloc(this.imagePickerUtils) : super(const ImagePickerState()) {
    on<CameraCapture>(_cameraCapture);
    on<GalleryPicker>(_galleryPicker);
    on<ClearImageEvent>(_clearImage); // Ensure this is registered
  }

  Future<void> _cameraCapture(CameraCapture event, Emitter<ImagePickerState> emit) async {
    XFile? file = await imagePickerUtils.cameraCapture();
    emit(state.copyWith(file: file));
  }

  Future<void> _galleryPicker(GalleryPicker event, Emitter<ImagePickerState> emit) async {
    XFile? file = await imagePickerUtils.pickImageFromGallery();
    emit(state.copyWith(file: file));
  }

  // void _clearImage(ClearImageEvent event, Emitter<ImagePickerState> emit) {
  //   emit(state.copyWith(file: null));
  //   print("Image cleared in state");
  // }
  void _clearImage(ClearImageEvent event, Emitter<ImagePickerState> emit) {
    emit(state.copyWith(file: null)); // Clear the image from the state
    print("Image cleared in state");
  }
}