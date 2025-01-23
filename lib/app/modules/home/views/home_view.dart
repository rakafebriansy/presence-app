import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(Routes.ADD_EMPLOYEE);
              },
              icon: Icon(Icons.person))
        ],
      ),
      body: const Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () {
            Get.defaultDialog(
                title: 'LOG OUT',
                middleText: 'Are you sure wan\'t to log out?',
                actions: [
                  OutlinedButton(
                      onPressed: () {
                        if (controller.isLoading.isFalse) {
                          controller.logout();
                        }
                      },
                      child: Text('LOGOUT')),
                  OutlinedButton(
                      onPressed: () => Get.back(), child: Text('CANCEL'))
                ]);
          },
          child: controller.isLoading.isTrue
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                )
              : Icon(Icons.logout),
        ),
      ),
    );
  }
}
