import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../types/tickets/tickets_type.dart';
import 'book_ticket.dart';

class DisplayedTicket extends ConsumerWidget {
  final Tickets item;

  DisplayedTicket({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(selectedTicketsProvider)[item.ticketId] ?? 0;

    void updateQuantity(int value) {
      ref.read(selectedTicketsProvider.notifier).state = {
        ...ref.read(selectedTicketsProvider.notifier).state,
        item.ticketId: value,
      };
    }

    void updateTotal(int value) {
      ref.read(totalPriceProvider.notifier).state += value;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$ ${(item.price).toString()}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  height: 40.0,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      iconSize: 14.0,
                      padding: const EdgeInsets.all(2.0),
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 0) {
                          updateQuantity(quantity - 1);
                          updateTotal(0 - item.price.toInt());
                        }
                      },
                    ),
                    Text(
                      "$quantity",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      iconSize: 14.0,
                      padding: const EdgeInsets.all(2.0),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        updateQuantity(quantity + 1);
                        updateTotal(item.price.toInt());
                      },
                    ),
                  ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
