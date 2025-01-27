import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/my_attendances_controller.dart';

class MyAttendancesView extends GetView<MyAttendancesController> {
  const MyAttendancesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MY ATTENDANCES'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Search..',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: controller.getAttendances(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasData && snapshot.data?.docs.length != 0) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (ctx, i) {
                            Map<String, dynamic> attendance =
                                snapshot.data!.docs[i].data();
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Check-in',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
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
                                              fontWeight: FontWeight.bold),
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

                    return SizedBox(
                      height: 150,
                      child: Center(
                        child: Text(
                          'No data available.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
