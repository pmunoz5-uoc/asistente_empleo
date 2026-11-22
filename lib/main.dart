import 'package:material_ui/material_ui.dart';

import 'screens/applications_screen.dart';
import 'screens/application_analysis_screen.dart';
import 'screens/profile_overview_screen.dart';

//Pagina principal de la aplicación, desde aquí se visualiza el dashboard y se incluye la barra de navegación inferior.
void main() {
  runApp(const EmploymentAssistantApp());
}

//Widget principal de la aplicación
class EmploymentAssistantApp extends StatelessWidget {
  const EmploymentAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asistente de empleo',
      theme: ThemeData(useMaterial3: true),
      home: const DashboardScreen(),
    );
  }
}

//Pantalla principal de la aplicación.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

//Control entre las diferentes ventanas
class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomeDashboard(),
      const ProfileOverviewScreen(),
      const ApplicationAnalysisScreen(),
      const ApplicationsScreen(),
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
class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard();

  @override
  Widget build(BuildContext context) {
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
        const _MetricCard(
          icon: Icons.send_outlined,
          title: 'Candidaturas',
          value: '0',
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
