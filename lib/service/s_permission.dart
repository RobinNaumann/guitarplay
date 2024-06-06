import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService i = PermissionService._();

  PermissionService._();

  Future<void> ensureMicrophonePermission() async {
    final permission = await getPermission(Permission.microphone);
    if (permission != PermissionStatus.granted) {
      throw Exception("Microphone permission not granted");
    }
  }

  Future<PermissionStatus?> getPermission(Permission p) async {
    final PermissionStatus permission = await p.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [p].request();
      return permissionStatus[p];
    } else {
      return permission;
    }
  }
}
