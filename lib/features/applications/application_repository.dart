import 'job_application.dart';
//Operación para devolver o guardar candidaturas.
abstract interface class ApplicationRepository {
  Future<List<JobApplication>> loadAll();

  Future<JobApplication> save(JobApplication application);
}
//Operación para gestionar errores relacionados con la carga o guardado de una candidatura.
class ApplicationStorageException implements Exception {
  const ApplicationStorageException(this.message);

  final String message;

  @override
  String toString() => message;
}

