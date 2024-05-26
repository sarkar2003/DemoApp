import 'package:demoapp/Data_model/Data.dart';
import 'package:demoapp/Data_model/Savedatabasehelper.dart';
import 'package:demoapp/Data_model/liked_database.dart';
import 'package:demoapp/ui/Feed/feedpage.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:ionicons/ionicons.dart';

import 'package:demoapp/Data_model/databaseHelper.dart';
import 'package:demoapp/Global_bloc/cubit/api_call_cubit.dart';
import 'package:demoapp/Global_bloc/cubit/internet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class SaveList extends StatefulWidget {
  final bool internet_prev;
  const SaveList({Key? key, required this.internet_prev}) : super(key: key);
  @override
  SaveListState createState() => SaveListState();
}

class SaveListState extends State<SaveList> {
  ScrollController scrollController = ScrollController();
  SaveHelper helper = SaveHelper();
  bool to_load_more = true;
  var data_to_display = [];
  late bool internet;

  getdata() async {
    await helper.readdata();

    print("reaching here");

    setState(() {
      data_to_display = helper.dataset;
    });
  }

  Future getmoredata() async {
    await helper.readdata();

    setState(() {
      data_to_display = helper.dataset;
      to_load_more = true;
    });

    print("getting");
    print(data_to_display.length);

    return "complete";
  }

  delete_command(id) async {
    if (data_to_display.length > 10) {
      print("Command to delete");
      helper.deletedata(id);
    }
  }

  @override
  void initState() {
    print("back");
    setState(() {
      internet = widget.internet_prev;
    });

    // if (internet == true) {
    //   // helper.deletedata();
    //   delete_command();
    // }

    getdata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
        listener: (internetcontext, internetstate) {
          if (internetstate is InternetConnected) {
            setState(() {
              internet = true;
            });
          } else {
            setState(() {
              internet = false;
            });
          }
        },
        child: data_to_display.length == 0
            ? Center(
                child: Text("Nothing Saved yet"),
              )
            : Card(
                margin: EdgeInsets.all(0),
                child: Container(
                  color: Colors.black26,
                  child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      scrollDirection: Axis.vertical,
                      controller: scrollController,
                      itemCount: data_to_display.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        var data_to_display1;
                        var image_todisplay;
                        var liked;
                        if (index < data_to_display.length) {
                          data_to_display1 =
                              json.decode(data_to_display[index]['DATA']);
                          image_todisplay = data_to_display[index]['IMAGE'];
                          liked = data_to_display[index]['ISLIKED'];
                        }

                        if (index < data_to_display.length) {
                          return Feed(
                              data_to_display[index]['id'],
                              data_to_display1['id'],
                              data_to_display1['userId'],
                              data_to_display1['description'],
                              data_to_display1['title'],
                              data_to_display1['image_path'],
                              data_to_display1['eventCategory'],
                              data_to_display1['eventDescription'],
                              data_to_display1['comments'],
                              image_todisplay,
                              liked);
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                          );
                        }
                      }),
                ),
              ));
  }

  Feed(uniqueid, id, userId, description, title, image_path, eventCategory,
      eventDescription, comments, image_bits, liked) {
    return Builder(builder: (context) {
      return Column(
        children: [
          SizedBox(
            // height: MediaQuery.of(context).size.height * 0.05,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
              ),
              child: Container(
                color: Colors.white,
                child: ListTile(
                  leading: Image(
                      height: MediaQuery.of(context).size.height * 0.05,
                      image: AssetImage(
                        'assets/logoimage.jpg',
                      )),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // children: [Text(id) , ],
                    children: [Text("Arneo Paris"), Text("Arneo")],
                  ),
                  trailing: GestureDetector(
                    onTapDown: (pos) {
                      var posx = pos.globalPosition.dx;
                      var posy = pos.globalPosition.dy;
                      print(posx);
                      print(posy);

                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                                alignment: Alignment.topRight,
                                insetPadding: EdgeInsets.only(
                                    top: posy,
                                    right: 10,
                                    left: MediaQuery.of(context).size.width *
                                        0.4),
                                child: Container(
                                  height: 100,
                                  child: MaterialButton(
                                    splashColor: Colors.transparent,
                                    onPressed: () async {
                                      await helper.deletedata(uniqueid);
                                      await helper.readdata();
                                      setState(() {
                                        data_to_display = helper.dataset;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Icon(Ionicons.trash),
                                        Text("   Delete")
                                      ],
                                    ),
                                  ),
                                  // color: Colors.amber,
                                ));
                          });
                    },
                    child: Icon(Ionicons.ellipsis_horizontal),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              var pop = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return Feedpage(
                  page: 3,
                  uniqueid: uniqueid,
                  id: id,
                  userId: userId,
                  comments: comments,
                  description: description,
                  eventCategory: eventCategory,
                  eventDescription: eventDescription,
                  image_bits: image_bits,
                  image_path: image_path,
                  liked: liked,
                  title: title,
                );
              }));

              if (pop == null) {
                await helper.readdata();
                setState(() {
                  data_to_display = helper.dataset;
                });
              }
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Container(
                  child: internet
                      ? Image(
                          image: NetworkImage(image_path),
                          fit: BoxFit.fill,
                        )
                      : Image.memory(
                          image_bits,
                          fit: BoxFit.fill,
                        )),
            ),
          ),
          GestureDetector(
            onTap: () async {
              var pop = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return Feedpage(
                  page: 3,
                  uniqueid: uniqueid,
                  id: id,
                  userId: userId,
                  comments: comments,
                  description: description,
                  eventCategory: eventCategory,
                  eventDescription: eventDescription,
                  image_bits: image_bits,
                  image_path: image_path,
                  liked: liked,
                  title: title,
                );
              }));

              if (pop == null) {
                await helper.readdata();
                setState(() {
                  data_to_display = helper.dataset;
                });
              }
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: eventDescription.toString().substring(
                                  0,
                                  (eventDescription.toString().length) < 100
                                      ? (eventDescription.toString().length)
                                      : 100) +
                              '...',
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: "(Show more)",
                        style: TextStyle(color: Colors.grey),
                      )
                    ]),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Container(
                  color: Colors.white,
                  child: ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          var pop = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return Feedpage(
                              page: 3,
                              uniqueid: uniqueid,
                              id: id,
                              userId: userId,
                              comments: comments,
                              description: description,
                              eventCategory: eventCategory,
                              eventDescription: eventDescription,
                              image_bits: image_bits,
                              image_path: image_path,
                              liked: liked,
                              title: title,
                            );
                          }));

                          if (pop == null) {
                            await helper.readdata();
                            setState(() {
                              data_to_display = helper.dataset;
                            });
                          }
                        },
                        child: Row(
                          // alignment: WrapAlignment.center,
                          children: [
                            Icon(
                              Ionicons.chatbox_outline,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Comment",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          String? encodeQueryParameters(
                              Map<String, String> params) {
                            return params.entries
                                .map((MapEntry<String, String> e) =>
                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                .join('&');
                          }

                          String email = 'sarthaksarkar09@gmail.com';
                          final Uri emailuri = Uri(
                              scheme: 'mailto',
                              path: email,
                              query: encodeQueryParameters(<String, String>{
                                'subject': title.toString(),
                                'body': eventDescription.toString()
                              }));

                          await launchUrl(emailuri);
                        },
                        child: Row(
                          // alignment: WrapAlignment.center,
                          children: [
                            Icon(
                              Ionicons.share_outline,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Share",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ],
      );
    });
  }
}
