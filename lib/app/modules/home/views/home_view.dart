import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      floatingActionButton: FloatingActionButton(onPressed: () {
        Get.defaultDialog(
            title: 'LOG OUT',
            middleText: 'Are you sure wan\'t to log out?',
            actions: [
              OutlinedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  child: Text('LOGOUT')),
              OutlinedButton(onPressed: () => Get.back(), child: Text('CANCEL'))
            ]);
      }, child: Icon(Icons.logout),),
    );
  }
}
