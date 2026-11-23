import 'package:material_ui/material_ui.dart';

import '../features/applications/application_repository.dart';
import '../features/applications/application_status.dart';
import '../features/applications/job_application.dart';

//Pantalla para registrar ofertas y guardarlas como candidaturas.
class ApplicationAnalysisScreen extends StatefulWidget {
  const ApplicationAnalysisScreen({required this.repository, super.key});

  final ApplicationRepository repository;

  @override
  State<ApplicationAnalysisScreen> createState() =>
      _ApplicationAnalysisScreenState();
}

class _ApplicationAnalysisScreenState extends State<ApplicationAnalysisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  final _contactController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _contactController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveApplication() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final now = DateTime.now();
    try {
      await widget.repository.save(
        JobApplication(
          id: 0,
          title: _titleController.text.trim(),
          company: _companyController.text.trim(),
          offerDescription: _descriptionController.text.trim(),
          offerUrl: _urlController.text.trim(),
          contact: _contactController.text.trim(),
          notes: _notesController.text.trim(),
          status: ApplicationStatus.saved,
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Candidatura guardada.',
          ),
        ),
      );
      _formKey.currentState!.reset();
      for (final controller in [
        _titleController,
        _companyController,
        _descriptionController,
        _urlController,
        _contactController,
        _notesController,
      ]) {
        controller.clear();
      }
    } on ApplicationStorageException catch (error) {
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
      appBar: AppBar(title: const Text('Nueva oferta')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Datos de la oferta',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text('Introduce la información de la oferta de empleo.'),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aún no has cargado tu CV',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Carga tu currículum para poder preparar el '
                          'análisis de esta oferta.',
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Cargar CV'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 24),
                TextFormField(
                  key: const ValueKey('offerTitleField'),
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Puesto',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _requiredValue(value, 'el puesto'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('offerCompanyField'),
                  controller: _companyController,
                  decoration: const InputDecoration(
                    labelText: 'Empresa',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _requiredValue(value, 'la empresa'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('offerDescriptionField'),
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción de la oferta',
                    hintText: 'Pega aquí el texto de la oferta.',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  minLines: 8,
                  maxLines: 12,
                  validator: (value) =>
                      _requiredValue(value, 'la descripción de la oferta'),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'Enlace de la oferta (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contacto o reclutador (opcional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notas personales',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _isSaving ? null : _saveApplication,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_isSaving ? 'Guardando…' : 'Guardar candidatura'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
