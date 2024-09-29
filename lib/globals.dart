
import 'package:get/get.dart';

///Show [Snackbar] when adding tasks, deleting them, marking them as done or deleting them from marked as done list.

showSnackBar({
  required String content,
  Duration duration = const Duration(milliseconds:200),
}) {
  ///removeCurrentSnackbar will prevent the snackbar from showing up multiple times when user does some operations(add, delete, mark as done) back to back.
  Get..closeCurrentSnackbar()..showSnackbar(GetSnackBar(message: content,animationDuration: duration,duration:const Duration(milliseconds: 1100),));
}

///Enum to tell the dialog either it is editing or creating a new task
enum EditMode {
  newTask,
  editTask,
}

enum ListType{
  tasksList,
  tasksDoneList,
}
