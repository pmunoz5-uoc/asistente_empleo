import 'dart:typed_data';

//Modelo de datos para el usuario.
class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.cvText,
    required this.updatedAt,
    this.position = '',
    this.originalPdfName,
    this.originalPdfBytes,
  });

  final String fullName;
  final String email;
  final String phone;
  final String cvText;
  final String position;
  final DateTime updatedAt;
  final String? originalPdfName;
  final Uint8List? originalPdfBytes;
}
