import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/colors/app_colors.dart';
import '../../providers/task_provider.dart';
import '../../widgets/date_timeline.dart';
import '../../widgets/task_card.dart';
import '../add_task/add_taskscreen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,


      appBar: AppBar(
        backgroundColor:
        Theme.of(context).scaffoldBackgroundColor,

        elevation: 0,

        title: Text(
          'app_name'.tr(),

          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const SettingsScreen(),
                ),
              );
            },

            icon: const Icon(
              Icons.settings_outlined,
              size: 27,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),


      body: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          const SizedBox(height: 5),


          DateTimelineWidget(
            selectedDate: selectedDate,

            onDateChange: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),

          const SizedBox(height: 10),


          Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: Text(
              'tasks'.tr(),

              style: const TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),


          Expanded(
            child: Consumer<TaskProvider>(
              builder: (
                  context,
                  taskProvider,
                  child,
                  ) {

                if (taskProvider.isLoading) {
                  return const Center(
                    child:
                    CircularProgressIndicator(),
                  );
                }


                final selectedTasks =
                taskProvider.tasksForDate(
                  selectedDate,
                );


                if (selectedTasks.isEmpty) {
                  return _emptyState();
                }


                return ListView.builder(
                  padding:
                  const EdgeInsets.only(
                    bottom: 100,
                  ),

                  itemCount:
                  selectedTasks.length,

                  itemBuilder: (
                      context,
                      index,
                      ) {
                    return TaskCard(
                      task:
                      selectedTasks[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),


      floatingActionButton:
      FloatingActionButton(
        backgroundColor:
        AppColors.primary,

        foregroundColor:
        Colors.white,

        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) =>
              const AddTaskScreen(),
            ),
          );
        },

        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation
          .centerFloat,
    );
  }


  Widget _emptyState() {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 30,
        ),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Container(
              width: 90,
              height: 90,

              decoration:
              BoxDecoration(
                color:
                AppColors.primary
                    .withValues(
                  alpha: 0.10,
                ),

                shape:
                BoxShape.circle,
              ),

              child: Icon(
                Icons.task_alt_rounded,

                size: 45,

                color:
                AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),


            Text(
              'no_tasks'.tr(),

              textAlign:
              TextAlign.center,

              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'tap_add'.tr(),

              textAlign:
              TextAlign.center,

              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}