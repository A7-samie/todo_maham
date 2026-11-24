// ignore_for_file: file_names

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:todo_maham/features/home/Model/task_model.dart';

class TaskScreen extends StatelessWidget {
  final TaskModel task;
  final void Function(TaskModel) onTaskChange;
  final void Function(String) onDelete;

  const TaskScreen({
    super.key,
    required this.task,
    required this.onTaskChange,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        tileColor: Colors.white,
        onTap: () => onTaskChange(task),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: Icon(
          task.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: task.isDone ? Colors.blue : Colors.grey,
        ),
        title: Text(
          "${task.taskText}",
          style: TextStyle(
            color: task.isDone ? Colors.black : Colors.grey,
            fontSize: 20,
            fontWeight: task.isDone ? FontWeight.bold : FontWeight.w400,
          ),
        ),
        trailing: task.isDone
            ? Container(
                height: 35.h,
                width: 35.w,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () => onDelete(task.iD!),
                  icon: const Icon(Icons.delete, color: Colors.white, size: 25),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
