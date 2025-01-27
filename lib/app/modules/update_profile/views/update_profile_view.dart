import 'dart:io';

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
              height: 20,
            ),
            Text(
              'Profile Image',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetBuilder<UpdateProfileController>(builder: (controller) {
                  if (controller.pickedImage != null) {
                    return Container(
                      height: 100,
                      width: 100,
                      child: Image.file(
                        File(controller.pickedImage!.path),
                        fit: BoxFit.cover,
                      ),
                    );
                  } else if (controller.image != null) {
                    return Container(
                      height: 100,
                      width: 100,
                      child: Image.network(
                        controller.image!,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return Text('no choosen.');
                }),
                GetBuilder<UpdateProfileController>(builder: (controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (controller.image != null)
                        IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                  title: 'DELETE IMAGE',
                                  middleText:
                                      'Are you sure wan\'t to delete your image?.',
                                  actions: [
                                    OutlinedButton(
                                        onPressed: () => Get.back(),
                                        child: Text('CANCEL')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (controller.isLoading.isFalse) {
                                          controller.deleteImageProfile();
                                        }
                                      },
                                      child: Text('DELETE'),
                                      style:
                                          CustomStyles.roundedPrimaryButton(),
                                    ),
                                  ]);
                            },
                            icon: Icon(Icons.delete)),
                      IconButton(
                          onPressed: () {
                            controller.pickImage();
                          },
                          icon: Icon(Icons.edit))
                    ],
                  );
                })
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.updateProfile();
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
