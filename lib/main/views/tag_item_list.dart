import 'package:banana/main/views/tag_search_dialog.dart';
import 'package:banana/utils/values/app_colors.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagItemList extends StatefulWidget {
  const TagItemList({super.key});

  @override
  State<TagItemList> createState() => _TagItemListState();
}

class _TagItemListState extends State<TagItemList> {
  final List<String> selectedTags = Get.find<List<String>>(tag: 'SelectedTags');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 19,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (String tag in selectedTags)
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: TagItem(tag: tag,
                onPress: () {
                  setState(() {
                    selectedTags.remove(tag);
                  });
                },
              ),
            ),
          AddTagItem(
            onPress: () async {
              final List<String> result = await Get.to(
                () => TagSearchDialog(),
                preventDuplicates: false,
              );
              final List<String> addTags = [];
              for (var tag in result) {
                if (!selectedTags.contains(tag)) {
                  addTags.add(tag);
                }
              }
              setState(() {
                selectedTags.addAll(addTags);
              });
            },
          ),
        ],
      ),
    );
  }
}

class TagItem extends StatelessWidget {
  final String tag;
  final VoidCallback onPress;

  const TagItem({super.key, required this.tag, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: 47,
        height: 19,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            "#$tag",
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'Rubik',
              fontWeight: FontWeight.normal,
              color: AppColors.gray,
            ),
          ),
        ),
      ),
    );
  }
}

class AddTagItem extends StatelessWidget {
  final VoidCallback onPress;

  const AddTagItem({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: 47,
        height: 19,
        decoration: BoxDecoration(
          color: AppColors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gray, width: 1),
        ),
        child: Icon(AppIcons.add, size: 16, color: AppColors.gray),
      ),
    );
  }
}
