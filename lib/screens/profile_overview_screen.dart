import 'package:material_ui/material_ui.dart';

import '../features/profile/profile_repository.dart';
import '../features/profile/user_profile.dart';
import 'profile_screen.dart';

class ProfileOverviewScreen extends StatefulWidget {
  const ProfileOverviewScreen({required this.repository, super.key});

  final ProfileRepository repository;

  @override
  State<ProfileOverviewScreen> createState() => _ProfileOverviewScreenState();
}

class _ProfileOverviewScreenState extends State<ProfileOverviewScreen> {
  UserProfile? _profile;
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await widget.repository.load();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _isLoading = false;
        _loadError = null;
      });
    } on ProfileStorageException catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error.message;
        _isLoading = false;
      });
    }
  }

  Future<void> _openEditor() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProfileScreen(repository: widget.repository),
      ),
    );
    if (!mounted) return;
    setState(() => _isLoading = true);
    await _loadProfile();
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
                  _loadProfile();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    final profile = _profile;
    final hasCv = profile != null && profile.cvText.trim().isNotEmpty;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Perfil', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 20),
        if (profile == null)
          const InformationCard(
            icon: Icons.person_outline,
            title: 'Aún no hay datos de perfil',
            message: 'Completa tus datos básicos para empezar.',
          )
        else ...[
          _ProfileField(label: 'Nombre', value: profile.fullName),
          _ProfileField(label: 'Email', value: profile.email),
          _ProfileField(
            label: 'Teléfono',
            value: profile.phone.isEmpty ? 'No especificado' : profile.phone,
          ),
          _ProfileField(
            label: 'Puesto principal',
            value: profile.position.isEmpty
                ? 'No especificado'
                : profile.position,
          ),
        ],
        const SizedBox(height: 12),
        InformationCard(
          icon: hasCv ? Icons.description_outlined : Icons.upload_file,
          title: hasCv ? 'CV guardado' : 'Aún no has cargado tu CV',
          message: hasCv
              ? 'Texto del currículum guardado en este dispositivo.'
              : 'Pega el texto de tu currículum para conservarlo.',
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          key: const ValueKey('editProfileButton'),
          onPressed: _openEditor,
          icon: Icon(hasCv ? Icons.edit_outlined : Icons.upload_file),
          label: Text(hasCv ? 'Editar perfil' : 'Completar perfil'),
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value),
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
