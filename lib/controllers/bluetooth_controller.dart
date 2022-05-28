import 'package:get/get.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:bluetoothtest/constants/uuidbank.dart';

class BlueController extends GetxController {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  BluetoothDevice? device;

  RxBool isConnected = false.obs;

  RxList<BluetoothService> services = <BluetoothService>[].obs;

  List<String> scanneddevices = [];

  Future<void> startScan() async {
    // Start scanning
    await flutterBlue.startScan(timeout: Duration(seconds: 4));
    _listResultScan();
  }

  void _listResultScan() {
    scanneddevices.clear();
// Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results

      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
        if (r.device.name.isNotEmpty) scanneddevices.add(r.device.name);
      }
    });

    flutterBlue.stopScan();
    return;
  }

  bool connectDevice(String devicename) {
    try {
      var subscription = flutterBlue.scanResults.listen((results) async {
        // do something with scan results
        for (ScanResult r in results) {
          if (r.device.name == devicename) {
            try {
              print("Disconnected first");
              r.device.disconnect();
            } catch (e) {}
            await r.device.connect(autoConnect: false).whenComplete(() {
              device = r.device;
              isConnected.value = true;
            }).catchError((e) {
              print(e);
              throw 'Error in connecting to device';
            }).timeout(Duration(seconds: 5), onTimeout: () {
              throw 'Connecting to ${r.device.name} timeout.';
            });
          }
        }
        if (device == null) {
          throw 'Couldn\'t find the device';
        }
      });
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> searchforservices() async {
    try {
      if (device == null) throw 'no connected to the device';
      services.value = await device!.discoverServices();
      services.forEach((service) {
        // do something with service
        print(service.uuid);
      });
      return Future<bool>.value(true);
    } on Exception catch (e) {
      print(e);
      return Future<bool>.value(false);
    }
  }

  Future<void> disconnect() async {
    await device!.disconnect();
    device = null;
    isConnected.value = false;
    return;
  }
}
