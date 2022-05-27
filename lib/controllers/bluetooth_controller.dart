import 'package:get/get.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BlueController extends GetxController {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  BluetoothDevice? device;

  void startScan() {
    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));
  }

  List<String> listResultScan() {
    List<String> deviceNames = [];
// Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
        deviceNames.add(r.device.name);
      }
    });

    flutterBlue.stopScan();
    return deviceNames;
  }

  Future<bool> connectDevice(String devicename) {
    try {
      var subscription = flutterBlue.scanResults.listen((results) async {
        // do something with scan results
        for (ScanResult r in results) {
          if (r.device.name == devicename) {
            await r.device.connect();
            if (r.device.state == BluetoothDeviceState.connected) {
              device = r.device;
              return;
            } else {
              throw 'Couldn\'t connect to the device';
            }
          }
        }
        if (device is Null) {
          throw 'Couldn\'t find the device';
        }
      });
      return Future<bool>.value(true);
    } on Exception catch (e) {
      print(e);
      return Future<bool>.value(false);
    }
  }
}
