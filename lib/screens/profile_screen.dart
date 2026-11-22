import 'package:material_ui/material_ui.dart';
//Pantalla del formulario del perfil.

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil y CV')),
      body: SafeArea(
        child: Form(
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
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('emailField'),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('phoneField'),
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
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('cvTextField'),
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
                  decoration: const InputDecoration(
                    labelText: 'Puesto principal',
                    helperText: 'Se extrae del CV y puedes corregirlo.',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Guardar perfil'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
