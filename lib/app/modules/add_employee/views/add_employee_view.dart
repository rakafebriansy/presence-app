import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/helper/custom_styles.dart';

import '../controllers/add_employee_controller.dart';

class AddEmployeeView extends GetView<AddEmployeeController> {
  const AddEmployeeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Employee'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              autocorrect: false,
              controller: controller.identificationNumberC,
              decoration: InputDecoration(
                  labelText: 'ID Number', border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              autocorrect: false,
              controller: controller.nameC,
              decoration: InputDecoration(
                  labelText: 'Name', border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              autocorrect: false,
              controller: controller.emailC,
              decoration: InputDecoration(
                  labelText: 'Email', border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => DropdownButton<String>(
                  value: controller.selectedJob.value,
                  items: [
                    DropdownMenuItem(value: 'Lecturer',child: Text('Lecturer')),
                    DropdownMenuItem(value: 'Student',child: Text('Student')),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      controller.selectedJob.value = value;
                    }
                  }),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  Get.defaultDialog(
                      title: 'ADD USER',
                      middleText: 'Please make sure that you\'re an admin.',
                      content: TextField(
                        autocorrect: false,
                        obscureText: true,
                        controller: controller.adminPasswordC,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder()),
                      ),
                      actions: [
                        OutlinedButton(
                            onPressed: () => Get.back(), child: Text('CANCEL')),
                        OutlinedButton(
                            onPressed: () async {
                              if (controller.isLoading.isFalse) {
                                await controller.add();
                              }
                            },
                            child: Text('SUBMIT')),
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
