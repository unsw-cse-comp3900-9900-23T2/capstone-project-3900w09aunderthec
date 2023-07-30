import 'package:flutter/material.dart';

class Reply extends StatelessWidget {
  Reply({Key? key}) : super(key: key);
  final replyDefaultController =
      TextEditingController(text: "Write something here");

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Divider(),
        // for profile image, name and date of publishing
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 5),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("images/users/guy.jpg"),
                    radius: 16,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(customer.userName),
                      const Text(
                        "Abraham",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: screenWidth * 0.5,
                        child: const Text(
                          "This is the best content every of the reply laolll",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // write your reply
              const SizedBox(height: 17),

              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("images/users/guy.jpg"),
                    radius: 16,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(customer.userName),
                      const SizedBox(height: 10),
                      const Text(
                        "Me",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 0.5 * screenWidth,
                        height: 25,
                        child: const TextField(
                          cursorHeight: 14,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            hintText: "Write something here",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 12),
                            // filled: true,
                          ),
                        ),
                      ),
                      // TextField()
                      // TextField(
                      //   decoration: InputDecoration(
                      //     border: const OutlineInputBorder(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(30.0)),
                      //       borderSide: BorderSide(color: Colors.black),
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(30.0)),
                      //       borderSide: BorderSide(color: Colors.black),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(30.0)),
                      //       borderSide: BorderSide(color: Colors.black),
                      //     ),
                      //     filled: true,
                      //     fillColor: Colors.grey[200],
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
