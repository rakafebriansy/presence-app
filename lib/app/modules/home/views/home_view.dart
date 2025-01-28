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

  String formatDuration(Duration duration) {
    int hours = duration.inHours.abs();
    int minutes = duration.inMinutes.abs().remainder(60);
    int seconds = duration.inSeconds.abs().remainder(60);

    bool negative = duration.inSeconds.isNegative;

    List<String> parts = [];
    if (hours > 0) parts.add('$hours jam');
    if (minutes > 0) parts.add('$minutes menit');
    if (seconds > 0) parts.add('$seconds detik');

    if (hours == 0 && minutes == 0 && seconds == 0) {
      return 'On Time';
    }
    return '${hours > 0 ? '${hours} ${hours > 1 ? 'hours' : 'hour'} ' : ''}${minutes > 0 ? '${minutes} ${minutes > 1 ? 'minutes' : 'minute'} ' : ''}${seconds > 0 ? '${seconds} ${seconds > 1 ? 'seconds' : 'second'} ' : ''}${negative ? 'earlier' : 'late'}';
  }

  Text getDifference(Map<String, dynamic> attendance, String key) {
    final timestamp = attendance[key]?['timestamp'];
    final scheduleTime = pageHandlingC.schedule?[key];
    final difference = (timestamp != null && scheduleTime != null)
        ? DateTime.parse(timestamp).difference(scheduleTime)
        : null;

    if (difference == null) {
      return Text(
        '-',
        style: TextStyle(fontSize: 12),
      );
    }

    final text = formatDuration(difference);

    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        // color: text == 'On Time'
        //     ? Colors.black
        //     : difference.isNegative
        //         ? (key == 'in' ? Colors.green : Colors.red)
        //         : (key == 'in' ? Colors.red : Colors.green)
      ),
    );
  }

  final pageC = Get.find<PageHandlingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: controller.getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData && snapshot.data!.data() != null) {
                Map<String, dynamic>? user = snapshot.data!.data();
                return ListView(
                  padding:
                      EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 40),
                  children: [
                    Card(
                      elevation: 1,
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
                                      user!['image'] ??
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

                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 1, color: Colors.grey[200]!)),
                            elevation: 1,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Obx(() {
                                    if (controller.timeString.value == '') {
                                      return SizedBox(
                                        height: 50,
                                      );
                                    }
                                    return Container(
                                      height: 50,
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Flex(
                                              direction: Axis.horizontal,
                                              children: [
                                                Text(
                                                  '${controller.timeString.value}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 20),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Flex(
                                              direction: Axis.horizontal,
                                              children: [
                                                Icon(
                                                  Icons.location_on_sharp,
                                                  size: 16,
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                StreamBuilder<String>(
                                                    stream: pageHandlingC
                                                        .updateCurrentUserPosition(),
                                                    builder:
                                                        (context, snapshot) {
                                                      String address = snapshot
                                                              .data ??
                                                          'Belum menemukan lokasi';
                                                      return Text(
                                                        address,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12),
                                                      );
                                                    })
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey[300]!)),
                                            child: Column(
                                              children: [
                                                Text('CHECK-IN'),
                                                Container(
                                                  height: 30,
                                                  child: Center(
                                                    child: Text(
                                                      data != null &&
                                                              data['in'] != null
                                                          ? DateFormat.Hms()
                                                              .format(DateTime
                                                                  .parse(data[
                                                                          'in'][
                                                                      'timestamp']))
                                                          : '-',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey[300]!)),
                                            child: Column(
                                              children: [
                                                Text('CHECK-OUT'),
                                                Container(
                                                  height: 30,
                                                  child: Center(
                                                    child: Text(
                                                      data != null &&
                                                              data['out'] !=
                                                                  null
                                                          ? DateFormat.Hms()
                                                              .format(DateTime
                                                                  .parse(data[
                                                                          'out']
                                                                      [
                                                                      'timestamp']))
                                                          : '-',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Last 5 days',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.MY_ATTENDANCES);
                            },
                            child: Text(
                              'See more',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue),
                            )),
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
                            return GetBuilder<PageHandlingController>(
                                builder: (context) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (ctx, i) {
                                    Map<String, dynamic> attendance =
                                        snapshot.data!.docs[i].data();
                                    final Text checkInDifference =
                                        getDifference(attendance, 'in');
                                    final Text checkOutDifference =
                                        getDifference(attendance, 'out');
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colors.white,
                                        child: InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                                Routes.ATTENDANCE_DETAIL,
                                                arguments: attendance);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey[300]!)),
                                            padding: EdgeInsets.all(20),
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${DateFormat.yMMMEd().format(DateTime.parse(attendance['date']))}',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Flex(
                                                  direction: Axis.horizontal,
                                                  children: [
                                                    Icon(
                                                      Icons.login,
                                                      size: 14,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    checkInDifference
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Flex(
                                                  direction: Axis.horizontal,
                                                  children: [
                                                    Icon(
                                                      Icons.logout,
                                                      size: 14,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    checkOutDifference,
                                                  ],
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
