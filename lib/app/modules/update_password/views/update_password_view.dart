import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/helper/custom_styles.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'UPDATE PASSWORD',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Obx(
              () => TextField(
                autocorrect: false,
                obscureText: controller.isHidden.value,
                controller: controller.currentPasswordC,
                decoration: InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () => controller.isHidden.value =
                            !controller.isHidden.value,
                        icon: Icon(controller.isHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => TextField(
                autocorrect: false,
                obscureText: controller.isNewHidden.value,
                controller: controller.newPasswordC,
                decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () => controller.isNewHidden.value =
                            !controller.isNewHidden.value,
                        icon: Icon(controller.isNewHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => TextField(
                autocorrect: false,
                obscureText: controller.isConfirmHidden.value,
                controller: controller.confirmNewPasswordC,
                decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () => controller.isConfirmHidden.value =
                            !controller.isConfirmHidden.value,
                        icon: Icon(controller.isConfirmHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility))),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.updatePassword();
                  }
                },
                child: controller.isLoading.isFalse
                    ? Text('UPDATE')
                    : Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('UPDATING'),
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
