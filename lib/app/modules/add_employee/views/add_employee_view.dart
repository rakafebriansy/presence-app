import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/helper/custom_styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../controllers/add_employee_controller.dart';

class AddEmployeeView extends GetView<AddEmployeeController> {
  const AddEmployeeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ADD USER',
          style: TextStyle(fontWeight: FontWeight.w600),),
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              autocorrect: false,
              controller: controller.identificationNumberC,
              decoration: InputDecoration(
                labelText: 'ID Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              autocorrect: false,
              controller: controller.nameC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Name'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              autocorrect: false,
              controller: controller.emailC,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() => DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Lecturer',
                      child: Text(
                        'Lecturer',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Student',
                      child: Text(
                        'Student',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  value: controller.selectedJob.value,
                  onChanged: (value) =>
                      controller.selectedJob.value = value ?? 'Lecturer',
                  buttonStyleData: ButtonStyleData(
                    height: 53,
                    width: 160,
                    padding: const EdgeInsets.only(
                      left: 14,
                      right: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[600]!,
                        width: 0.8,
                      ),
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    elevation: 1,
                    maxHeight: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!, width: 1)),
                    offset: const Offset(0, -5),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(8),
                      thickness: WidgetStatePropertyAll(6),
                      thumbVisibility: WidgetStatePropertyAll(true),
                    ),
                  ),
                ))),
            SizedBox(
              height: 10,
            ),
            Text('default password: password', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  Get.defaultDialog(
                      title: 'Please make sure that you\'re an admin.',
                      titleStyle: TextStyle(
                        fontSize: 18
                      ),
                      titlePadding: EdgeInsets.all(12),
                      content: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          autocorrect: false,
                          obscureText: true,
                          controller: controller.adminPasswordC,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        OutlinedButton(
                            onPressed: () => Get.back(), child: Text('CANCEL')),
                        ElevatedButton(
                          onPressed: () async {
                            if (controller.isLoading.isFalse) {
                              await controller.add();
                            }
                          },
                          child: Text('SUBMIT'),
                          style: CustomStyles.roundedPrimaryButton(),
                        ),
                      ]);
                },
                child: controller.isLoading.isFalse
                    ? Text('SUBMIT')
                    : Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('SUBMITTING'),
                          SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        ],
                      ),
                style: CustomStyles.primaryButton(),
              ),
            ),
          ],
        ));
  }
}
