import 'package:dream_app/domain/datasource/permission.dart';
import 'package:permission_handler/permission_handler.dart';

class PhPermission extends PermissionManager {
  @override
  Future<bool> requestStoragePermission() async {
    bool granted = false;
    await Permission.storage.onGrantedCallback(() {
      granted = true;
    }).onLimitedCallback(() {
      granted = true;
    }).onProvisionalCallback(() {
      granted = true;
    }).request();

    return granted;
  }
}
