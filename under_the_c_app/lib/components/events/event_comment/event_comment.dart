import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../config/routes/routes.dart';

// class CommentSection extends ConsumerWidget {
//   const CommentSection({Key? key, required String eventId}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final events = ref.watch(eventsProvider);

//     return Container(
//       color: const Color.fromARGB(255, 255, 255, 255),
//       alignment: Alignment.center,
//       padding: const EdgeInsets.all(15),
//       child: CustomScrollView(
//         slivers: <Widget>[
//           const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 12, left: 4),
//               child: Title(
//                 color: const Color.fromARGB(255, 255, 255, 255),
//                 child: const Text(
//                   "Upcoming Events",
//                   style: TextStyle(
//                     fontSize: 23,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 42, 23, 120),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           const SliverToBoxAdapter(
//             child: SizedBox(
//               height: 13, // Modify this to adjust the size of the space
//             ),
//           ),
//           // for list of event cards
//           SliverList(
//             delegate: SliverChildBuilderDelegate((context, index) {
//               final event = events[index];
//               return SizedBox(
//                 width: 375,
//                 child: GestureDetector(
//                   onTap: () {
//                     context.go(AppRoutes.eventDetails(event.eventId!),
//                         extra: 'Details');
//                   },
//                   child: Padding(
//                       padding: const EdgeInsets.only(bottom: 8),
//                       child: SizedBox(
//                         height: 100,
//                         child: Text("Placeholder"),
//                       )),
//                 ),
//               );
//             }, childCount: events.length),
//           )
//         ],
//       ),
//     );
//   }
// }

class CommentSection extends StatefulWidget {
  final String eventId;
  const CommentSection({
    required this.eventId,
    Key? key,
  }) : super(key: key);

  @override
  CommentSectionState createState() {
    return CommentSectionState();
  }
}

class CommentSectionState extends State<CommentSection> {
  double starRating = 0;
  List<String> comments = [];
  final commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void addComment(String comment) {
    setState(() {
      comments.add(comment);
      // comments.insert(0, comment);
    });
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AppBar(
            title: null,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context
                  .go(AppRoutes.eventDetails(widget.eventId), extra: "Details"),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              addComment("comment");
            },
            child: const Text("Add"),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            // color: Colors.grey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      starRating = rating;
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            addComment(commentController.text);
                            commentController.clear();
                          },
                          icon: Icon(Icons.send),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'Comment',
                      ),
                      controller: commentController,
                      maxLines: 3,
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              // reverse: true,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final reversedIndex =
                    comments.length - 1 - index; // Reverse the index
                return Container(
                  alignment: Alignment.center,
                  color: Colors.blue,
                  height: 50,
                  child: Text(
                      'Comment: ${comments[reversedIndex]} $reversedIndex'),
                );
              },
            ),
          ),
          // Container(
          //   alignment: Alignment.bottomCenter,
          //   // color: Colors.grey,
          //   child: SingleChildScrollView(
          //     padding: EdgeInsets.only(
          //         bottom: MediaQuery.of(context).viewInsets.bottom),
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Divider(),
          //         RatingBar.builder(
          //           initialRating: 3,
          //           minRating: 0,
          //           direction: Axis.horizontal,
          //           allowHalfRating: true,
          //           itemCount: 5,
          //           itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          //           itemBuilder: (context, _) => Icon(
          //             Icons.star,
          //             color: Colors.amber,
          //           ),
          //           onRatingUpdate: (rating) {
          //             starRating = rating;
          //           },
          //         ),
          //         SizedBox(
          //           width: MediaQuery.of(context).size.width * 0.75,
          //           child: TextField(
          //             decoration: InputDecoration(
          //               suffixIcon: IconButton(
          //                 onPressed: () {
          //                   addComment(commentController.text);
          //                   commentController.clear();
          //                 },
          //                 icon: Icon(Icons.send),
          //               ),
          //               border: OutlineInputBorder(),
          //               hintText: 'Comment',
          //             ),
          //             controller: commentController,
          //             maxLines: 3,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     extendBodyBehindAppBar: true,
  //     body: Stack(children: [
  //       SingleChildScrollView(
  //           child: Column(children: [
  //         AppBar(
  //           title: null,
  //           backgroundColor: Colors.transparent,
  //           elevation: 0.0,
  //           leading: IconButton(
  //             icon: const Icon(Icons.arrow_back, color: Colors.black),
  //             onPressed: () => context
  //                 .go(AppRoutes.eventDetails(widget.eventId), extra: "Details"),
  //           ),
  //         ),
  //       ])),
  //       Container(
  //         alignment: Alignment.bottomCenter,
  //         // color: Colors.grey,
  //         child: SingleChildScrollView(
  //           padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Divider(),
  //               RatingBar.builder(
  //                 initialRating: 3,
  //                 minRating: 0,
  //                 direction: Axis.horizontal,
  //                 allowHalfRating: true,
  //                 itemCount: 5,
  //                 itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
  //                 itemBuilder: (context, _) => Icon(
  //                   Icons.star,
  //                   color: Colors.amber,
  //                 ),
  //                 onRatingUpdate: (rating) {
  //                   starRating = rating;
  //                 },
  //               ),
  //               SizedBox(
  //                 width: MediaQuery.of(context).size.width * 0.75,
  //                 child: TextField(
  //                   decoration: InputDecoration(
  //                     suffixIcon: IconButton(
  //                       onPressed: () {
  //                         addComment(commentController.text);
  //                         commentController.clear();
  //                       },
  //                       icon: Icon(Icons.send),
  //                     ),
  //                     border: OutlineInputBorder(),
  //                     hintText: 'Comment',
  //                   ),
  //                   controller: commentController,
  //                   maxLines: 3,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ]),
  //   );
  // }
}

class Comment {
  final String? commentId;
  final String review;
  final int like;
  final int dislike;
  final String imageUrl;

  Comment({
    String? commentId,
    required this.review,
    required this.like,
    required this.dislike,
    String? imageUrl,
  })  : commentId = commentId ?? "",
        imageUrl = imageUrl ?? "images/events/money-event.jpg";
}
