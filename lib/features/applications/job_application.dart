import 'application_status.dart';
//Modelo de datos para la candidatura.
class JobApplication {
  const JobApplication({
    required this.id,
    required this.title,
    required this.company,
    required this.offerDescription,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.offerUrl = '',
    this.contact = '',
    this.notes = '',
  });

  final int id;
  final String title;
  final String company;
  final String offerDescription;
  final String offerUrl;
  final String contact;
  final String notes;
  final ApplicationStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
}
