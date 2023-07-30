import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../types/tickets/tickets_type.dart';
import 'book_ticket.dart';
import 'package:under_the_c_app/config/session_variables.dart';

class DisplayedTicket extends ConsumerStatefulWidget {
  final Tickets item;
  double originalPrice = 0.0;
  double discountedPrice = 0.0;

  DisplayedTicket({
    Key? key,
    required this.item,
  }) : super(key: key) {
    originalPrice = item.price;

    // set the price of tickets based on VIP Level
    double discount = 1;
    final vipLevel = sessionVariables.vipLevel;
    if (vipLevel >= 10 && vipLevel < 15) {
      discount = 0.95;
    } else if (vipLevel >= 15 && vipLevel < 20) {
      discount = 0.9;
    } else if (vipLevel >= 20) {
      discount = 0.85;
    }

    discountedPrice = item.price * discount;
  }

  @override
  _DisplayedTicket createState() => _DisplayedTicket();
}

class _DisplayedTicket extends ConsumerState<DisplayedTicket> {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(selectedTicketsProvider)[item.ticketId] ?? 0;

    void updateQuantity(int value) {
      ref.read(selectedTicketsProvider.notifier).state = {
        ...ref.read(selectedTicketsProvider.notifier).state,
        item.ticketId: value,
      };
    }

    void updateTotal(double value) {
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
                Row(
                  children: [
                    if (discountedPrice < originalPrice) ...{
                      Text(
                        "\$ ${(discountedPrice).toString()}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "\$ ${(originalPrice).toString()}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    } else
                      Text(
                        "\$ ${(originalPrice).toString()}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
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
                          if (discountedPrice < originalPrice) {
                            updateTotal(0 - discountedPrice);
                          } else {
                            updateTotal(0 - originalPrice);
                          }
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
                        if (discountedPrice < originalPrice) {
                          updateTotal(discountedPrice);
                        } else {
                          updateTotal(originalPrice);
                        }
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
