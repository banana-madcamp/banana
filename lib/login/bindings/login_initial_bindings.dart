import 'package:banana/login/datas/local/user_database_data_source_dummy.dart';
import 'package:banana/login/datas/source/user_database_source.dart';
import 'package:get/get.dart';

class LoginInitialBindings implements Bindings{
  @override
  void dependencies() {
    Get.put<UserDatabaseSource>(UserDatabaseSourceDummy());
  }
}