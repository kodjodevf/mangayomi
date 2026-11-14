import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The OS secure storage every secret of the app goes through.
///
/// On macOS it uses the login keychain: the data protection keychain, the
/// package's default, needs an app signed with a team and a keychain access
/// group, which the macOS builds are not, and refuses them with -34018.
const secureStorage = FlutterSecureStorage(
  mOptions: MacOsOptions(usesDataProtectionKeychain: false),
);
