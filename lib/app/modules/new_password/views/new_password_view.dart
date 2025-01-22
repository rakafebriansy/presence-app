import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/helper/custom_styles.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('NEW PASSWORD'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              obscureText: true,
              controller: controller.passwordC,
              autocorrect: false,
              decoration: InputDecoration(
                  labelText: 'New Password', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20,),
            TextField(
              obscureText: true,
              controller: controller.confirmPasswordC,
              autocorrect: false,
              decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {
                controller.setPassword();
              },
              child: Text('SUBMIT'),
              style: CustomStyles.primaryButton(),
            )
          ],
        ));
  }
}
