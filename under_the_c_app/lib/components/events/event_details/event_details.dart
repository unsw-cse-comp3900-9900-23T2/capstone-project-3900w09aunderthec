import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/api/user_request.dart';
import 'package:under_the_c_app/components/events/event_details/comment/comment.dart';
import 'package:under_the_c_app/components/events/event_details/price.dart';
import 'package:under_the_c_app/components/events/event_title.dart';
import 'package:under_the_c_app/components/events/slim_button.dart';
import 'package:under_the_c_app/components/functions/time/time_converter.dart';
import 'package:under_the_c_app/config/routes/routes.dart';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:under_the_c_app/providers/analytics_providers.dart';
import 'package:under_the_c_app/providers/comment_providers.dart';
import 'package:under_the_c_app/providers/event_providers.dart';
import 'package:under_the_c_app/providers/user_providers.dart';

import '../../../types/events/event_type.dart';
import 'event_likes.dart';

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
          // print(event.title);
          // when the widget finished building
          Future(() {
            // record the event hoster uid for the comment pin
            ref.read(hostUidProvider.notifier).state = event.hostuid;

            // record the comment id for pin
            ref.read(eventIdProvider.notifier).state = event.eventId!;
          });
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus!.unfocus();
              }
            },
            child: Scaffold(
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: null,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      context.go(AppRoutes.home);
                      sessionVariables.navLocation = 1;
                    }),
              ),
              body: Stack(
                children: [
                  // using SingleChildScrollView to support the later nested ListView for lazy loading
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              event.imageUrl,
                              fit: BoxFit.cover,
                              height: 400,
                              width: MediaQuery.of(context).size.width,
                            ),
                            sessionVariables.sessionIsHost == false
                                ? Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: EventLikes(
                                      countLikes: event.rating!,
                                      eventId: event.eventId!,
                                    ))
                                : Container()
                          ],
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    EventTitle(title: event.title),
                                    sessionVariables.uid.toString() ==
                                            event.hostuid
                                        ? Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    context.go(
                                                        AppRoutes.eventModify(
                                                            event.eventId!));
                                                  },
                                                  icon: const Icon(Icons.edit)),
                                              IconButton(
                                                  onPressed: () {
                                                    showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                        title: const Text(
                                                            'Delete Event'),
                                                        content: const Text(
                                                            'Are you sure?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancel'),
                                                            child: const Text(
                                                                'Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              ref
                                                                  .read(eventsProvider
                                                                      .notifier)
                                                                  .removeEvent(
                                                                    Event(
                                                                      hostuid: sessionVariables
                                                                          .uid
                                                                          .toString(),
                                                                      eventId: event
                                                                          .eventId,
                                                                      title: event
                                                                          .title,
                                                                      venue: event
                                                                          .venue,
                                                                      time: event
                                                                          .time,
                                                                      price: event
                                                                          .price,
                                                                    ),
                                                                  );
                                                              final uid =
                                                                  sessionVariables
                                                                      .uid
                                                                      .toString();
                                                              ref
                                                                  .read(eventsProvider
                                                                      .notifier)
                                                                  .fetchEvents;
                                                              ref
                                                                  .read(eventsByUserProvider(
                                                                          uid)
                                                                      .notifier)
                                                                  .fetchEvents(
                                                                      uid);

                                                              context.go(
                                                                  AppRoutes
                                                                      .home);
                                                            },
                                                            child: const Text(
                                                                'OK'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete)),
                                            ],
                                          )
                                        : Container(),
                                  ],
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
                                ),
                                const SizedBox(height: 10),
                                if (sessionVariables.sessionIsHost &&
                                    sessionVariables.navLocation == 0)
                                  SlimButton(
                                    text: "Send Notification",
                                    onPressed: () {
                                      context
                                          .go(AppRoutes.notification(eventId));
                                    },
                                  ),
                                if (!sessionVariables.sessionIsHost)
                                  SlimButton(
                                    text: "Subscribe",
                                    onPressed: () {
                                      // perform api request
                                      subscribeHost(int.parse(event.hostuid));

                                      // update for the analytics page
                                      ref
                                          .read(subscribersProvider(
                                                  sessionVariables.uid
                                                      .toString())
                                              .notifier)
                                          .fetch();
                                      ref
                                          .read(
                                              percentageBeatenBySubscribersProvider(
                                                      sessionVariables.uid
                                                          .toString())
                                                  .notifier)
                                          .fetch();

                                      // notify user of subscription on the frontend
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Subscribed!'),
                                            content: Text(
                                                'You have just subscribed to Host: ${event.hostuid} Click on the subscribe button again to unsubscribe'),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // white space
                        const Divider(
                          color: Color.fromARGB(221, 147, 147, 147),
                          height: 10,
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
                              const SizedBox(height: 50)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton(
                              onPressed: () {
                                ref
                                    .read(eventsProvider.notifier)
                                    .fetchEvents(eventId: eventId);
                                context.go(AppRoutes.home);
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(130, 0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text('Similar Events'),
                            ),
                          ),
                        ),
                        // comment section
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Column(
                            children: [
                              Comment(eventId: event.eventId),
                              const SizedBox(height: 250),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // viewInsets.bottom gives that height of the area of the screen not covered by the system UI, here it's
                      // due to the keyboard being visible
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? 0
                          : 120,
                      padding: const EdgeInsets.all(30),
                      child: ElevatedButton(
                        onPressed: () {
                          if (sessionVariables.sessionIsHost &&
                              sessionVariables.navLocation == 0) {
                            context.go(AppRoutes.ticketCreate(event.eventId!));
                          } else if (!sessionVariables.sessionIsHost) {
                            context.go(AppRoutes.eventBook(
                                event.eventId!, event.title, event.venue));
                          } else if (sessionVariables.sessionIsHost &&
                              sessionVariables.navLocation == 1) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Unavailable!'),
                                  content: const Text(
                                      'Hosts cannot purchase tickets for events'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size(150, 0),
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(sessionVariables.sessionIsHost &&
                                sessionVariables.navLocation == 0
                            ? "Create Tickets"
                            : "Buy Tickets"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (err, stack) => Text("Error: $err"),
        loading: () => const CircularProgressIndicator());
  }
}
