import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/attendance_detail_controller.dart';

class AttendanceDetailView extends GetView<AttendanceDetailController> {
  const AttendanceDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATTENDANCE DETAIL'),
        centerTitle: true,
      ),
      body: ListView(padding: EdgeInsets.all(20), children: [
        Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '${DateFormat.yMMMMEEEEd().format(DateTime.now())}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'In',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Time: ${DateFormat.jms().format(DateTime.now())}',
                ),
                Text(
                  'Position: -6.2933 , -8.3214',
                ),
                Text(
                  'Status: In range',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Out',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                                Text(
                  'Time: ${DateFormat.jms().format(DateTime.now())}',
                ),
                Text(
                  'Position: -6.2933 , -8.3214',
                ),
                Text(
                  'Status: Out of range',
                ),
              ],
            )),
      ]),
    );
  }
}
