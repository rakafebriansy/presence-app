import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class PageHandlingController extends GetxController {
  RxInt pageIndex = 0.obs;

  void changePage(int i) async {
    // pageIndex.value = i;
    switch (i) {
      case 1:
        Get.offAllNamed(Routes.PROFILE);
        break;
      case 2:
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
    }
  }
}
