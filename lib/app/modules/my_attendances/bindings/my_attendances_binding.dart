import 'package:get/get.dart';

import '../controllers/my_attendances_controller.dart';

class MyAttendancesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyAttendancesController>(
      () => MyAttendancesController(),
    );
  }
}
