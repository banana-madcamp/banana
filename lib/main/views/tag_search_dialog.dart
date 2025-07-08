import 'package:banana/main/views/main_bottom_button.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

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
  List<String?> _filteredTags = [];
  final int maxSuggestions = 3;
  final String locale = 'ko';
  final SearchController _searchController = SearchController();

  Logger get log => Get.find<Logger>(tag: 'MainLogger');

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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (String? tag in selectedTags)
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Chip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.2,
                        ),
                        side: BorderSide(color: AppColors.primary),
                        label: Text(
                          tag ?? '',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Rubik',
                          ),
                        ),
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
              SearchBar(
                controller: _searchController,
                onChanged: (value) {
                  if (value == "" || value.isEmpty) {
                    return;
                  }
                  log.i('Search query: $value');
                  final filteredTags = tags.compareItem(
                    searchQuery: value,
                    number: maxSuggestions,
                    locale: locale,
                  );
                  log.i('Filtered tags: $filteredTags');

                  setState(() {
                    _filteredTags = filteredTags;
                  });
                },
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(AppIcons.search),
                ),
                trailing: [
                  IconButton(
                    onPressed: () {
                      _searchController.clear();
                    },
                    icon: Icon(AppIcons.close),
                  ),
                ],
              ),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    for (int i = 0; i < _filteredTags.length; i++)
                      if (_filteredTags[i] != null)
                        ListTile(
                          title: Text(_filteredTags[i]!),
                          onTap: () {
                            if (!selectedTags.contains(_filteredTags[i]!)) {
                              setState(() {
                                selectedTags.add(_filteredTags[i]!);
                                _searchController.clear();
                              });
                            }
                          },
                        ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Text('Please tab suggestions to add tags.'),
              const SizedBox(height: 10),
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
