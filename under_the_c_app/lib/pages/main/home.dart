import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/components/events/event_card.dart';
import 'package:under_the_c_app/components/search/events_filter.dart';
import 'package:under_the_c_app/config/routes/routes.dart';
import 'package:under_the_c_app/providers/event_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publicEvents = ref.watch(eventsProvider);

    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: SearchBar(
              leading: const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Icon(Icons.search),
              ),
              trailing: [
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: IconButton(
                    icon: const Icon(Icons.format_align_left_rounded),
                    onPressed: () => {},
                  ),
                )
              ],
              onChanged: (value) {
                ref.read(eventsProvider.notifier).search(value);
              },
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 4),
              child: Title(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: const Text(
                  "Upcoming Events",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 42, 23, 120),
                  ),
                ),
              ),
            ),
          ),
          // for event filters
          SliverToBoxAdapter(
            child: SizedBox(
              height: 35,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: EventsFilter(),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 13, // Modify this to adjust the size of the space
            ),
          ),
          // for list of event cards
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final event = publicEvents[index];
              return SizedBox(
                width: 375,
                child: GestureDetector(
                  onTap: () {
                    context.go(AppRoutes.eventDetails(event.eventId!),
                        extra: 'Details');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: EventCard(
                      title: event.title,
                      imageUrl: event.imageUrl,
                      time: event.time,
                      venue: event.venue,
                    ),
                  ),
                ),
              );
            }, childCount: publicEvents.length),
          )
        ],
      ),
    );
  }
}
