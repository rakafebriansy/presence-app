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
                    '${DateFormat.yMMMMEEEEd().format(DateTime.parse(attendance['date']))}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Check-in',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                attendance['in'] == null
                    ? Text('-')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time: ${DateFormat.Hms().format(DateTime.parse(attendance['in']['timestamp']))}',
                          ),
                          Text(
                            'Position: ${attendance['in']['address']['street']}, ${attendance['in']['address']['sub_locality'] != null ? attendance['in']['address']['sub_locality']! + ', ' : ''}${attendance['in']['address']['locality'] != null ? attendance['in']['address']['locality']! + ', ' : ''}${attendance['in']['address']['administrative_area']}, ${attendance['in']['address']['country']}',
                          ),
                          Text(
                              'Distance: ${attendance['in']['distance'].toString().split('.').first}m away'),
                          Text(
                            'Status: ${attendance['in']['in_range'] ? 'In range' : 'Out of range'}',
                          ),
                        ],
                      ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Out',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                attendance['out'] == null
                    ? Text('-')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time: ${DateFormat.Hms().format(DateTime.parse(attendance['in']['timestamp']))}',
                          ),
                          Text(
                            'Position: ${attendance['out']['address']['street']}, ${attendance['out']['address']['sub_locality'] != null ? attendance['out']['address']['sub_locality']! + ', ' : ''}${attendance['out']['address']['locality'] != null ? attendance['out']['address']['locality']! + ', ' : ''}${attendance['out']['address']['administrative_area']}, ${attendance['out']['address']['country']}',
                          ),
                          Text(
                              'Distance: ${attendance['out']['distance'].toString().split('.').first}m away'),
                          Text(
                            'Status: ${attendance['out']['in_range'] ? 'In range' : 'Out of range'}',
                          ),
                        ],
                      ),
              ],
            )),
      ]),
    );
  }
}
