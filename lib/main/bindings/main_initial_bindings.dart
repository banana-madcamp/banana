import 'package:banana/main/datas/local/database_data_source_dummy.dart';
import 'package:banana/main/datas/source/database_source.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class MainInitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<DatabaseSource>(DatabaseSourceDummy());
    Get.put<Logger>(Logger(), tag: 'MainLogger');
  }
}