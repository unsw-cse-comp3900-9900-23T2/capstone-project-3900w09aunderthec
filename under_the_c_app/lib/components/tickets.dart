import 'package:flutter/material.dart';

final priceTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

class TicketRoute extends StatelessWidget {
  const TicketRoute({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Tickets"),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(
                16.0, kToolbarHeight + 40.0, 16.0, 16.0),
            children: [
              Text(
                "Choose your tickets",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              TicketTypes(
                item: Tickets(
                  type: "General Admission",
                  price: 45,
                  qty: 0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TicketTypes(
                item: Tickets(
                  type: "VIP",
                  price: 20,
                  qty: 1,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              _buildDivider(),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Total Price",
                    style: priceTextStyle.copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  Text("\$",
                      style: priceTextStyle.copyWith(color: Colors.black)),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              _buildDivider(),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ElevatedButton(
                  // style: ButtonStyle(
                  //     padding: EdgeInsets.all(16.0),
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(20.0))),
                  onPressed: () {},
                  child: Text("Purchase"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Container _buildDivider() {
  return Container(
    height: 2.0,
    width: double.maxFinite,
    decoration: BoxDecoration(
        color: Colors.grey, borderRadius: BorderRadius.circular(5.0)),
  );
}

class Tickets {
  final String type;
  int price;
  int qty;

  Tickets({required this.type, required this.price, required this.qty});
}

class TicketTypes extends StatelessWidget {
  final Tickets item;

  const TicketTypes({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          // Get rid of this
          // Column, type, price, sale end
          Container(
            width: 100,
            height: 100,
            // child: Text("\$ 45"),
            // Text("Sales end on Date - 1 day"),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.type,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
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
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        // setState(() {
                        //   widget.item.qty--;
                        // }
                        // );
                      },
                    ),
                    Text(
                      "${item.qty}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      iconSize: 14.0,
                      padding: const EdgeInsets.all(2.0),
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // setState(() {
                        //   widget.item.qty++;
                        // }
                        // );
                      },
                    ),
                  ]),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text("\$${item.price * item.qty}", style: priceTextStyle),
        ],
      ),
    );
  }
}
