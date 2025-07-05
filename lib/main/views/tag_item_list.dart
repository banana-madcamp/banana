import 'package:banana/utils/values/app_colors.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagItemList extends StatefulWidget {
  const TagItemList({super.key});

  @override
  State<TagItemList> createState() => _TagItemListState();
}

class _TagItemListState extends State<TagItemList> {
  List<String> selectedTags = [];

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
              child: TagItem(tag: tag),
            ),
          AddTagItem(),
        ],
      ),
    );
  }
}

class TagItem extends StatelessWidget {
  String tag;

  TagItem({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 47,
      height: 19,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        "#$tag",
        style: TextStyle(
          fontSize: 10,
          fontFamily: 'Rubik',
          fontWeight: FontWeight.normal,
          color: AppColors.gray,
        ),
      ),
    );
  }
}

class AddTagItem extends StatelessWidget {
  const AddTagItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
