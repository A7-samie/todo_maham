class TaskModel {
  String? iD;
  String? taskText;
  bool isDone;

  TaskModel({required this.iD, required this.taskText, this.isDone = false});

  // ✅ تحويل من JSON (للقراءة من SharedPreferences)
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      iD: json['iD'],
      taskText: json['taskText'],
      isDone: json['isDone'] ?? false,
    );
  }

  // ✅ تحويل إلى JSON (للحفظ في SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'iD': iD,
      'taskText': taskText,
      'isDone': isDone,
    };
  }

  // نسخة معدلة (مفيدة في الـ Cubit)
  TaskModel copyWith({String? iD, String? taskText, bool? isDone}) {
    return TaskModel(
      iD: iD ?? this.iD,
      taskText: taskText ?? this.taskText,
      isDone: isDone ?? this.isDone,
    );
  }
}
