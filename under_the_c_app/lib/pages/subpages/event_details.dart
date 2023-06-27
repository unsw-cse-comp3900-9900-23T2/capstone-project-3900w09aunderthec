import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/components/common/navigation_bar.dart';
import 'package:under_the_c_app/components/common/price.dart';
import 'package:under_the_c_app/components/common/types/events/event_type.dart';
import 'package:under_the_c_app/components/functions/time/time_converter.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:under_the_c_app/components/providers/event_providers.dart';
import 'package:under_the_c_app/pages/main_pages/home.dart';

class EventDetailsPage extends ConsumerWidget {
  final String eventId;
  const EventDetailsPage({
    required this.eventId,
    Key? key,
  }) : super(key: key);

  // fetch

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventProvider(eventId));
    return event.when(
        data: (event) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: null,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.go('/home'),
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        event.imageUrl,
                        fit: BoxFit.cover,
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 30, bottom: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.6),
                              ),
                              const SizedBox(height: 8),
                              PriceTag(
                                price: event.price,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${getFirstThreeLettersWeekday(event.time)} ${getMonthName(event.time)} ${getDay(event.time)} ${getYear(event.time)} at ${getTime(event.time)}',
                                style: const TextStyle(
                                    fontSize: 12, letterSpacing: 0.2),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(221, 147, 147, 147),
                        height: 20,
                        thickness: 1,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 4, left: 30, bottom: 4, right: 30),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 14),
                                  child: Text(
                                    "EVENT DETAILS",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(221, 5, 5, 5),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                event.description,
                                style: const TextStyle(
                                    letterSpacing: 0.5,
                                    wordSpacing: 0.5,
                                    height: 1.2),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        print("Button clicked");
                      },
                      style: TextButton.styleFrom(
                        minimumSize: const Size(150, 0),
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text("Buy Ticket"),
                    ),
                  ),
                ),
              ],
            ),
            // bottomNavigationBar: const NavigationBarCustom(),
          );
        },
        error: (err, stack) => Text("Error: $err"),
        loading: () => const CircularProgressIndicator());
  }
}
