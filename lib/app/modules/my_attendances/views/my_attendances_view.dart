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
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextField(
                decoration: InputDecoration(labelText: 'Search..', border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: 10,
                itemBuilder: (ctx, i) => Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.ATTENDANCE_DETAIL);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'In',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${DateFormat.yMMMEd().format(DateTime.now())}',
                                ),
                              ],
                            ),
                            Text(
                              '${DateFormat.jms().format(DateTime.now())}',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Out',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${DateFormat.jms().format(DateTime.now())}',
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
