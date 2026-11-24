part of 'task_cubit.dart';

abstract class TaskState {}

// الحالة الأولية
class TaskInitial extends TaskState {}

// جاري التحميل
class TaskLoading extends TaskState {}

// البيانات جاهزة
class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;
  final List<TaskModel> filteredTasks;

  TaskLoaded({required this.tasks, required this.filteredTasks});
}

// حصل خطأ
class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
