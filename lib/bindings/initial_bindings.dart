import 'package:get/get.dart';

import '../login/datas/local/user_database_data_source_dummy.dart';
import '../login/datas/source/user_database_source.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<UserDatabaseSource>(UserDatabaseSourceDummy());
  }
}
