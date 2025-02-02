import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    bool authenticated = await _auth.authenticate(
      localizedReason: 'Scan your fingerprint to authenticate',
      options: AuthenticationOptions(
        biometricOnly: true, // Only biometric authentication (no PIN/pattern)
      ),
    );
    return authenticated;
  }
}