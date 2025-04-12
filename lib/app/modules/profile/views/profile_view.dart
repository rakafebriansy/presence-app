import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/controllers/page_handling_controller.dart';
import 'package:presence_app/app/helper/custom_styles.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height / 2);
    path.quadraticBezierTo(
        size.width / 2, size.height * 3 / 4, size.width, size.height / 2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});
  final pageC = Get.find<PageHandlingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.watchingUser(),
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
                    children: [
                      Container(
                        height: 300,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipPath(
                                clipper: CurveClipper(),
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/background.png'),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        child: Image.network(
                                          user['image'] ??
                                              'https://ui-avatars.com/api/?name=${user['name']}',
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        (loadingProgress
                                                                .expectedTotalBytes ??
                                                            1)
                                                    : null,
                                                strokeWidth: 2,
                                              ),
                                            );
                                          },
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${user['name']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${user['identification_number']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          elevation: 1,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                  width: 1, color: Colors.grey[200]!)),
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[300]!,
                                          width: 0.5)),
                                ),
                                child: ListTile(
                                  onTap: () =>
                                      Get.toNamed(Routes.UPDATE_PROFILE),
                                  leading: Icon(Icons.person,
                                      color: Color(0xFF7AA0DA)),
                                  title: Text('Update Profile'),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[300]!,
                                          width: 0.5)),
                                ),
                                child: ListTile(
                                  onTap: () =>
                                      Get.toNamed(Routes.UPDATE_PASSWORD),
                                  leading: Icon(Icons.vpn_key,
                                      color: Color(0xFF7AA0DA)),
                                  title: Text('Update Password'),
                                ),
                              ),
                              if (user['role'] == 'admin')
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[300]!,
                                            width: 0.5)),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Get.toNamed(Routes.ADD_EMPLOYEE);
                                    },
                                    leading: Icon(Icons.person_add,
                                        color: Color(0xFF7AA0DA)),
                                    title: Text('Add User'),
                                  ),
                                ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[300]!,
                                          width: 0.5)),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Get.defaultDialog(
                                        titleStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        titlePadding: EdgeInsets.only(
                                            top: 12, left: 12, right: 12),
                                        title: 'LOG OUT',
                                        middleText:
                                            'Are you sure wan\'t to log out?',
                                        actions: [
                                          OutlinedButton(
                                              onPressed: () => Get.back(),
                                              child: Text('CANCEL')),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (controller
                                                  .isLoading.isFalse) {
                                                controller.logout();
                                              }
                                            },
                                            child: Text('LOGOUT'),
                                            style: CustomStyles
                                                .roundedPrimaryButton(),
                                          ),
                                        ]);
                                  },
                                  leading: Icon(
                                    Icons.logout,
                                    color: Color(0xFF7AA0DA),
                                  ),
                                  title: Text('Logout'),
                                ),
                              ),
                            ],
                          ),
                        ),
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
            }),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Color(0xFF7AA0DA),
          style: TabStyle.fixedCircle,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Presence'),
            TabItem(icon: Icons.person, title: 'Profile'),
          ],
          initialActiveIndex: pageC.pageIndex.value,
          onTap: (int i) => pageC.changePage(i),
        ));
  }
}
