import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:presence_app/app/helper/custom_styles.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    double tenPercentHeight = MediaQuery.of(context).size.height * 0.1;

    return Scaffold(
        body: ListView(
      padding: EdgeInsets.all(20),
      children: [
        SizedBox(
          height: tenPercentHeight,
        ),
        Container(height: 250, child: Lottie.asset('assets/lottie/Auth.json')),
        TextField(
          autocorrect: false,
          controller: controller.emailC,
          decoration: InputDecoration(
            labelText: "Email",
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
          controller: controller.passwordC,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Password",
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
                  controller.login();
                }
              },
              child: controller.isLoading.isFalse
                  ? Text('LOGIN')
                  : Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('LOGGING IN'),
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
              style: CustomStyles.primaryButton()),
        ),
        TextButton(
            onPressed: () => Get.offAllNamed(Routes.FORGOT_PASSWORD),
            child: Text('Forgot Password?'))
      ],
    ));
  }
}
