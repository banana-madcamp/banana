import 'package:banana/main/views/main_bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/values/app_colors.dart';
import '../datas/local/tags.dart';

class TagSearchDialog extends StatefulWidget {
  const TagSearchDialog({super.key});

  @override
  State<TagSearchDialog> createState() => _TagSearchDialogState();
}

class _TagSearchDialogState extends State<TagSearchDialog> {
  bool isDark = false;
  final Tags tags = Tags();
  final List<String> selectedTags = [];
  final List<String?> filteredTags = [];
  final int maxSuggestions = 3;
  final String locale = 'ko';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SearchAnchor.bar(
                suggestionsBuilder: (
                  BuildContext context,
                  SearchController controller,
                ) {
                  controller.addListener(() {
                    setState(() {
                      filteredTags.clear();
                      filteredTags.addAll(
                        tags.compareItem(
                          searchQuery: controller.text,
                          number: maxSuggestions,
                          locale: locale,
                        ),
                      );
                    });
                  });

                  return [
                    for (int i = 0; i < filteredTags.length; i++)
                      if (filteredTags[i] != null)
                        ListTile(
                          title: Text(filteredTags[i]!),
                          onTap: () {
                            if (!selectedTags.contains(filteredTags[i]!)) {
                              setState(() {
                                selectedTags.add(filteredTags[i]!);
                                controller.clear();
                              });
                            }
                            controller.closeView(null);
                          },
                        ),
                  ];
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (String? tag in selectedTags)
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Chip(
                        side: BorderSide(color: AppColors.primary),
                        label: Text(tag ?? ''),
                        onDeleted: () {
                          setState(() {
                            selectedTags.remove(tag);
                          });
                        },
                        deleteIconColor: AppColors.primary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              MainBottomButton(
                onPressed: () {
                  Get.back(result: selectedTags);
                },
                text: 'Confirm',
              ),
              const SizedBox(height: 10),
              MainBottomButton(
                onPressed: () {
                  Get.back(result: <String>[]);
                },
                text: "Close",
                textColor: AppColors.gray,
                backgroundColor: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
