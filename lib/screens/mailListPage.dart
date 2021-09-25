import 'package:easy_mail_app_frontend/shared_widgets/AppBar.dart';
import 'package:easy_mail_app_frontend/shared_widgets/postManDrawer.dart';
import 'package:easy_mail_app_frontend/shared_widgets/searchBox.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:easy_mail_app_frontend/controller/postManController.dart';
import 'package:easy_mail_app_frontend/controller/appBinding.dart';
import 'package:easy_mail_app_frontend/model/mailModel.Dart';

class MailListPage extends StatefulWidget {
  MailListPage({Key? key}) : super(key: key);
  static const String route = '/postMan/mailList';

  @override
  _MailListPageState createState() => _MailListPageState();
}

class _MailListPageState extends State<MailListPage> {
  var _searchController = FloatingSearchBarController();
  final postManController = new PostManController();
  var searchResult = '';
  bool isLoading = false;
  bool isSearched = false;
  bool isTouched = false;

  var selectedMail = <MailModel>[].obs;
  @override
  void initState() {
    // TODO: implement initState

    getMailsList("default");
    super.initState();
  }

  //List mails = ["mail1", "mail2", "mail3"];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: postmanAppBar(context),
        drawer: postManDrawer(context),
        body: Container(
          color: Color(0xFFE0FAEA),
          child: Column(
            children: <Widget>[
              Expanded(
                child: tileList(),
              ),
              Expanded(child: mailDetail()),
            ],
          ),
        ),
      ),
    );
  }

  Widget mailDetail() {
    setState(() {
      //String result = getResult();
      //print(result);
    });
    return Expanded(
      child: isLoading
          ? Center(
              child: Column(
                children: [
                  Text("Loading data.."),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : Obx(() {
              if (isLoading) {
                return Text('Loading');
              } else if (selectedMail.length == 0) {
                return Text('Select a Mail to Show details');
              } else {
                return ListView.builder(
                  itemCount: selectedMail.length,
                  itemBuilder: (context, index) {
                    return Container(
                        child: Column(
                      children: [
                        Container(
                            width: 100,
                            child: Text(selectedMail[0].receiverID.toString())),
                        Container(
                            width: 100,
                            child: Text(selectedMail[0].addressID.toString())),
                        Container(
                            width: 100,
                            child: Text(selectedMail[0].senderID.toString())),
                        Container(
                            width: 100,
                            child:
                                Text(selectedMail[0].isDelivered.toString())),
                        IconButton(
                            tooltip: "Deliver",
                            icon: Icon(Icons.check),
                            color: Colors.black,
                            hoverColor: Colors.white,
                            onPressed: () {
                              deliverMail(
                                  postManController.mails[index].mailID);
                            }),
                        IconButton(
                            tooltip: "Cancelled",
                            icon: Icon(Icons.block),
                            color: Colors.black,
                            hoverColor: Colors.white,
                            onPressed: () {
                              //banEvent(event.eventID);
                            }),
                      ],
                    ));
                  },
                );
              }
            }),
    );
  }

  // Widget searchBox(BuildContext context) {
  //   final isPortrait =
  //       MediaQuery.of(context).orientation == Orientation.portrait;

  //   return FloatingSearchBar(
  //     hint: 'Search...',
  //     scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
  //     transitionDuration: const Duration(milliseconds: 200),
  //     controller: _searchController,
  //     transitionCurve: Curves.easeInOut,
  //     physics: const BouncingScrollPhysics(),
  //     axisAlignment: isPortrait ? 0.0 : -1.0,
  //     openAxisAlignment: 0.0,
  //     width: isPortrait ? 600 : 500,
  //     debounceDelay: const Duration(milliseconds: 200),
  //     onQueryChanged: (query) {
  //       print(query);
  //     },
  //     // Specify a custom transition to be used for
  //     // animating between opened and closed stated.
  //     transition: CircularFloatingSearchBarTransition(),
  //     actions: [
  //       FloatingSearchBarAction(
  //         showIfOpened: true,
  //         child: CircularButton(
  //           icon: const Icon(Icons.mail),
  //           onPressed: () {
  //             setState(() {
  //               searchResult = _searchController.query.toString();
  //               isSearched = true;
  //               print(searchResult);
  //             });
  //           },
  //         ),
  //       ),
  //       FloatingSearchBarAction.searchToClear(
  //         showIfClosed: false,
  //       ),
  //     ],
  //     builder: (context, transition) {
  //       return ClipRRect(
  //         borderRadius: BorderRadius.circular(20),
  //         child: Material(
  //           color: Colors.white,
  //           elevation: 4.0,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: postManController.mails.map((mail) {
  //               return Container(
  //                 height: 50,
  //                 child: ListTile(
  //                   title: Text(mail.toString()),
  //                   onTap: () {
  //                     tapped(
  //                       mail.toString(),
  //                     );
  //                     print(mail.toString());
  //                   },
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget tileList() {
    return Expanded(
      child: isLoading
          ? Center(
              child: Column(
                children: [
                  Text("Loading data.."),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : Obx(() {
              if (isLoading) {
                return Text('Loading');
              } else if (postManController.mails.isEmpty) {
                return Text('Empty List');
              } else {
                return ListView.builder(
                  itemCount: postManController.mails.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: tagCard(
                          context, postManController.mails.value[index], index),
                    );
                  },
                );
              }
            }),
    );
  }

  Widget tagCard(BuildContext context, MailModel mail, int index) {
    return Container(
      height: 40,
      color: Colors.greenAccent,
      child: Row(
        children: [
          // ListTile(
          //   title: Text(mail.mailID.toString()),
          //   onTap: () {
          //     tapped(
          //       mail.mailID.toString(),
          //     );
          //     print(mail.mailID.toString());
          //   },
          // ),
          Container(width: 100, child: Text(mail.mailID)),
          // Container(width: 100, child: Text(mail.isDelivered.toString())),
          // Container(width: 100, child: Text(mail.addressID.toString())),
          // Container(width: 100, child: Text(mail.receiverID.toString())),
          // // Container(width: 100, child: Text(tag.subscriber.toString())),
          // SizedBox(),
          IconButton(
              tooltip: "view",
              icon: Icon(Icons.check_circle),
              color: Colors.black,
              hoverColor: Colors.white,
              onPressed: () {
                isTouched = true;
                selectedMail.add(postManController.mails.value[index]);
                //acceptEvent(event.eventID, index);
              }),
          // SizedBox(
          //   width: 20,
          // ),
          // IconButton(
          //     tooltip: "edit",
          //     icon: Icon(Icons.drive_file_rename_outline),
          //     color: Colors.black,
          //     hoverColor: Colors.white,
          //     onPressed: () {
          //       //editEvent(event.eventID, index);
          //     }),
          // SizedBox(
          //   width: 20,
          // ),
          // IconButton(
          //     tooltip: "UnBan",
          //     icon: Icon(Icons.check),
          //     color: Colors.black,
          //     hoverColor: Colors.white,
          //     onPressed: () {
          //       //unBanEvent(event.eventID);
          //     }),
          // SizedBox(
          //   width: 20,
          // ),
          // IconButton(
          //     tooltip: "Ban",
          //     icon: Icon(Icons.block),
          //     color: Colors.black,
          //     hoverColor: Colors.white,
          //     onPressed: () {
          //       //banEvent(event.eventID);
          //     }),
          // SizedBox(
          //   width: 20,
          // ),
          // IconButton(
          //     tooltip: "Delete forever",
          //     icon: Icon(Icons.delete),
          //     color: Colors.black,
          //     hoverColor: Colors.white,
          //     onPressed: () {
          //       //deleteEvent(event.writerID, event.eventID);
          //     }),
        ],
      ),
    );
  }

  //methods
  Future tapped(String mailName) async {
    List data;
    var response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/")
            //headers: {"accept": "applicati"}
            );

    data = json.decode(response.body);
    if (data[0]['error'] == 1) {
      print('Check again');
    } else {
      var token = data[0]['title'];
      print(token);
    }

    //print(data[1]["title"]);

    print(mailName);
  }

  Future getMailsList(String userName) async {
    await postManController.getMails(userName);
  }

  Future deliverMail(String mailID) async {
    // await postManController.deliverMail(mailID);
  }
}