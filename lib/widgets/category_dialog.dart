import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/category.dart';
import 'package:planner/providers/category_provider.dart';
import 'package:planner/providers/task_provider.dart';
import 'package:planner/widgets/planner_text_field.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class CategoryDialog extends StatelessWidget {
  var categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      child: Column(
        children: [
          PlannerTextField(
            controller: categoryController,
            isMaxLinesNull: false,
            isAutoFocus: true,
            hintText: 'Add new category here',
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  categoryController.clear();
                  Navigator.pop(context);
                },
                child: Container(
                  width: 90,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.tealShade100,
                    border: Border.all(color: AppTheme.darkTeal, width: 0.5),
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(color: AppTheme.darkTeal)),
                ),
              ),
              InkWell(
                onTap: () async{
                  var scaffoldMessenger = ScaffoldMessenger.of(context);
                  if(await context.read<CategoryProvider>().addCategory(categoryName: categoryController.text)){
                    showSnackBar(scaffoldMessenger, content: 'Category added');
                  }
                },
                child: Container(
                  width: 90,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.darkTeal,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: AppTheme.tealShade100),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
