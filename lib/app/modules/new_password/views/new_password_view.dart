import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/helper/custom_styles.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    double twentyPercentHeight = MediaQuery.of(context).size.height * 0.2;
    return Scaffold(
        body: Center(
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(
            height: twentyPercentHeight,
          ),
          Text(
            'Please enter a new password due to secure your account!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            obscureText: true,
            controller: controller.passwordC,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'New Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            obscureText: true,
            controller: controller.confirmPasswordC,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.setPassword();
                }
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
          )
        ],
      ),
    ));
  }
}
