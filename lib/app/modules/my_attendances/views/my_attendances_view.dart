import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/my_attendances_controller.dart';

class MyAttendancesView extends GetView<MyAttendancesController> {
  const MyAttendancesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY ATTENDANCES'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              Get.dialog(Dialog(
                  child: Container(
                      width: 400,
                      height: 400,
                      child: SfDateRangePicker(
                        monthViewSettings:
                            DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                        selectionMode: DateRangePickerSelectionMode.range,
                        showActionButtons: true,
                        onCancel: () => Get.back(),
                        onSubmit: (object) {
                          if (object != null) {
                            controller.sortAttendancesByDate(
                                (object as PickerDateRange));
                          }
                        },
                      ))));
            },
          ),
        ],
      ),
      body: GetBuilder<MyAttendancesController>(builder: (c) {
        return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: c.getAttendances(),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    attendance['out'] != null
                                        ? '${DateFormat.Hms().format(DateTime.parse(attendance['out']['timestamp']))}'
                                        : '-',
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
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
            });
      }),
    );
  }
}
