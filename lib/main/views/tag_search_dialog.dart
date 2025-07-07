import 'package:flutter/material.dart';

import '../datas/local/tags.dart';

class TagSearchDialog extends StatefulWidget {
  const TagSearchDialog({super.key});

  @override
  State<TagSearchDialog> createState() => _TagSearchDialogState();
}

class _TagSearchDialogState extends State<TagSearchDialog> {
  bool isDark = false;
  final Tags tags = Tags();
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
          child: SearchAnchor.bar(
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
                        setState(() => controller.closeView(filteredTags[i]!));
                      },
                    ),
              ];
            },
          ),
        ),
      ),
    );
  }
}
