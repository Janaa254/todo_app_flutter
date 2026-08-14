import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/colors/app_colors.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const AddTaskScreen({
    super.key,
    this.task,
  });

  bool get isEditing => task != null;

  @override
  State<AddTaskScreen> createState() =>
      _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _titleController.text = widget.task!.title;

      _descriptionController.text =
          widget.task!.description;

      _selectedDate = widget.task!.date;

      _selectedTime = TimeOfDay(
        hour: widget.task!.time.hour,
        minute: widget.task!.time.minute,
      );
    } else {
      final now = DateTime.now();

      _selectedDate = now;

      _selectedTime =
          TimeOfDay.fromDateTime(now);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }


  Future<void> _selectDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (result != null) {
      setState(() {
        _selectedDate = result;
      });
    }
  }


  Future<void> _selectTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (result != null) {
      setState(() {
        _selectedTime = result;
      });
    }
  }


  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final taskTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final provider =
    context.read<TaskProvider>();

    try {

      if (widget.isEditing) {
        final updatedTask =
        widget.task!.copyWith(
          title:
          _titleController.text.trim(),

          description:
          _descriptionController.text.trim(),

          date: _selectedDate,

          time: taskTime,
        );

        await provider.updateTask(
          updatedTask,
        );
      }


      else {
        final newTask = TaskModel(
          id: DateTime.now()
              .microsecondsSinceEpoch
              .toString(),

          title:
          _titleController.text.trim(),

          description:
          _descriptionController.text.trim(),

          date: _selectedDate,

          time: taskTime,
        );

        await provider.addTask(
          newTask,
        );
      }


      if (!mounted) {
        return;
      }

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final isEditing = widget.isEditing;

    return Scaffold(

      appBar: AppBar(
        title: Text(
          isEditing
              ? 'edit_task'.tr()
              : 'add_task'.tr(),
        ),
      ),


      body: Form(
        key: _formKey,

        child: ListView(
          padding:
          const EdgeInsets.all(20),

          children: [

            TextFormField(
              controller: _titleController,

              textInputAction:
              TextInputAction.next,

              decoration:
              InputDecoration(
                labelText:
                'task_title'.tr(),

                hintText:
                'enter_task_title'.tr(),

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                ),
              ),

              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'please enter task title'
                      .tr();
                }

                return null;
              },
            ),

            const SizedBox(height: 18),


            TextFormField(
              controller:
              _descriptionController,

              maxLines: 4,

              decoration:
              InputDecoration(
                labelText:
                'description'.tr(),

                hintText:
                'enter task description'
                    .tr(),

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),


            ListTile(
              contentPadding:
              EdgeInsets.zero,

              leading: const Icon(
                Icons.calendar_month,
                color:
                AppColors.primary,
              ),

              title: Text(
                'date'.tr(),
              ),

              subtitle: Text(
                DateFormat(
                  'EEEE, d MMMM yyyy',
                ).format(
                  _selectedDate,
                ),
              ),

              trailing: const Icon(
                Icons.chevron_right,
              ),

              onTap: _selectDate,
            ),

            const Divider(),


            ListTile(
              contentPadding:
              EdgeInsets.zero,

              leading: const Icon(
                Icons.access_time,
                color:
                AppColors.primary,
              ),

              title: Text(
                'time'.tr(),
              ),

              subtitle: Text(
                _selectedTime.format(
                  context,
                ),
              ),

              trailing: const Icon(
                Icons.chevron_right,
              ),

              onTap: _selectTime,
            ),

            const SizedBox(height: 30),


            SizedBox(
              height: 55,

              child: ElevatedButton(
                onPressed:
                _isSaving
                    ? null
                    : _saveTask,

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  AppColors.primary,

                  foregroundColor:
                  Colors.white,

                  disabledBackgroundColor:
                  AppColors.primary
                      .withValues(
                    alpha: 0.5,
                  ),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),
                ),

                child: _isSaving
                    ? const SizedBox(
                  width: 24,
                  height: 24,

                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color:
                    Colors.white,
                  ),
                )
                    : Text(
                  isEditing
                      ? 'save_changes'
                      .tr()
                      : 'add task'.tr(),

                  style:
                  const TextStyle(
                    fontSize: 18,
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