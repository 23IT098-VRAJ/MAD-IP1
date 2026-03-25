import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../models/app_user.dart';
import '../../providers/app_data_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/operator_drawer.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppUser? user = context.watch<AuthProvider>().currentUser;
    final AppDataProvider dataProvider = context.watch<AppDataProvider>();

    final tasks = user == null
        ? <dynamic>[]
        : dataProvider.tasksForUser(user.id);

    return AppScaffold(
      title: AppStrings.tasks,
      drawer: const OperatorDrawer(),
      body: tasks.isEmpty
          ? const EmptyStateWidget(
              message: AppStrings.noTasks,
              icon: Icons.assignment_outlined,
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                final task = tasks[index];
                return AppCard(
                  child: CheckboxListTile(
                    value: task.completed,
                    title: Text(task.title),
                    subtitle: Text(
                      '${task.description}\n${DateFormat('dd MMM yyyy').format(task.dueDate)}',
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (_) =>
                        dataProvider.toggleTaskCompletion(task.id),
                  ),
                );
              },
            ),
    );
  }
}
