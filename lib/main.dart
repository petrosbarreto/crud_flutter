import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD Basico Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}

class TodoItem {
  final int id;
  String titulo;
  String descricao;

  TodoItem({
    required this.id,
    required this.titulo,
    required this.descricao,
  });
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<TodoItem> _tarefas = [];
  int _proximoId = 1;

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  // CREATE
  void _criarTarefa() {
    final titulo = _tituloController.text.trim();
    final descricao = _descricaoController.text.trim();

    if (titulo.isEmpty) return;

    setState(() {
      _tarefas.add(
        TodoItem(
          id: _proximoId++,
          titulo: titulo,
          descricao: descricao,
        ),
      );
    });

    _tituloController.clear();
    _descricaoController.clear();
    Navigator.pop(context);
  }

  // UPDATE
  void _atualizarTarefa(TodoItem item) {
    final titulo = _tituloController.text.trim();
    final descricao = _descricaoController.text.trim();

    if (titulo.isEmpty) return;

    setState(() {
      item.titulo = titulo;
      item.descricao = descricao;
    });

    _tituloController.clear();
    _descricaoController.clear();
    Navigator.pop(context);
  }

  // DELETE
  void _deletarTarefa(int id) {
    setState(() {
      _tarefas.removeWhere((tarefa) => tarefa.id == id);
    });
  }

  void _abrirFormulario({TodoItem? itemParaEditar}) {
    if (itemParaEditar != null) {
      _tituloController.text = itemParaEditar.titulo;
      _descricaoController.text = itemParaEditar.descricao;
    } else {
      _tituloController.clear();
      _descricaoController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                itemParaEditar == null ? 'Nova tarefa' : 'Editar tarefa',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Titulo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descricao',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (itemParaEditar == null) {
                      _criarTarefa();
                    } else {
                      _atualizarTarefa(itemParaEditar);
                    }
                  },
                  child: Text(itemParaEditar == null ? 'Salvar' : 'Atualizar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD de Tarefas'),
        centerTitle: true,
      ),
      body: _tarefas.isEmpty
          ? const Center(
              child: Text('Nenhuma tarefa cadastrada ainda.'),
            )
          : ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final item = _tarefas[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(item.titulo),
                    subtitle: Text(item.descricao.isEmpty
                        ? 'Sem descricao'
                        : item.descricao),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _abrirFormulario(itemParaEditar: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletarTarefa(item.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
