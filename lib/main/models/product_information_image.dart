import 'package:image_picker/image_picker.dart';

class ProductInformationImage{
  bool isValid = false;
  XFile image;

  ProductInformationImage({
    required this.isValid,
    required this.image,
  });
}