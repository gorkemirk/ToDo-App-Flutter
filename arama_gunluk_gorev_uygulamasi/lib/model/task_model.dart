import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String task;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  bool taskCompleted;
  Task(
      {required this.id,
      required this.task,
      required this.date,
      required this.taskCompleted});
  factory Task.create({required String task, required DateTime date}) {
    return Task(id: Uuid().v1(), task: task, date: date, taskCompleted: false);
  }
}
