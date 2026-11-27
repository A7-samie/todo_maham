import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_maham/features/home/Model/task_model.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  static const String _tasksKey = 'tasks_list';

  List<TaskModel> _allTasks = [];
  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> loadTasks() async {
    emit(TaskLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tasksJson = prefs.getString(_tasksKey);

      if (tasksJson != null) {
        final List<dynamic> decoded = jsonDecode(tasksJson);
        _allTasks = decoded.map((e) => TaskModel.fromJson(e)).toList();
      } else {
        await _saveTasks();
      }

      emit(TaskLoaded(tasks: _allTasks, filteredTasks: _allTasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      _allTasks.map((t) => t.toJson()).toList(),
    );
    await prefs.setString(_tasksKey, encoded);
  }

  Future<void> addTask(String taskText) async {
    if (taskText.trim().isEmpty) return;

    final newTask = TaskModel(
      iD: DateTime.now().millisecondsSinceEpoch.toString(),
      taskText: taskText.trim(),
    );

    _allTasks.add(newTask);
    await _saveTasks();
    emit(TaskLoaded(tasks: _allTasks, filteredTasks: _allTasks));
  }

  Future<void> toggleTask(TaskModel task) async {
    final index = _allTasks.indexWhere((t) => t.iD == task.iD);
    if (index != -1) {
      _allTasks[index] = _allTasks[index].copyWith(
        isDone: !_allTasks[index].isDone,
      );
      await _saveTasks();

      final currentState = state;
      if (currentState is TaskLoaded) {
        final filtered = currentState.filteredTasks.map((t) {
          if (t.iD == task.iD) return _allTasks[index];
          return t;
        }).toList();
        emit(TaskLoaded(tasks: _allTasks, filteredTasks: filtered));
      } else {
        emit(TaskLoaded(tasks: _allTasks, filteredTasks: _allTasks));
      }
    }
  }

  Future<void> deleteTask(String id) async {
    _allTasks.removeWhere((t) => t.iD == id);
    await _saveTasks();
    emit(TaskLoaded(tasks: _allTasks, filteredTasks: _allTasks));
  }

  void searchTasks(String word) {
    if (word.isEmpty) {
      emit(TaskLoaded(tasks: _allTasks, filteredTasks: _allTasks));
    } else {
      final filtered = _allTasks
          .where((t) => t.taskText!.toLowerCase().contains(word.toLowerCase()))
          .toList();
      emit(TaskLoaded(tasks: _allTasks, filteredTasks: filtered));
    }
  }

  Future<void> loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString('profile_image_path');
    if (savedPath != null) {
      final file = File(savedPath);
      if (await file.exists()) {
        profileImage = file;
        // 👇 ضيف emit عشان الـ UI يتحدث
        final currentState = state;
        if (currentState is TaskLoaded) {
          emit(
            TaskLoaded(
              tasks: currentState.tasks,
              filteredTasks: currentState.filteredTasks,
            ),
          );
        }
      }
    }
  }

  Future<void> pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage = await File(picked.path)
        .copy(path.join(appDir.path, fileName));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', savedImage.path);

    profileImage = savedImage;
    // 👇 ضيف emit عشان الـ UI يتحدث
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(
        TaskLoaded(
          tasks: currentState.tasks,
          filteredTasks: currentState.filteredTasks,
        ),
      );
    }
  }
}
