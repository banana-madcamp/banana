import 'package:banana/login/datas/remote/user_database_data_source_impl.dart';
import 'package:banana/main/datas/local/database_data_source_dummy.dart';
import 'package:banana/main/datas/remote/database_source_impl.dart';
import 'package:banana/main/datas/source/database_source.dart';
import 'package:get/get.dart';

import '../login/datas/source/user_database_source.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<UserDatabaseSource>(UserDatabaseDataSourceImpl());
    Get.put<DatabaseSource>(DatabaseSourceImpl());
  }
}
