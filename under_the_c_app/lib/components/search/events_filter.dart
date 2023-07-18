import 'dart:collection';
import 'dart:ffi';

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

  @override
  void initState() {
    super.initState();
    generateFilterList();
  }

  @override
  void toggleSortTag() {
    setState(() {
      sortTagSelected = !sortTagSelected;

      // for recency, popularity and price only
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
        name: 'Recency',
        icon: const Icon(Icons.timelapse_outlined),
        value: EventSortType.recency,
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
      ),
      FilterItem(
        name: 'Arts',
        icon: const Icon(Icons.draw),
        value: EventFilterType.arts,
        selected: false,
      ),
      FilterItem(
        name: 'Business',
        icon: const Icon(Icons.business),
        value: EventFilterType.business,
        selected: false,
      ),
      FilterItem(
        name: 'Comedy',
        icon: const Icon(Icons.theater_comedy),
        value: EventFilterType.comedy,
        selected: false,
      ),
      FilterItem(
        name: 'Food & Drink',
        icon: const Icon(Icons.food_bank),
        value: EventFilterType.foodDrink,
        selected: false,
      ),
      FilterItem(
        name: 'Fashion',
        icon: const Icon(Icons.girl),
        value: EventFilterType.fashion,
        selected: false,
      ),
      FilterItem(
        name: 'Music',
        icon: const Icon(Icons.music_note),
        value: EventFilterType.music,
        selected: false,
      ),
      FilterItem(
        name: 'Sport',
        icon: const Icon(Icons.sports),
        value: EventFilterType.sport,
        selected: false,
      ),
      FilterItem(
        name: 'Science',
        icon: const Icon(Icons.science),
        value: EventFilterType.science,
        selected: false,
      ),
      FilterItem(
        name: 'Others',
        icon: const Icon(Icons.collections),
        value: EventFilterType.others,
        selected: false,
      ),
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
              // for the sorting tags "recency, popularity, price"
              if (index <= 2) {
                // when not selected, and then click, it causes sort
                if (!filterItem.selected) {
                  ref.read(eventsProvider.notifier).sort(filterItem.value);
                } else {
                  // else, unsort
                  ref.read(eventsProvider.notifier).reset();
                }
                toggleSortTag();
              } else {}
            },
            style: ButtonStyle(
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
