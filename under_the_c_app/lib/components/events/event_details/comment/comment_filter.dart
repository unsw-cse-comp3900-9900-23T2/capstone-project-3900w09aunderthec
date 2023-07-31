import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/providers/comment_providers.dart';

class SortFilterItem {
  final String name;
  final int index;
  final Function sortFilterFunction;
  SortFilterItem(
      {required this.name,
      required this.index,
      required this.sortFilterFunction});
}

enum SearchType { isFilter, isSort }

class CommentFilter extends ConsumerStatefulWidget {
  final String eventId;
  const CommentFilter({Key? key, required this.eventId}) : super(key: key);

  @override
  _CommentFilterState createState() => _CommentFilterState();
}

class _CommentFilterState extends ConsumerState<CommentFilter> {
  bool sortEnabled = false;
  bool filterEnabled = false;
  int selectedSortFilterIndex = 0; //default as 0
  late List<SortFilterItem> sortList = [];
  late List<SortFilterItem> filterList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sortList = [
      SortFilterItem(
          name: "Popularity",
          index: 1,
          sortFilterFunction: () => ref
              .read(commentsProvider(widget.eventId).notifier)
              .sort(CommentSortQuery.popularity)),
      SortFilterItem(
          name: "Unpopularity",
          index: 2,
          sortFilterFunction: () => ref
              .read(commentsProvider(widget.eventId).notifier)
              .sort(CommentSortQuery.unpopularity))
    ];
    filterList = [
      SortFilterItem(
          name: "Pinned",
          index: 3,
          sortFilterFunction: () => ref
              .read(commentsProvider(widget.eventId).notifier)
              .filter(CommentFilterQuery.pinned)),
      SortFilterItem(
          name: "Unpinned",
          index: 4,
          sortFilterFunction: () => ref
              .read(commentsProvider(widget.eventId).notifier)
              .filter(CommentFilterQuery.unpinned))
    ];
  }

  void toggleSort() {
    setState(() {
      sortEnabled = !sortEnabled;
      filterEnabled = false;
    });
  }

  void toggleFilter() {
    setState(() {
      filterEnabled = !filterEnabled;
      sortEnabled = false;
    });
  }

  Widget buttonLayout(SortFilterItem item ) {
    return ElevatedButton(
      onPressed: () => {
        setState(() {
          // unselect
          if (selectedSortFilterIndex == item.index) {
            selectedSortFilterIndex = 0;
            // undo sort
            ref.read(commentsProvider(widget.eventId).notifier).undoSortFilter();
            // undo filter
          }
          // select
          else {
            selectedSortFilterIndex = item.index;
            // call sort
            item.sortFilterFunction();
          }
        })
      },
      style: ButtonStyle(
        backgroundColor: item.index == selectedSortFilterIndex
            ? MaterialStateProperty.all<Color>(Color.fromARGB(255, 2, 171, 44))
            : MaterialStateProperty.all<Color>(Colors.purple),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
        ),
      ),
      child: Text(
        item.name,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  /*
   * Sort
   */

  Widget sort() {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 10,
        alignment: WrapAlignment.start,
        children: [
          ...sortList.map((item) => buttonLayout(item)).toList(),
        ],
      ),
    );
  }

  Widget filter() {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 10,
        alignment: WrapAlignment.start,
        children: [
          ...filterList.map((item) => buttonLayout(item)).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () => {toggleSort()},
              icon: Icon(
                Icons.manage_search_outlined,
                size: 25,
                color: Colors.grey[600],
              ),
            ),
            IconButton(
              onPressed: () => {toggleFilter()},
              icon: Icon(
                Icons.filter_list,
                size: 25,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        // display sort and filter buttons
        sortEnabled ? sort() : Container(),
        filterEnabled ? filter() : Container(),
      ],
    );
  }
}
