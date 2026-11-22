import 'package:material_ui/material_ui.dart';

import 'profile_screen.dart';
//Pantalla del resumen del perfil.
class ProfileOverviewScreen extends StatelessWidget {
  const ProfileOverviewScreen({super.key});

  Future<void> _openEditor(BuildContext context) {
    return Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Perfil', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 20),
        const InformationCard(
          icon: Icons.person_outline,
          title: 'Aún no hay datos de perfil',
          message: 'Completa tus datos básicos para empezar.',
        ),
        const SizedBox(height: 12),
        const InformationCard(
          icon: Icons.upload_file,
          title: 'Aún no has cargado tu CV',
          message: 'Carga un PDF o pega el texto de tu currículum.',
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          key: const ValueKey('editProfileButton'),
          onPressed: () => _openEditor(context),
          icon: const Icon(Icons.upload_file),
          label: const Text('Cargar CV y completar perfil'),
        ),
      ],
    );
  }
}

class InformationCard extends StatelessWidget {
  const InformationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
