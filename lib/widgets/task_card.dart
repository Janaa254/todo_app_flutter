import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../core/colors/app_colors.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../screens/add_task/add_taskscreen.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({
    super.key,
    required this.task,
  });



  Future<void> _deleteTask(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'delete_task'.tr(),
          ),

          content: Text(
            'delete_confirmation'.tr(),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: Text(
                'cancel'.tr(),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),

              child: Text(
                'delete'.tr(),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && context.mounted) {
      await context
          .read<TaskProvider>()
          .deleteTask(task.id);
    }
  }


  @override
  Widget build(BuildContext context) {
    final bool isDone = task.isDone;

    return Slidable(
      key: ValueKey(task.id),



      endActionPane: ActionPane(
        motion: const DrawerMotion(),

        children: [
          // DELETE
          SlidableAction(
            onPressed: (_) {
              _deleteTask(context);
            },

            backgroundColor: Colors.red,
            foregroundColor: Colors.white,

            icon: Icons.delete_outline,

            label: 'delete'.tr(),

            borderRadius: BorderRadius.circular(18),
          ),

          // EDIT
          SlidableAction(
            onPressed: (_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTaskScreen(
                    task: task,
                  ),
                ),
              );
            },

            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,

            icon: Icons.edit_outlined,

            label: 'edit_task'.tr(),

            borderRadius: BorderRadius.circular(18),
          ),
        ],
      ),



      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 7,
        ),

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,

          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.07,
              ),

              blurRadius: 8,

              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [


            AnimatedContainer(
              duration: const Duration(
                milliseconds: 200,
              ),

              width: 5,
              height: 72,

              decoration: BoxDecoration(
                color: isDone
                    ? AppColors.green
                    : AppColors.primary,

                borderRadius:
                BorderRadius.circular(20),
              ),
            ),

            const SizedBox(width: 14),



            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    task.title,

                    maxLines: 1,

                    overflow:
                    TextOverflow.ellipsis,

                    style: TextStyle(
                      color: isDone
                          ? AppColors.green
                          : AppColors.primary,

                      fontSize: 18,

                      fontWeight:
                      FontWeight.bold,

                      decoration: isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,

                      decorationColor:
                      AppColors.green,

                      decorationThickness: 2,
                    ),
                  ),


                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 5),

                    Text(
                      task.description,

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style: TextStyle(
                        color: isDone
                            ? AppColors.green
                            .withValues(
                          alpha: 0.75,
                        )
                            : Colors.grey,

                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,

                        decorationColor:
                        AppColors.green,
                      ),
                    ),
                  ],

                  const SizedBox(height: 7),


                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 17,

                        color: isDone
                            ? AppColors.green
                            : Colors.grey,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        DateFormat(
                          'hh:mm a',
                        ).format(task.time),

                        style: TextStyle(
                          color: isDone
                              ? AppColors.green
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),



            InkWell(
              borderRadius:
              BorderRadius.circular(12),

              onTap: () {
                context
                    .read<TaskProvider>()
                    .toggleTask(task.id);
              },

              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 200,
                ),

                width: isDone ? 70 : 60,

                height: 45,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.green
                      : AppColors.primary,

                  borderRadius:
                  BorderRadius.circular(12),
                ),

                child: Text(
                  'done'.tr(),

                  style: const TextStyle(
                    color: Colors.white,

                    fontSize: 14,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}