import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class Biometrics {
  static Future<bool> authenticate({String message = "Authenticate to continue"}) async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool didAuthenticate = await auth.authenticate(localizedReason: message, options: const AuthenticationOptions(stickyAuth: true));
      return didAuthenticate;
    } on PlatformException catch (err) {
      print(err);
      switch (err.code) {
        case auth_error.notAvailable:
          break;
        case auth_error.notEnrolled:
          break;
        default:
      }
      return false;
    }
  }
}
