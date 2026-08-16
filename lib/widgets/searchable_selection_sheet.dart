import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../res/color.dart';
import '../widgets/text.widgets/text.dart';

class SearchableSelectionSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T item) itemAsString;
  final String Function(T item)? itemAsSecondaryString;
  final T? selectedItem;
  final String? searchHint;
  final ValueChanged<T> onSelected;

  const SearchableSelectionSheet({
    super.key,
    required this.title,
    required this.items,
    required this.itemAsString,
    this.itemAsSecondaryString,
    this.selectedItem,
    this.searchHint,
    required this.onSelected,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T item) itemAsString,
    String Function(T item)? itemAsSecondaryString,
    T? selectedItem,
    String? searchHint,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SearchableSelectionSheet<T>(
          title: title,
          items: items,
          itemAsString: itemAsString,
          itemAsSecondaryString: itemAsSecondaryString,
          selectedItem: selectedItem,
          searchHint: searchHint,
          onSelected: (selected) {
            Navigator.pop(context, selected);
          },
        );
      },
    );
  }

  @override
  State<SearchableSelectionSheet<T>> createState() =>
      _SearchableSelectionSheetState<T>();
}

class _SearchableSelectionSheetState<T>
    extends State<SearchableSelectionSheet<T>> {
  late TextEditingController _searchController;
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = List.from(widget.items);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredItems = List.from(widget.items);
      } else {
        final q = query.trim().toLowerCase();
        _filteredItems = widget.items.where((item) {
          final primary = widget.itemAsString(item).toLowerCase();
          final secondary = widget.itemAsSecondaryString != null
              ? widget.itemAsSecondaryString!(item).toLowerCase()
              : '';
          return primary.contains(q) || secondary.contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final screenHeight = mediaQuery.size.height;
    final maxHeight = screenHeight * 0.75;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      margin: EdgeInsets.only(bottom: keyboardHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            // Drag handle indicator
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            // Header: Title & Close Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SubHeadingText(
                      widget.title,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Remix.close_line, color: AppColor.darkBlackColor),
                  ),
                ],
              ),
            ),
            // Search Input Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: widget.searchHint ?? 'Search...',
                  prefixIcon: const Icon(Remix.search_line, color: AppColor.iconColor),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Remix.close_circle_fill, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.extraDark, width: 1.5),
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            // Items List
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: BaseText(
                          title: 'No results found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _filteredItems.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFEEEEEE),
                      ),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final primaryText = widget.itemAsString(item);
                        final secondaryText = widget.itemAsSecondaryString != null
                            ? widget.itemAsSecondaryString!(item)
                            : null;
                        final isSelected = widget.selectedItem == item;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          title: BaseText(
                            title: primaryText,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColor.extraDark : AppColor.darkBlackColor,
                            ),
                          ),
                          subtitle: (secondaryText != null && secondaryText != primaryText)
                              ? BaseText(
                                  title: secondaryText,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                )
                              : null,
                          trailing: isSelected
                              ? const Icon(
                                  Remix.check_line,
                                  color: AppColor.extraDark,
                                )
                              : null,
                          onTap: () => widget.onSelected(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
