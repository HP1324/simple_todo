class Task {
  Task({required this.title, this.isDone = false});

  String title;
  bool isDone;

  static List<Task> getTasksList() {
    return _tasks;
  }

  static List<Task> getTasksDoneList() {
    return _tasksDone;
  }

  void addToTaskList() {
    _tasks.add(this);
  }

  void editTask({required String title}) {
    this.title = title;
  }

  void deleteFromTaskList() {
    _tasks.remove(this);
  }

  void deleteFromTasksDoneList() {
    _tasksDone.remove(this);
  }

  void markAsDone() {
    if (!this.isDone) {
      _tasksDone.add(this);
    }
    _tasks.remove(this);
    this.isDone = true;
  }

bool isValid() => this.title.isNotEmpty;


  static  List<Task> _tasks = [
    Task(title: "Buy groceries"),
    Task(title: "Call mom"),
    Task(title: "Finish homework"),
    Task(title: "Clean the kitchen"),
    Task(title: "Walk the dog"),
    Task(title: "Pay bills"),
    Task(title: "Read a book"),
    Task(title: "Water the plants"),
    Task(title: "Send an email"),
    Task(title: "Organize desk"),
    Task(title: "Plan the weekend"),
    Task(title: "Exercise for 30 mins"),
    Task(title: "Review notes"),
    Task(title: "Schedule a meeting"),
    Task(title: "Update resume"),
    Task(title: "Write a blog post"),
    Task(title: "Backup files"),
    Task(title: "Prepare lunch"),
    Task(title: "Meditate for 10 mins"),
    Task(title: "Change the light bulb"),
    Task(title: "Check the mail"),
    Task(title: "Attend a webinar"),
    Task(title: "Plan a trip"),
    Task(title: "Buy a gift"),
    Task(title: "Watch a tutorial"),
    Task(title: "Respond to comments"),
    Task(title: "Prepare a presentation"),
    Task(title: "Review the budget"),
    Task(title: "Call the plumber"),
    Task(title: "Draft an article"),
    Task(title: "Sort out laundry"),
    Task(title: "Update software"),
    Task(title: "Organize a meeting"),
    Task(title: "Test the new app"),
    Task(title: "Print documents"),
    Task(title: "Book a flight"),
    Task(title: "Write a thank you note"),
    Task(title: "Check stock prices"),
    Task(title: "Update social media"),
    Task(title: "Clean the car"),
  ];
  static List<Task> _tasksDone = [];
}
