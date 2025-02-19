enum TaskPriority { low, medium, high }

extension TaskPriorityExtension on TaskPriority {
  String toJson() {
    return this.toString().split('.').last;
  }

  static TaskPriority fromJson(String json) {
    switch (json) {
      case 'low':
        return TaskPriority.low;
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      default:
        throw Exception('Unknown TaskPriority value: $json');
    }
  }
}
