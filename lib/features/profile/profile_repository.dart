import 'user_profile.dart';
//Operacion para devolver el perfil.
abstract interface class ProfileRepository {
  Future<UserProfile?> load();

  Future<void> save(UserProfile profile);
}
//Operación para devolver error en la carga o guardado de perfil.
class ProfileStorageException implements Exception {
  const ProfileStorageException(this.message);

  final String message;

  @override
  String toString() => message;
}
