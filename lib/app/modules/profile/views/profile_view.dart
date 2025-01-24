import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PROFILE'),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.watchingUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                Map<String, dynamic>? user = snapshot.data!.data();
                if (user != null) {
                  return ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Image.network(
                                'https://ui-avatars.com/api/?name=${user['name']}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${user['name']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${user['email']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        onTap: () => Get.toNamed(Routes.UPDATE_PROFILE),
                        leading: Icon(Icons.person),
                        title: Text('Update Profile'),
                      ),
                      ListTile(
                        onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                        leading: Icon(Icons.vpn_key),
                        title: Text('Update Password'),
                      ),
                      if (user['role'] == 'admin')
                        ListTile(
                          onTap: () {
                            Get.toNamed(Routes.ADD_EMPLOYEE);
                          },
                          leading: Icon(Icons.person_add),
                          title: Text('Add Employee'),
                        ),
                      ListTile(
                        onTap: () {
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
                                    onPressed: () => Get.back(),
                                    child: Text('CANCEL'))
                              ]);
                        },
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                      ),
                    ],
                  );
                }
              }
              if (snapshot.hasError || snapshot.data == null) {
                return Center(
                  child: Text(
                    'No data available.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }
              return Center(
                child: Text(
                  'Internal Server Error.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }));
  }
}
