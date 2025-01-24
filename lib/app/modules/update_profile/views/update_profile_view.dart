import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/helper/custom_styles.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Profile'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              readOnly: true,
              controller: controller.emailC,
              decoration: InputDecoration(
                  labelText: 'Email', border: OutlineInputBorder()),
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
              controller: controller.identificationNumberC,
              decoration: InputDecoration(
                  labelText: 'ID Number', border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  controller.updateProfile();
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
