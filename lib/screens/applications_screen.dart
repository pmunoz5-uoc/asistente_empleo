import 'package:material_ui/material_ui.dart';

import '../features/applications/application_repository.dart';
import '../features/applications/application_status.dart';
import '../features/applications/job_application.dart';

//Pantalla de candidaturas.
class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({required this.repository, super.key});

  final ApplicationRepository repository;

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  final _searchController = TextEditingController();
  List<JobApplication> _applications = [];
  String _search = '';
  ApplicationStatus? _filter;
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final applications = await widget.repository.loadAll();
      if (!mounted) return;
      setState(() {
        _applications = applications;
        _loadError = null;
        _isLoading = false;
      });
    } on ApplicationStorageException catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error.message;
        _isLoading = false;
      });
    }
  }

  List<JobApplication> get _filteredApplications {
    return _applications.where((application) {
      if (_filter != null && application.status != _filter) return false;
      if (_search.isEmpty) return true;
      final text =
          '${application.title} ${application.company} ${application.notes}'
              .toLowerCase();
      return text.contains(_search.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Candidaturas')),
        body: Center(
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
                    _load();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final applications = _filteredApplications;
    return Scaffold(
      appBar: AppBar(title: const Text('Candidaturas')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Buscar',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _search = value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<ApplicationStatus?>(
                initialValue: _filter,
                decoration: const InputDecoration(
                  labelText: 'Filtrar por estado',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<ApplicationStatus?>(
                    value: null,
                    child: Text('Todos'),
                  ),
                  ...ApplicationStatus.values.map(
                    (status) => DropdownMenuItem<ApplicationStatus?>(
                      value: status,
                      child: Text(status.label),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _filter = value),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: applications.isEmpty
                  ? const Center(
                      child: Text('No hay candidaturas que mostrar.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: applications.length,
                      itemBuilder: (context, index) {
                        final application = applications[index];
                        return Card(
                          child: ListTile(
                            title: Text(application.title),
                            subtitle: Text(
                              '${application.company} · '
                              '${application.status.label}',
                            ),
                            isThreeLine: application.notes.isNotEmpty,
                            trailing: const Icon(Icons.work_outline),
                            onTap: () => showDialog<void>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(application.title),
                                content: SingleChildScrollView(
                                  child: Text(
                                    '${application.company}\n\n'
                                    '${application.offerDescription}'
                                    '${application.notes.isEmpty ? '' : '\n\nNotas: ${application.notes}'}',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cerrar'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
