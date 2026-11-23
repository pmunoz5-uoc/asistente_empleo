//Posibles estados de una candidatura.
enum ApplicationStatus {
  saved,
  cvSent,
  interview,
  pending,
  discarded,
  hired,
}
extension ApplicationStatusText on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.saved:
        return 'Guardada';
      case ApplicationStatus.cvSent:
        return 'CV enviado';
      case ApplicationStatus.interview:
        return 'Entrevista';
      case ApplicationStatus.pending:
        return 'Pendiente';
      case ApplicationStatus.discarded:
        return 'Descartada';
      case ApplicationStatus.hired:
        return 'Contratada';
    }
  }

  String get databaseValue {
    switch (this) {
      case ApplicationStatus.saved:
        return 'saved';
      case ApplicationStatus.cvSent:
        return 'cv_sent';
      case ApplicationStatus.interview:
        return 'interview';
      case ApplicationStatus.pending:
        return 'pending';
      case ApplicationStatus.discarded:
        return 'discarded';
      case ApplicationStatus.hired:
        return 'hired';
    }
  }

  static ApplicationStatus fromDatabase(String value) {
    return ApplicationStatus.values.firstWhere(
      (status) => status.databaseValue == value,
      orElse: () => ApplicationStatus.saved,
    );
  }
}
