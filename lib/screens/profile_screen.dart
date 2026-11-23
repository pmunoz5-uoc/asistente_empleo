import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

import '../features/profile/profile_repository.dart';
import '../features/profile/user_profile.dart';

//Pantalla del formulario del perfil.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.repository, super.key});

  final ProfileRepository repository;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cvTextController = TextEditingController();
  final _positionController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;
  String? _loadError;
  String? _originalPdfName;
  Uint8List? _originalPdfBytes;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cvTextController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await widget.repository.load();
      if (!mounted) return;
      if (profile != null) {
        _fullNameController.text = profile.fullName;
        _emailController.text = profile.email;
        _phoneController.text = profile.phone;
        _cvTextController.text = profile.cvText;
        _positionController.text = profile.position;
        _originalPdfName = profile.originalPdfName;
        _originalPdfBytes = profile.originalPdfBytes;
      }
      setState(() {
        _loadError = null;
        _isLoading = false;
      });
    } on ProfileStorageException catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error.message;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await widget.repository.save(
        UserProfile(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          cvText: _cvTextController.text.trim(),
          position: _positionController.text.trim(),
          originalPdfName: _originalPdfName,
          originalPdfBytes: _originalPdfBytes,
          updatedAt: DateTime.now(),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil guardado en este dispositivo.')),
        );
      }
    } on ProfileStorageException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String? _requiredValue(String? value, String label) {
    if (value == null || value.trim().isEmpty) return 'Introduce $label.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil y CV')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
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
                  setState(() {
                    _isLoading = true;
                    _loadError = null;
                  });
                  _loadProfile();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    return SafeArea(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tu perfil',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Guarda tus datos y un CV base para preparar futuras '
                'candidaturas.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              TextFormField(
                key: const ValueKey('fullNameField'),
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) => _requiredValue(value, 'tu nombre'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('emailField'),
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => _requiredValue(value, 'tu email'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('phoneField'),
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono (opcional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 28),
              Text(
                'Currículum base',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload_file),
                label: const Text('Importar PDF (máx. 10 MB)'),
              ),
              if (_originalPdfName != null)
                Text('PDF original conservado: $_originalPdfName'),
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('cvTextField'),
                controller: _cvTextController,
                decoration: const InputDecoration(
                  labelText: 'Texto del CV',
                  hintText: 'Pega aquí el texto de tu currículum.',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                minLines: 10,
                maxLines: 16,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                key: const ValueKey('extractCvWithAiButton'),
                onPressed: () {},
                icon: const Icon(Icons.auto_awesome_outlined),
                label: const Text('Extraer datos con IA'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('positionField'),
                controller: _positionController,
                decoration: const InputDecoration(
                  labelText: 'Puesto principal',
                  helperText: 'Se extrae del CV y puedes corregirlo.',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _saveProfile,

                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_isSaving ? 'Guardando…' : 'Guardar perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
