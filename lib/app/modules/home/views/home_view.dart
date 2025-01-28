import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/controllers/page_handling_controller.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final pageHandlingC = Get.put(PageHandlingController());

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
                String address = user!['address'] != null
                    ? '${user['address']['locality']}, ${user['address']['administrative_area']}, ${user['address']['country']}'
                    : 'Belum ada lokasi.';
                return ListView(
                  padding:
                      EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 40),
                  children: [
                    Card(
                      elevation: 2,
                      color: Color(0xFFEB7777),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Icon(
                                    Icons.co_present_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    'Presence App',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(thickness: 2, color: Colors.white),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                ClipOval(
                                  child: Container(
                                    width: 55,
                                    height: 55,
                                    child: Image.network(
                                      user['image'] ??
                                          'https://ui-avatars.com/api/?name=${user['name']}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 250,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        (user['name'] as String).toUpperCase(),
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        user['identification_number'],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                      // Obx(
                                      //   () => GestureDetector(
                                      //     onTap: () async {
                                      //       if (pageHandlingC.isLoading.isFalse) {
                                      //         await pageHandlingC
                                      //             .updateCurrentUserPosition();
                                      //       }
                                      //     },
                                      //     child: pageHandlingC.isLoading.isFalse
                                      //         ? Text(
                                      //             'update',
                                      //             style: TextStyle(
                                      //                 fontSize: 12,
                                      //                 color: Colors.blue,
                                      //                 fontWeight: FontWeight.w600),
                                      //           )
                                      //         : Flex(
                                      //             direction: Axis.horizontal,
                                      //             crossAxisAlignment:
                                      //                 CrossAxisAlignment.center,
                                      //             children: [
                                      //                 Text(
                                      //                   'update',
                                      //                   style: TextStyle(
                                      //                       color: Colors.blue,
                                      //                       fontSize: 12,
                                      //                       fontWeight:
                                      //                           FontWeight.w600),
                                      //                 ),
                                      //                 SizedBox(
                                      //                   width: 4,
                                      //                 ),
                                      //                 SizedBox(
                                      //                   height: 5,
                                      //                   width: 5,
                                      //                   child:
                                      //                       CircularProgressIndicator(
                                      //                     color: Colors.blue,
                                      //                     strokeWidth: 1,
                                      //                   ),
                                      //                 )
                                      //               ]),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['job'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(user['identification_number'],
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(user['name'],
                              style: TextStyle(
                                fontSize: 18,
                              ))
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: controller.watchingTodayAttendance(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return SizedBox(
                              height: 150,
                              child: Center(
                                child: Text(
                                  'Internal Server Error.',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }

                          Map<String, dynamic>? data = snapshot.data?.data();

                          return Container(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text('Check-in'),
                                    Text(data != null && data['in'] != null
                                        ? DateFormat.Hms().format(
                                            DateTime.parse(
                                                data['in']['timestamp']))
                                        : '-'),
                                  ],
                                ),
                                Container(
                                  height: 20,
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                Column(
                                  children: [
                                    Text('Check-out'),
                                    Text(data != null && data['out'] != null
                                        ? DateFormat.Hms().format(
                                            DateTime.parse(
                                                data['out']['timestamp']))
                                        : '-'),
                                  ],
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[200]),
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Last 5 days',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.MY_ATTENDANCES);
                            },
                            child: Text('See more')),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: controller.watchingLastAttendances(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasData &&
                              snapshot.data?.docs.length != 0) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (ctx, i) {
                                  Map<String, dynamic> attendance =
                                      snapshot.data!.docs[i].data();
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[200],
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed(Routes.ATTENDANCE_DETAIL,
                                              arguments: attendance);
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Check-in',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${DateFormat.yMMMEd().format(DateTime.parse(attendance['date']))}',
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                attendance['in'] != null
                                                    ? '${DateFormat.Hms().format(DateTime.parse(attendance['in']['timestamp']))}'
                                                    : '-',
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Check-out',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                attendance['out'] != null
                                                    ? '${DateFormat.Hms().format(DateTime.parse(attendance['out']['timestamp']))}'
                                                    : '-',
                                              ),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }

                          if (snapshot.hasError || snapshot.data == null) {
                            return SizedBox(
                              height: 150,
                              child: Center(
                                child: Text(
                                  'Internal Server Error.',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }

                          return SizedBox(
                            height: 150,
                            child: Center(
                              child: Text(
                                'No data available.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        })
                  ],
                );
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
          style: TabStyle.fixedCircle,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Attendance'),
            TabItem(icon: Icons.person, title: 'Profile'),
          ],
          initialActiveIndex: pageC.pageIndex.value,
          onTap: (int i) => pageC.changePage(i),
        ));
  }
}
