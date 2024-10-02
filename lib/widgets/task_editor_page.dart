import 'package:flutter/material.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/globals.dart';
import 'package:planner/main.dart';
import 'package:planner/models/category.dart';
import 'package:planner/models/task.dart';
import 'package:planner/providers/category_provider.dart';
import 'package:planner/providers/task_provider.dart';
import 'package:planner/widgets/category_dialog.dart';
import 'package:planner/widgets/planner_text_field.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class TaskEditorPage extends StatelessWidget {
  TaskEditorPage({super.key, this.task, this.editMode});
  Task? task;
  bool? editMode;
  var titleController = TextEditingController();
  var dropDownController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var readCategories = context.read<CategoryProvider>().categories;
    var watchCategories = context.watch<CategoryProvider>().categories;
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
                PlannerTextField(
                  controller: titleController,
                  isMaxLinesNull: true,
                  isAutoFocus: true,
                  hintText: 'What\'s on your to-do list?',
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
                        initialSelection: task != null ?  task!.categoryId: context.watch<CategoryProvider>().selectedCategory ,
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
                        onSelected: (value){
                          context.read<CategoryProvider>().selectedCategory = value!;
                          debugPrint('Selected Category : ${context.read<CategoryProvider>().selectedCategory}');
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
                      Task task = Task(title: titleController.text,);
                      var scaffoldMessenger = ScaffoldMessenger.of(context);
                      var navigator = Navigator.of(context);
                      int categoryId = context.read<CategoryProvider>().selectedCategory;
                      if (await context.read<TaskProvider>().addTask(task,categoryId: categoryId)) {
                        navigator.pop();
                        showSnackBar(scaffoldMessenger, content: 'Task added');
                      }else{

                      }
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
