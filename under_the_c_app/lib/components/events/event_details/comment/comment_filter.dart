import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SortItem {
  final String name;
  final int index;
  // final Function function;
  SortItem({required this.name, required this.index});
}

class CommentFilter extends ConsumerStatefulWidget {
  const CommentFilter({Key? key}) : super(key: key);

  @override
  _CommentFilterState createState() => _CommentFilterState();
}

class _CommentFilterState extends ConsumerState<CommentFilter> {
  bool sortEnabled = false;
  bool filterEnabled = false;
  int selectedSortIndex = 0; //default as 0
  List<SortItem> sortList = [
    SortItem(name: "Popularity", index: 1),
    SortItem(name: "Unpopularity", index: 2)
  ];

  @override
  void initState() {
    super.initState();
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

  Widget buttonLayout(SortItem item) {
    return ElevatedButton(
      onPressed: () => {
        setState(() {
          // unselect
          if (selectedSortIndex == item.index) {
            selectedSortIndex = 0;
          }
          // select
          else {
            selectedSortIndex = item.index;
          }
        })
      },
      style: ButtonStyle(
        backgroundColor: item.index == selectedSortIndex
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
    return const Text("Filter");
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
