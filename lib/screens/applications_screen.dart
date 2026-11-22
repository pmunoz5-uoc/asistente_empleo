import 'package:material_ui/material_ui.dart';
//Pantalla de candidaturas.
class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Candidaturas')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: const TextField(
                decoration: InputDecoration(
                  labelText: 'Buscar',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                initialValue: 'Todos',
                decoration: const InputDecoration(
                  labelText: 'Filtrar por estado',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                  DropdownMenuItem(
                    value: 'Interesante',
                    child: Text('Interesante'),
                  ),
                  DropdownMenuItem(
                    value: 'CV enviado',
                    child: Text('CV enviado'),
                  ),
                  DropdownMenuItem(
                    value: 'Entrevista',
                    child: Text('Entrevista'),
                  ),
                  DropdownMenuItem(
                    value: 'Pendiente',
                    child: Text('Pendiente'),
                  ),
                  DropdownMenuItem(
                    value: 'Descartada',
                    child: Text('Descartada'),
                  ),
                  DropdownMenuItem(
                    value: 'Contratada',
                    child: Text('Contratada'),
                  ),
                ],
                onChanged: (_) {},
              ),
            ),
            const SizedBox(height: 8),
            const Expanded(
              child: Center(child: Text('No hay candidaturas que mostrar.')),
            ),
          ],
        ),
      ),
    );
  }
}
