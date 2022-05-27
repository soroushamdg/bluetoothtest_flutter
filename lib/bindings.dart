import 'package:get/get.dart';
import 'package:bluetoothtest/controllers/bluetooth_controller.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(BlueController());
  }
}
