enum TaskStatus { completed, toDo, inProgress }

extension TaskStatusExtension on TaskStatus {
  String toJson() {
    return this.toString().split('.').last;
  }

  static TaskStatus fromJson(String json) {
    switch (json) {
      case 'completed':
        return TaskStatus.completed;
      case 'toDo':
        return TaskStatus.toDo;
      case 'inProgress':
        return TaskStatus.inProgress;
      default:
        throw Exception('Unknown TaskStatus value: $json');
    }
  }
}
