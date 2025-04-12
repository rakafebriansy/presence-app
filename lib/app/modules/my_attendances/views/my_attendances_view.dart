import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/controllers/page_handling_controller.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/my_attendances_controller.dart';

class MyAttendancesView extends GetView<MyAttendancesController> {
  MyAttendancesView({super.key});
  final pageHandlingC = Get.find<PageHandlingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MY ATTENDANCES',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            if (controller.start.value != null)
              return GestureDetector(
                onTap: () {
                  controller.resetSortAttendances();
                },
                child: Icon(Icons.close),
              );
            else
              return SizedBox.shrink();
          }),
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              Get.dialog(Dialog(
                  child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.amber,
                      ),
                      child: SfDateRangePicker(
                        monthViewSettings:
                            DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                        selectionMode: DateRangePickerSelectionMode.range,
                        selectionShape: DateRangePickerSelectionShape.rectangle,
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: GetBuilder<MyAttendancesController>(builder: (c) {
          return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: c.attendancesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData && snapshot.data?.docs.length != 0) {
                  return ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (ctx, i) {
                        Map<String, dynamic> attendance =
                            snapshot.data!.docs[i].data();
                        final Text checkInDifference =
                            pageHandlingC.getDifference(attendance, 'in');
                        final Text checkOutDifference =
                            pageHandlingC.getDifference(attendance, 'out');
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 1, color: Colors.grey[200]!)),
                            elevation: 1,
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(Routes.ATTENDANCE_DETAIL,
                                    arguments: attendance);
                              },
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      '${DateFormat.yMMMEd().format(DateTime.parse(attendance['date']))}',
                                      style: TextStyle(fontSize: 16),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }

                return Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'No data available.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                );
              });
        }),
      ),
    );
  }
}
