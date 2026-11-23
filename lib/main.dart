import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'screens/applications_screen.dart';
import 'screens/application_analysis_screen.dart';
import 'screens/profile_overview_screen.dart';
import 'features/database/app_database.dart';
import 'features/applications/application_repository.dart';
import 'features/applications/sqlite_application_repository.dart';
import 'features/profile/profile_repository.dart';
import 'features/profile/sqlite_profile_repository.dart';

//Pagina principal de la aplicación, desde aquí se visualiza el dashboard y se incluye la barra de navegación inferior.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(const EmploymentAssistantApp());
}

//Widget principal de la aplicación
class EmploymentAssistantApp extends StatelessWidget {
  const EmploymentAssistantApp({
    this.profileRepository,
    this.applicationRepository,
    super.key,
  });

  final ProfileRepository? profileRepository;
  final ApplicationRepository? applicationRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asistente de empleo',
      theme: ThemeData(useMaterial3: true),
      home: DashboardScreen(
        profileRepository: profileRepository,
        applicationRepository: applicationRepository,
      ),
    );
  }
}

//Pantalla principal de la aplicación.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    this.profileRepository,
    this.applicationRepository,
    super.key,
  });

  final ProfileRepository? profileRepository;
  final ApplicationRepository? applicationRepository;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

//Control entre las diferentes ventanas
class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late final AppDatabase _database = AppDatabase();
  late final ProfileRepository _profileRepository =
      widget.profileRepository ?? SqliteProfileRepository(database: _database);
  late final ApplicationRepository _applicationRepository =
      widget.applicationRepository ??
      SqliteApplicationRepository(database: _database);

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeDashboard(repository: _applicationRepository),
      ProfileOverviewScreen(repository: _profileRepository),
      ApplicationAnalysisScreen(repository: _applicationRepository),
      ApplicationsScreen(repository: _applicationRepository),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, key: ValueKey('profileTab')),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline, key: ValueKey('newOfferButton')),
            selectedIcon: Icon(Icons.work, key: ValueKey('newOfferButton')),
            label: 'Analizar oferta',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Candidaturas',
          ),
        ],
      ),
    );
  }
}

//Ventana Dashboard donde se muestran las estadisticas.
class _HomeDashboard extends StatefulWidget {
  const _HomeDashboard({required this.repository});

  final ApplicationRepository repository;

  @override
  State<_HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<_HomeDashboard> {
  int _applicationCount = 0;
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadApplicationCount();
  }

  Future<void> _loadApplicationCount() async {
    try {
      final applications = await widget.repository.loadAll();
      if (!mounted) return;
      setState(() {
        _applicationCount = applications.length;
        _isLoading = false;
        _loadError = null;
      });
    } on ApplicationStorageException catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error.message;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_loadError!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  setState(() => _isLoading = true);
                  _loadApplicationCount();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Inicio', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Resumen de tu búsqueda de empleo.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        const _MetricCard(
          icon: Icons.work_outline,
          title: 'Ofertas guardadas',
          value: '0',
        ),
        const SizedBox(height: 12),
        const _MetricCard(
          icon: Icons.analytics_outlined,
          title: 'Análisis realizados',
          value: '0',
        ),
        const SizedBox(height: 12),
        _MetricCard(
          icon: Icons.send_outlined,
          title: 'Candidaturas',
          value: _applicationCount.toString(),
        ),
      ],
    );
  }
}

//Widget para usarlo en cada estadística.
class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Expanded(child: Text(title)),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
