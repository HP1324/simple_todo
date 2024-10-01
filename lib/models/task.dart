class Task {
  Task({this.id, required this.title, this.isDone = false, this.categoryId});

  int? id;
  String title;
  int? categoryId;  // Foreign key representing the category
  bool isDone;

  Task copyWith({
    int? id,
    String? title,
    bool? isDone,
    int? categoryId,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
        categoryId: categoryId ?? this.categoryId,
      );

  @override
  bool operator ==(Object other) {
    return other is Task &&
        id == other.id &&
        other.title == title &&
        other.isDone == isDone &&
        hashCode == other.hashCode;
  }

  @override
  int get hashCode => title.hashCode ^ isDone.hashCode;

  // Convert Task to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'categoryId': categoryId,
    'isDone': isDone ? 1 : 0,
  };

  // Create a Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'] ?? '',
    categoryId: json['categoryId'],
    isDone: json['isDone'] == 1,
  );
}
