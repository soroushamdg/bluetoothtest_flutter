import 'package:bluetoothtest/controllers/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BlueTest'),
        leading: Obx(() => Get.find<BlueController>().isConnected.value
            ? IconButton(onPressed: () {}, icon: Icon(Icons.refresh))
            : IconButton(onPressed: null, icon: Icon(Icons.refresh))),
        actions: [
          Obx(() {
            return Get.find<BlueController>().isConnected.value
                ? IconButton(
                    onPressed: null, icon: Icon(Icons.bluetooth_connected))
                : IconButton(
                    onPressed: () async {
                      await Get.find<BlueController>().startScan();
                      await Future.delayed(const Duration(seconds: 2), () {});
                      List<String> results =
                          Get.find<BlueController>().scanneddevices;
                      await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 300.0,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 24.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Choose your device : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: results.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            onTap: () async {
                                              await Get.find<BlueController>()
                                                  .connectDevice(
                                                      results[index]);
                                              await Future.delayed(
                                                  Duration(seconds: 2));
                                              bool connected =
                                                  Get.find<BlueController>()
                                                      .isConnected
                                                      .value;
                                              if (connected) {
                                                Get.back();
                                              } else {
                                                Get.defaultDialog(
                                                    title:
                                                        'Couldn\'t find the device');
                                              }
                                            },
                                            title: Text(
                                              results[index].toString(),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            );
                          });
                      await Future.delayed(Duration(seconds: 2));

                      await Get.find<BlueController>().searchforservices();
                    },
                    icon: Icon(Icons.bluetooth_connected));
          }),
          Obx(
            () => Get.find<BlueController>().isConnected.value
                ? IconButton(
                    onPressed: () async {
                      await Get.find<BlueController>().disconnect();
                    },
                    icon: Icon(Icons.bluetooth_disabled))
                : IconButton(
                    onPressed: null, icon: Icon(Icons.bluetooth_disabled)),
          ),
        ],
      ),
      body: Column(children: [
        Obx(() => Expanded(
            child: ListView.builder(
                itemCount: Get.find<BlueController>().services.length,
                itemBuilder: (context, index) {
                  BluetoothService srv =
                      Get.find<BlueController>().services.value[index];
                  return ListTile(
                    title: Text("Service uuid : ${srv.uuid}"),
                  );
                }))),
        MaterialButton(onPressed: () {}),
        MaterialButton(onPressed: () {}),
        MaterialButton(onPressed: () {}),
        MaterialButton(onPressed: () {}),
      ]),
    );
  }
}
