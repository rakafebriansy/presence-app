import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/helper/custom_styles.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/forgot_password_controller.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    double tenPercentHeight = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
        body: ListView(padding: EdgeInsets.all(20), children: [
      SizedBox(
        height: tenPercentHeight,
      ),
      Container(height: 250, child: Lottie.asset('assets/lottie/Auth.json')),
      TextField(
        autocorrect: false,
        controller: controller.emailC,
        decoration: InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Obx(() => ElevatedButton(
            onPressed: () {
              controller.sendPasswordReset();
            },
            child: controller.isLoading.isFalse
                ? Text('RESET PASSWORD')
                : Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('SEND RESET PASSWORD'),
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
          )),
      TextButton(
          onPressed: () => Get.offAllNamed(Routes.LOGIN),
          child: Text('Back to Login'))
    ]));
  }
}
