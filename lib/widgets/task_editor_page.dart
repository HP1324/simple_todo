import 'package:flutter/material.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/category.dart';
import 'package:planner/models/task.dart';
import 'package:planner/providers/category_provider.dart';
import 'package:planner/providers/task_provider.dart';
import 'package:planner/widgets/category_dialog.dart';
import 'package:planner/widgets/planner_text_field.dart';
import 'package:provider/provider.dart';

int selectedCategory = 1;

//ignore: must_be_immutable
class TaskEditorPage extends StatelessWidget {
  TaskEditorPage(
      {super.key, this.taskToEdit, this.taskToEditID, this.editMode});
  Task? taskToEdit;
  int? taskToEditID;
  bool? editMode;
  var titleController = TextEditingController();
  var dropDownController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (editMode!) selectedCategory = taskToEdit!.categoryId as int;
    return Scaffold(
        appBar: AppBar(
          title: editMode! ? const Text('Edit Task') : const Text('New Task'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                if (editMode!)
                  Text(
                    'old title: ${taskToEdit!.title}',
                  ),
                PlannerTextField(
                  controller: titleController,
                  isMaxLinesNull: true,
                  isAutoFocus: true,
                  hintText: editMode!
                      ? 'What needs changing?'
                      : 'What\'s on your to-do list?',
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownMenu(
                        menuHeight: 300,
                        controller: dropDownController,
                        hintText: 'Select a category',
                        initialSelection: selectedCategory,
                        width: MediaQuery.sizeOf(context).width * 0.85,
                        dropdownMenuEntries:
                            context.watch<CategoryProvider>().categories.map(
                          (e) {
                            debugPrint(
                                'category inside entries : ${e.toString()}');
                            var categoryObj = CategoryModel.fromJson(e);
                            return DropdownMenuEntry(
                              value: categoryObj.categoryId,
                              label: categoryObj.categoryName,
                            );
                          },
                        ).toList(),
                        onSelected: (selected) {
                          selectedCategory = int.parse(selected.toString());
                        },
                      ),
                    ),
                    InkWell(
                      child: const Icon(
                        Icons.add,
                        size: 50,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return CategoryDialog();
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.065,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.tealShade500,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: const Center(
                      child: Text(
                        'Add reminder',
                        style: TextStyle(
                            color: AppTheme.tealShade50, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.065,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppTheme.tealShade600,
                      borderRadius: BorderRadius.circular(7)),
                  child: InkWell(
                    onTap: () async {
                      var messenger = ScaffoldMessenger.of(context);
                      var navigator = Navigator.of(context);
                      final taskProvider = context.read<TaskProvider>();
                      if (!editMode!) {
                        Task task = Task(
                            title: titleController.text,
                            categoryId: selectedCategory);
                        if (await taskProvider.addTask(task)) {
                          navigator.pop();
                          showSnackBar(messenger, content: 'Task added');
                        }
                      } else {
                        await taskProvider.editTask(
                          taskToEdit: taskToEdit!,
                          title: titleController.text.trim().isEmpty
                              ? null
                              : titleController.text,
                          categoryId: selectedCategory != taskToEdit!.categoryId
                              ? selectedCategory
                              : null,
                        );
                        showSnackBar(messenger, content: 'Task edited');
                        navigator.pop();
                      }
                      selectedCategory = 1;
                    },
                    child: const Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: AppTheme.tealShade50, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
