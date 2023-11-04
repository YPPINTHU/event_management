import 'package:campbelldecor/screens/bookings_screens/date_view.dart';
import 'package:campbelldecor/screens/events_screen/religion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../reusable/reusable_methods.dart';
import '../../reusable/reusable_widgets.dart';
import '../../utils/color_util.dart';

// Future<void> dataPre() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
// }
// Retrieving data from shared preferences

class EventsScreen extends StatelessWidget {
  final CollectionReference _events =
      FirebaseFirestore.instance.collection('events');

  @override
  Widget build(BuildContext context) {
    print(_events.toString());
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "Events ",
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringtoColor("CB2893"),
              hexStringtoColor("9546C4"),
              hexStringtoColor("5E61F4")
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _events.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return LimitedBox(
                        maxHeight: 720,
                        child: ListView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(50, 10, 50, 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 10,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (documentSnapshot['name'] ==
                                          'Wedding') {
                                        Navigation(
                                            context, ReligionSelectScreen());
                                      } else {
                                        SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();
                                        preferences.setString(
                                            'event', documentSnapshot['name']);
                                        Navigation(context, CalendarScreen());
                                      }
                                    },
                                    child: Container(
                                      height: 180,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            documentSnapshot['imgURL'],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: ListTile(
                                              //----------------------Text Container background ----------------------//

                                              title: Container(
                                                height: 70,
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                                //----------------------Text Editings----------------------//
                                                child: Text(
                                                  documentSnapshot['name'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              // onTap: () async {
                                              //   if (documentSnapshot['name'] ==
                                              //       'Wedding') {
                                              //     Navigation(context,
                                              //         ReligionSelectScreen());
                                              //   } else {
                                              //     SharedPreferences preferences =
                                              //         await SharedPreferences
                                              //             .getInstance();
                                              //     preferences.setString('event',
                                              //         documentSnapshot['name']);
                                              //     Navigation(
                                              //         context, CalendarScreen());
                                              //   }
                                              // },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // ),
                              );
                            }),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                // IconButton(
                //   onPressed: () {
                //     Navigation(context, UserEventsCreationScreen());
                //   },
                //   icon: Icon(LineAwesomeIcons.plus_circle),
                //   iconSize: 45,
                //   color: Colors.pink,
                // )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottom_Bar(context),
    );
  }
}
