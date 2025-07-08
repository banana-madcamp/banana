import 'package:banana/login/datas/local/user_database_data_source_dummy.dart';
import 'package:banana/login/datas/remote/user_database_data_source_impl.dart';
import 'package:banana/login/datas/source/user_database_source.dart';
import 'package:get/get.dart';

import '../../main/datas/local/database_data_source_dummy.dart';
import '../../main/datas/source/database_source.dart';

class LoginInitialBindings implements Bindings{
  @override
  void dependencies() {
    Get.put<UserDatabaseSource>(UserDatabaseDataSourceImpl());
    Get.put<DatabaseSource>(DatabaseSourceDummy());
  }
}