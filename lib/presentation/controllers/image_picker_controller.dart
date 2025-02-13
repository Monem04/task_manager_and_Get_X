import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController{
  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  Future<bool> imagePicker()async {
    bool isSuccess = false;
    ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      isSuccess = true;
      _pickedImage = image;
    }
    update();
    return isSuccess;
  }
}