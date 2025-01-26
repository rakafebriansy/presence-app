import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/controllers/page_handling_controller.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final pageC = Get.find<PageHandlingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HOME'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed(Routes.PROFILE);
                },
                icon: Icon(Icons.person)),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Row(
              children: [
                ClipOval(
                  child:
                      Container(width: 75, height: 75, color: Colors.grey[200]
                          // child: Image.network(src),
                          ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('Jl Raya Raya'),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developer',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('222410101050',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Raka Febrian',
                      style: TextStyle(
                        fontSize: 18,
                      ))
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200]),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Masuk'),
                      Text('-'),
                    ],
                  ),
                  Container(
                    height: 20,
                    color: Colors.grey,
                    width: 1,
                  ),
                  Column(
                    children: [
                      Text('Keluar'),
                      Text('-'),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200]),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last 5 days',
                  style: TextStyle(),
                ),
                TextButton(onPressed: () {}, child: Text('See more')),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (ctx, i) => Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Masuk',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${DateFormat.yMMMEd().format(DateTime.now())}',
                        ),
                      ],
                    ),
                    Text(
                      '${DateFormat.jms().format(DateTime.now())}',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Keluar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${DateFormat.jms().format(DateTime.now())}',
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Presence'),
            TabItem(icon: Icons.person, title: 'Profile'),
          ],
          initialActiveIndex: pageC.pageIndex.value,
          onTap: (int i) => pageC.changePage(i),
        ));
  }
}
