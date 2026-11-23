# Asistente de empleo
Aplicación asistente de búsqueda de empleo.

Funcionalidades:
Carga de CV.
Gestor de candidaturas.
Análisis de ofertas con IA, con generación de CV adaptado y carta de presentación.

El perfil, el texto del CV y las candidaturas se guardan localmente en SQLite.
Los datos siguen disponibles al cerrar y volver a abrir la aplicación; no se
envían a un servidor para su almacenamiento.
La creación y las migraciones de las tablas se centralizan en
`lib/features/database/app_database.dart`.


## Ejecutar
flutter pub get
flutter run


## Comprobar
flutter analyze
flutter test

