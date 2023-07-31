import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentFilter extends ConsumerStatefulWidget {
  const CommentFilter({Key? key}) : super(key: key);

  @override
  _CommentFilterState createState() => _CommentFilterState();
}

class _CommentFilterState extends ConsumerState<CommentFilter> {
  bool sortEnabled = false;
  bool filterEnabled = false;

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

  Widget buttonLayout(String content) {
    return ElevatedButton(
      onPressed: () => {},
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
        ),
      ),
      child: Text(
        content,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Widget sort() {
    final sortList = [
      "Popularity",
      "Unpopularity",
    ];
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
