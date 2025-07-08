import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class InformationValidator {
  ImageLabeler get imageLabeler =>
      ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5));

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title cannot be empty';
    }
    if (value.length < 3) {
      return 'Title must be at least 3 characters long';
    }
    return null;
  }

  static String? validateSubtitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Subtitle cannot be empty';
    }
    if (value.length < 3) {
      return 'Subtitle must be at least 3 characters long';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    return null;
  }

  Future<List<List<String>>> validateTags(List<InputImage> inputImages) async {
    List<List<String>> tags = [];

    for (InputImage inputImage in inputImages) {
      final List<ImageLabel> labels = await imageLabeler.processImage(
        inputImage,
      );

      List<String> temp = [];
      for (ImageLabel label in labels) {
        if (label.confidence >= 0.5) {
          temp.add(label.label);
        }
      }
      tags.add(temp);
    }
    return tags;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price cannot be empty';
    }
    final double? price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Price must be a positive number';
    }
    return null;
  }

  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location cannot be empty';
    }
    if (value.length < 3) {
      return 'Location must be at least 3 characters long';
    }
    return null;
  }
}
