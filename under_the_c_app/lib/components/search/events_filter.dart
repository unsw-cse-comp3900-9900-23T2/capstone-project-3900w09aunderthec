import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/providers/event_providers.dart';
import 'package:under_the_c_app/types/search/filter_type.dart';

class EventsFilter extends ConsumerWidget {
  EventsFilter({Key? key}) : super(key: key);

  final List<FilterItem> filterList = [
    FilterItem(
        name: 'Recency',
        icon: const Icon(Icons.timelapse_outlined),
        value: EventSortType.recency),
    FilterItem(
        name: 'Popularity',
        icon: const Icon(Icons.favorite),
        value: EventSortType.popularity),
    FilterItem(
        name: 'Price',
        icon: const Icon(Icons.currency_yuan),
        value: EventSortType.price),
    FilterItem(
        name: 'Arts',
        icon: const Icon(Icons.draw),
        value: EventFilterType.arts),
    FilterItem(
        name: 'Business',
        icon: const Icon(Icons.business),
        value: EventFilterType.business),
    FilterItem(
        name: 'Comedy',
        icon: const Icon(Icons.theater_comedy),
        value: EventFilterType.comedy),
    FilterItem(
        name: 'Food & Drink',
        icon: const Icon(Icons.food_bank),
        value: EventFilterType.foodDrink),
    FilterItem(
        name: 'Fashion',
        icon: const Icon(Icons.girl),
        value: EventFilterType.fashion),
    FilterItem(
        name: 'Music',
        icon: const Icon(Icons.music_note),
        value: EventFilterType.music),
    FilterItem(
        name: 'Sport',
        icon: const Icon(Icons.sports),
        value: EventFilterType.sport),
    FilterItem(
        name: 'Science',
        icon: const Icon(Icons.science),
        value: EventFilterType.science),
    FilterItem(
        name: 'Others',
        icon: const Icon(Icons.collections),
        value: EventFilterType.others),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: filterList.length,
      itemBuilder: (context, index) {
        final filterItem = filterList[index];
        return Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: ElevatedButton(
            onPressed: () {
              final currState = ref.read(eventSortTypeProvider.notifier).state;
              ref.read(eventSortTypeProvider.notifier).state = EventSortState(
                  sortType: filterItem.value, isSorted: !currState.isSorted);
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
