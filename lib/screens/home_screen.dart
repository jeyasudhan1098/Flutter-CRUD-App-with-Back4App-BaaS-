import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import 'task_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TaskService _taskService;
  late final AuthService _auth;

  @override
  void initState() {
    super.initState();
    _taskService = Provider.of<TaskService>(context, listen: false);
    _auth = Provider.of<AuthService>(context, listen: false);
    // initial refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _taskService.refreshTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<AuthService>(context).username ?? 'User';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).logout();
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
            },
            tooltip: 'Logout',
          )
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Welcome, $username'),
            subtitle: const Text('Your tasks (auto-refresh every 3s)'),
            trailing: FloatingActionButton(
              heroTag: 'add-task',
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TaskEditScreen())),
              child: const Icon(Icons.add),
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _taskService.tasksStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('Waiting for tasks...'));
                }
                final tasks = snapshot.data ?? [];
                if (tasks.isEmpty) {
                  return const Center(child: Text('No tasks yet'));
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, i) {
                    final t = tasks[i];
                    return ListTile(
                      title: Text(t.title),
                      subtitle: Text(t.description),
                      trailing: PopupMenuButton<String>(
                        onSelected: (val) async {
                          if (val == 'edit') {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => TaskEditScreen(task: t)));
                          } else if (val == 'delete') {
                            final ok = await showDialog<bool>(
                              context: context,
                              builder: (c) => AlertDialog(
                                title: const Text('Delete?'),
                                content: Text('Delete "${t.title}"?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                                  TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
                                ],
                              ),
                            );
                            if (ok == true) {
                              await _taskService.deleteTask(t.id);
                            }
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
