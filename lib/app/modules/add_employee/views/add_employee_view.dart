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
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                Get.defaultDialog(
                    title: 'ADD EMPLOYEE',
                    middleText: 'Please make sure that you\'re an admin.',
                    content: TextField(
                      autocorrect: false,
                      obscureText: true,
                      controller: controller.adminPasswordC,
                      decoration: InputDecoration(
                          labelText: 'Password', border: OutlineInputBorder()),
                    ),
                    actions: [
                      OutlinedButton(
                          onPressed: () async {
                            await controller.add();
                          },
                          child: Text('SUBMIT')),
                      OutlinedButton(
                          onPressed: () => Get.back(), child: Text('CANCEL'))
                    ]);
              },
              child: Text('SUBMIT'),
              style: CustomStyles.primaryButton(),
            ),
          ],
        ));
  }
}
