import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/providers/event_providers.dart';
import 'package:under_the_c_app/types/search/filter_type.dart';

class EventsFilter extends ConsumerStatefulWidget {
  EventsFilter({Key? key}) : super(key: key);

  @override
  EventsFilterState createState() => EventsFilterState();
}

class EventsFilterState extends ConsumerState<EventsFilter> {
  bool sortTagSelected = false;
  late List<FilterItem> filterList;
  int? selectedSortTagIndex;

  @override
  void initState() {
    super.initState();
    generateFilterList();
  }

  void toggleSortTag(int index) {
    setState(() {
      selectedSortTagIndex = selectedSortTagIndex == index ? null : index;
      sortTagSelected = !sortTagSelected;

      // for soonness, popularity and price only
      for (var i = 0; i < 3; i++) {
        filterList[i] = FilterItem(
            name: filterList[i].name,
            icon: filterList[i].icon,
            value: filterList[i].value,
            selected: sortTagSelected);
      }
    });
  }

  void generateFilterList() {
    filterList = [
      FilterItem(
        name: 'Soonness',
        icon: const Icon(Icons.timelapse_outlined),
        value: EventSortType.soonness,
        selected: sortTagSelected,
      ),
      FilterItem(
        name: 'Popularity',
        icon: const Icon(Icons.favorite),
        value: EventSortType.popularity,
        selected: sortTagSelected,
      ),
      FilterItem(
        name: 'Price',
        icon: const Icon(Icons.currency_yuan),
        value: EventSortType.price,
        selected: sortTagSelected,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: filterList.length,
      itemBuilder: (context, index) {
        final filterItem = filterList[index];
        return Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: ElevatedButton(
            onPressed: () {
              // for the sorting tags "soonness, popularity, price"
              if (index <= 2) {
                // when not selected, and then click, it causes sort
                if (!filterItem.selected) {
                  ref.read(eventsProvider.notifier).sort(filterItem.value);
                } else {
                  // else, unsort
                  ref.read(eventsProvider.notifier).reset();
                }
                toggleSortTag(index);
              } else {}
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (selectedSortTagIndex == index) {
                    return Color.fromARGB(255, 2, 171, 44);
                  } else {
                    return Colors.purple;
                  }
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: filterItem.icon,
                ),
                const SizedBox(width: 6),
                Text(filterItem.name)
              ],
            ),
          ),
        );
      },
    );
  }
}
