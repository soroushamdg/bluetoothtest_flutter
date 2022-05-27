import 'package:bluetoothtest/controllers/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BlueTest'),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
        actions: [
          IconButton(
              onPressed: () async {
                await Get.find<BlueController>().startScan();
              },
              icon: Icon(Icons.bluetooth_connected)),
          IconButton(onPressed: () {}, icon: Icon(Icons.bluetooth_disabled)),
        ],
      ),
      body: Column(children: [
        MaterialButton(onPressed: () {}),
        MaterialButton(onPressed: () {}),
        MaterialButton(onPressed: () {}),
        MaterialButton(onPressed: () {}),
      ]),
    );
  }
}
