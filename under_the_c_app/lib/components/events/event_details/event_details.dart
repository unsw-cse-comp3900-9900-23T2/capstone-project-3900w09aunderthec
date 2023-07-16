import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/components/events/event_details/comment.dart';
import 'package:under_the_c_app/components/events/event_details/price.dart';
import 'package:under_the_c_app/components/functions/time/time_converter.dart';
import 'package:under_the_c_app/config/routes/routes.dart';
import 'package:under_the_c_app/providers/event_providers.dart';

class EventDetailsPage extends ConsumerWidget {
  final String eventId;
  const EventDetailsPage({
    required this.eventId,
    Key? key,
  }) : super(key: key);

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
                onPressed: () => context.go(AppRoutes.home),
              ),
            ),
            body: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.only(top: 0),
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          event.imageUrl,
                          fit: BoxFit.cover,
                          height: 400,
                          width: MediaQuery.of(context).size.width,
                        ),
                        // Title, price, date section
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
                        // white space
                        const Divider(
                          color: Color.fromARGB(221, 147, 147, 147),
                          height: 20,
                          thickness: 1,
                        ),
                        // Event detail section
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 4, left: 25, bottom: 4, right: 25),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 14),
                                  child: Text(
                                    "About event",
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
                              const SizedBox(height: 100)
                            ],
                          ),
                        ),
                        // comment section
                        const Padding(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          child: Column(
                            children: [Comment(), SizedBox(height: 125)],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // viewInsets.bottom gives that height of the area of the screen not covered by the system UI, here it's
                    // due to the keyboard being visible
                    height:
                        MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 120,
                    padding: const EdgeInsets.all(30),
                    child: ElevatedButton(
                      onPressed: () {
                        context.go(AppRoutes.eventBook(event.eventId!));
                      },
                      style: TextButton.styleFrom(
                        minimumSize: const Size(200, 0),
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
          );
        },
        error: (err, stack) => Text("Error: $err"),
        loading: () => const CircularProgressIndicator());
  }
}
