import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';

class TaskEditScreen extends StatefulWidget {
  final Task? task;
  const TaskEditScreen({super.key, this.task});
  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<TaskService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final isEdit = widget.task != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Task' : 'New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  onSaved: (v) => _title = v ?? '',
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter title' : null,
                ),
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (v) => _description = v ?? '',
                  minLines: 1,
                  maxLines: 4,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter description' : null,
                ),
                const SizedBox(height: 12),
                if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: _loading ? null : () async {
                    final form = _formKey.currentState!;
                    if (!form.validate()) return;
                    form.save();
                    setState(() { _loading = true; _error = null; });
                    try {
                      if (isEdit) {
                        await taskService.updateTask(widget.task!.id, _title, _description);
                      } else {
                        final userId = auth.userId;
                        if (userId == null) throw Exception('Not logged in');
                        await taskService.createTask(userId, _title, _description);
                      }
                      if (!mounted) return;
                      Navigator.pop(context);
                    } catch (e) {
                      setState(() { _error = e.toString(); });
                    } finally {
                      setState(() { _loading = false; });
                    }
                  },
                  child: _loading ? const CircularProgressIndicator.adaptive() : Text(isEdit ? 'Save' : 'Create'),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
