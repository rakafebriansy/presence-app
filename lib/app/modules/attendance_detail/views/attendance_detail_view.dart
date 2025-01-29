import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/attendance_detail_controller.dart';

class AttendanceDetailView extends GetView<AttendanceDetailController> {
  AttendanceDetailView({super.key});

  final Map<String, dynamic> attendance = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ATTENDANCE DETAIL',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(padding: EdgeInsets.all(20), children: [
        Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(width: 1, color: Colors.grey[200]!)),
            elevation: 1,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '${DateFormat.yMMMMEEEEd().format(DateTime.parse(attendance['date']))}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Check-in Details',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  attendance['in'] == null
                      ? Text('-')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Time: ${DateFormat.Hms().format(DateTime.parse(attendance['in']['timestamp']))}',
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Position: ${attendance['in']['address']['street']}, ${attendance['in']['address']['sub_locality'] != null ? attendance['in']['address']['sub_locality']! + ', ' : ''}${attendance['in']['address']['locality'] != null ? attendance['in']['address']['locality']! + ', ' : ''}${attendance['in']['address']['administrative_area']}, ${attendance['in']['address']['country']}',
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                                'Distance: ${attendance['in']['distance'].toString().split('.').first}m away'),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Status: ${attendance['in']['in_range'] ? 'In range' : 'Out of range'}',
                              style: TextStyle(
                                  color: attendance['in']['in_range']
                                      ? Colors.black
                                      : Colors.red),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Check-out Details',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  attendance['out'] == null
                      ? Text('-')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Time: ${DateFormat.Hms().format(DateTime.parse(attendance['in']['timestamp']))}',
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Position: ${attendance['out']['address']['street']}, ${attendance['out']['address']['sub_locality'] != null ? attendance['out']['address']['sub_locality']! + ', ' : ''}${attendance['out']['address']['locality'] != null ? attendance['out']['address']['locality']! + ', ' : ''}${attendance['out']['address']['administrative_area']}, ${attendance['out']['address']['country']}',
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                                'Distance: ${attendance['out']['distance'].toString().split('.').first}m away'),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Status: ${attendance['out']['in_range'] ? 'In range' : 'Out of range'}',
                              style: TextStyle(
                                  color: attendance['out']['in_range']
                                      ? Colors.black
                                      : Colors.red),
                            ),
                          ],
                        ),
                ],
              ),
            )),
      ]),
    );
  }
}
