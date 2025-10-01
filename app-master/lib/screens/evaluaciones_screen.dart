import 'package:flutter/material.dart';

class EvaluacionesScreen extends StatefulWidget {
  static const routeName = '/evaluaciones';

  const EvaluacionesScreen({super.key});

  @override
  State<EvaluacionesScreen> createState() => _EvaluacionesScreenState();
}

class _EvaluacionesScreenState extends State<EvaluacionesScreen> {
  final List<Map<String, dynamic>> _evaluaciones = [
    {
      "title": "t1",
      "dueDate": DateTime(2025, 10, 11),
      "isDone": false,
      "nota": "",
    },
    {
      "title": "t3",
      "dueDate": DateTime(2025, 10, 20),
      "isDone": true,
      "nota": "",
    },
    {
      "title": "t6",
      "dueDate": DateTime(2025, 8, 1),
      "isDone": false,
      "nota": "",
    },
    {
      "title": "t4",
      "dueDate": DateTime(2025, 11, 5),
      "isDone": false,
      "nota": "",
    },
    {
      "title": "t5",
      "dueDate": DateTime(2025, 12, 23),
      "isDone": false,
      "nota": "",
    },
  ];

  String _filtro = "Todas";
  String _busqueda = "";

  List<Map<String, dynamic>> get _filtradas {
    return _evaluaciones.where((e) {
      // Filtro por estado
      if (_filtro == "Pendientes" && e["isDone"] == true) return false;
      if (_filtro == "Completadas" && e["isDone"] == false) return false;

      // Filtro por búsqueda
      final texto =
          e["title"].toString().toLowerCase() +
          e["nota"].toString().toLowerCase();
      return texto.contains(_busqueda.toLowerCase());
    }).toList()..sort(
      (a, b) => (a["dueDate"] as DateTime).compareTo(b["dueDate"] as DateTime),
    );
  }

  void _agregarEvaluacion(String title, String nota, DateTime? dueDate) {
    setState(() {
      _evaluaciones.add({
        "title": title,
        "nota": nota,
        "dueDate": dueDate ?? DateTime.now(),
        "isDone": false,
      });
    });
  }

  void _eliminarEvaluacion(int index) {
    final eliminada = _filtradas[index];
    setState(() {
      _evaluaciones.remove(eliminada);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Evaluación "${eliminada["title"]}" eliminada'),
        action: SnackBarAction(
          label: "Deshacer",
          onPressed: () {
            setState(() {
              _evaluaciones.add(eliminada);
            });
          },
        ),
      ),
    );
  }

  void _abrirModalNueva() {
    final _formKey = GlobalKey<FormState>();
    String titulo = "";
    String nota = "";
    DateTime? fecha;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Título"),
                validator: (value) => value == null || value.isEmpty
                    ? "El título es obligatorio"
                    : null,
                onChanged: (value) => titulo = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Nota (opcional)"),
                onChanged: (value) => nota = value,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() != true) return;

                  // Selección de fecha
                  fecha = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  _agregarEvaluacion(titulo, nota, fecha);
                  Navigator.pop(context);
                },
                child: const Text("Crear Evaluación"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;
    final verdePalmeras = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluaciones"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/");
            },
            tooltip: "Cerrar sesión",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              "Bienvenido $email 👋",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Búsqueda
            TextField(
              decoration: const InputDecoration(
                labelText: "Buscar evaluación...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _busqueda = value;
                });
              },
            ),
            const SizedBox(height: 8),

            // Filtros rápidos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ["Todas", "Pendientes", "Completadas"].map((f) {
                final isSelected = _filtro == f;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _filtro = f;
                      });
                    },
                    selectedColor: verdePalmeras,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Listado
            Expanded(
              child: ListView.builder(
                itemCount: _filtradas.length,
                itemBuilder: (context, index) {
                  final e = _filtradas[index];
                  final dueDate = e["dueDate"] as DateTime;
                  final isDone = e["isDone"] as bool;

                  // Estado derivado
                  String estado;
                  Color estadoColor;
                  if (isDone) {
                    estado = "Completada";
                    estadoColor = Colors.green;
                  } else if (dueDate.isBefore(DateTime.now())) {
                    estado = "Vencida";
                    estadoColor = Colors.red;
                  } else {
                    estado = "Pendiente";
                    estadoColor = Colors.orange;
                  }

                  return Dismissible(
                    key: Key(e["title"] + index.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _eliminarEvaluacion(index),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          e["title"],
                          style: TextStyle(
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : null,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          "Fecha: ${dueDate.day}/${dueDate.month}/${dueDate.year} • Estado: $estado",
                        ),
                        trailing: Checkbox(
                          value: isDone,
                          onChanged: (val) {
                            setState(() {
                              e["isDone"] = val;
                            });
                          },
                          activeColor: verdePalmeras,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirModalNueva,
        backgroundColor: verdePalmeras,
        child: const Icon(Icons.add),
        tooltip: "Agregar nueva evaluación",
      ),
    );
  }
}
