import 'package:flutter/material.dart';
import 'package:under_the_c_app/types/search/filter_type.dart';

class EventsFilter extends StatelessWidget {
  EventsFilter({Key? key}) : super(key: key);

  final List<FilterItem> filterList = [
    FilterItem(name: 'Recency', icon: const Icon(Icons.timelapse_outlined)),
    FilterItem(name: 'Popularity', icon: const Icon(Icons.favorite)),
    FilterItem(name: 'price', icon: const Icon(Icons.currency_yuan)),
    FilterItem(name: 'Arts', icon: const Icon(Icons.draw)),
    FilterItem(name: 'Business', icon: const Icon(Icons.business)),
    FilterItem(name: 'Comedy', icon: const Icon(Icons.theater_comedy)),
    FilterItem(name: 'Food & Drink', icon: const Icon(Icons.food_bank)),
    FilterItem(name: 'Fashion', icon: const Icon(Icons.girl)),
    FilterItem(name: 'Music', icon: const Icon(Icons.music_note)),
    FilterItem(name: 'Sport', icon: const Icon(Icons.sports)),
    FilterItem(name: 'Science', icon: const Icon(Icons.science)),
    FilterItem(name: 'Others', icon: const Icon(Icons.collections)),
  ];

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
            onPressed: () => {},
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
