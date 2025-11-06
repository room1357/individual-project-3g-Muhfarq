import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class RegisterController {
  static final RegisterController _instance = RegisterController._internal();
  factory RegisterController() => _instance;
  RegisterController._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  Future<UserCredential?> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update displayName jika ada
      if (fullName != null && fullName.isNotEmpty) {
        await credential.user?.updateDisplayName(fullName);
        _logger.i('Display name updated for ${credential.user?.email}');
      }

      _logger.i('User registered successfully: ${credential.user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e) {
      _logger.e('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e, stackTrace) {
      _logger.e(
        'Unknown error during register',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
