import 'package:get/get.dart';

class SelectedRoleController extends GetxController {
  var selectedRole = "".obs;

  void setRole(String role) {
    selectedRole.value = role;
  }
}
