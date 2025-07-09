import 'package:banana/login/datas/remote/user_database_data_source_impl.dart';
import 'package:banana/main/datas/remote/database_source_impl.dart';
import 'package:banana/main/datas/source/database_source.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:logger/logger.dart';

import '../login/datas/source/user_database_source.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<UserDatabaseSource>(UserDatabaseDataSourceImpl());
    Get.put<DatabaseSource>(DatabaseSourceImpl());
    Get.put<Logger>(Logger(), tag: 'MainLogger');
    Get.put<ImageLabeler>(
      ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5)),
    );
    Get.put<List<String>>([], tag: 'SelectedTags');
  }
}
