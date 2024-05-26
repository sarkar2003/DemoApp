import 'package:demoapp/Data_model/Data.dart';
import 'package:demoapp/Data_model/Savedatabasehelper.dart';
import 'package:demoapp/Data_model/liked_database.dart';
import 'package:demoapp/ui/Feed/feedpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:ionicons/ionicons.dart';

import 'package:demoapp/Data_model/databaseHelper.dart';
import 'package:demoapp/Global_bloc/cubit/api_call_cubit.dart';
import 'package:demoapp/Global_bloc/cubit/internet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class Feedlist extends StatefulWidget {
  final bool internet_prev;
  const Feedlist({Key? key, required this.internet_prev}) : super(key: key);
  @override
  FeedlistState createState() => FeedlistState();
}

class FeedlistState extends State<Feedlist> {
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  String searchstr = "";
  Helper helper = Helper();
  bool to_load_more = true;
  var data_to_display = [];
  late bool internet;
  String url = "https://post-api-omega.vercel.app/api/posts?page=1";

  getdata() async {
    await helper.readdata();

    print("reaching here");

    if (widget.internet_prev == true && data_to_display.length > 10) {
      await helper.deletedata();
      setState(() {
        data_to_display = [];
      });
      // await BlocProvider.of<ApiCallCubit>(context).getDataCall(url);

      await getmoredata();
      // if (res) {
      //   print("I am here");
      //   print(data_to_display.length);
      // }
    }

    setState(() {
      data_to_display = helper.dataset;
    });

    Future.delayed(Duration(seconds: 5), () async {
      await helper.readdata();
      print("object");
      setState(() {
        data_to_display = helper.dataset;
      });
    });
  }

  Future getmoredata() async {
    await BlocProvider.of<ApiCallCubit>(context).getDataCall(url);
    await helper.readdata();

    setState(() {
      data_to_display = helper.dataset;
      to_load_more = true;
    });

    Future.delayed(Duration(seconds: 5), () async {
      await helper.readdata();
      print("object");
      setState(() {
        data_to_display = helper.dataset;
      });
    });

    print("getting");
    print(data_to_display.length);

    return "complete";
  }

  delete_command() async {
    if (data_to_display.length > 10) {
      print("Command to delete");
      helper.deletedata();
    }
  }

  @override
  void initState() {
    print("back");
    setState(() {
      internet = widget.internet_prev;
    });

    helper.readdata();
    Future.delayed(Duration(seconds: 5), () async {
      await helper.readdata();
      print("object");
      setState(() {
        data_to_display = helper.dataset;
      });
    });

    getdata();

    // if (internet == true) {
    //   // helper.deletedata();
    //   delete_command();
    // }

    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100) {
          if (internet == true) {
            if (to_load_more == true) {
              to_load_more = false;

              print("i am here to load");
              getmoredata();
            }
          }
        }
      },
    );
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

            print("Calling from here");
            getdata();
          } else {
            setState(() {
              internet = false;
            });
          }
        },
        child: helper.dataset.length == 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 5,
                        color: Colors.black26,
                        child: Container(
                          height: MediaQuery.of(context).size.width * 1,
                          color: Colors.white,
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: GestureDetector(
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
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4),
                                              child: Container(
                                                height: 100,
                                                child: MaterialButton(
                                                  splashColor:
                                                      Colors.transparent,
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Wrap(
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      MaterialButton(
                                                        onPressed: () {},
                                                        child: Text("sports"),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // color: Colors.amber,
                                              ));
                                        });
                                  },
                                  child: Image(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    image:
                                        AssetImage('assets/setting_icon.jpg'),
                                  ),
                                ),
                              )
                              // left: 100,
                              ),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: Column(
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.005,
                              color: Colors.black26,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.85,
                                color: Colors.white,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    // padding: EdgeInsets.only(right: 100),
                                    // child: ListView(),
                                    child: ListTile(
                                      titleAlignment:
                                          ListTileTitleAlignment.center,
                                      leading: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Icon(
                                          Icons.search,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: TextFormField(
                                          onChanged: (e) {
                                            setState(() {
                                              searchstr = searchController.text;
                                            });
                                          },
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          controller: searchController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(fontSize: 20),
                                            hintText: "Search messages",
                                          ),
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color:
                                            Color.fromARGB(255, 217, 231, 241)),
                                    margin: EdgeInsets.all(20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1),
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

                          if (index < data_to_display.length &&
                              ((data_to_display1['title']
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchstr.toLowerCase()) &&
                                      searchController.text != "") ||
                                  searchController.text == "")) {
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
                          } else if (index == data_to_display.length) {
                            return Container(
                              child: internet
                                  ? Center(child: CircularProgressIndicator())
                                  : Text("No internet"),
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
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
                    children: [Text(title), Text("Arneo")],
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
                                      SaveHelper saveHelper = SaveHelper();

                                      Data data = Data(
                                          id: id,
                                          userId: userId,
                                          description: description,
                                          title: title,
                                          image_path: image_path,
                                          eventCategory: eventCategory,
                                          eventDescription: eventDescription,
                                          comments: comments);

                                      await saveHelper.insert(
                                          data.toJson(), image_bits);
                                      await saveHelper.readdata();

                                      Navigator.of(context).pop();
                                    },
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Icon(Ionicons.bookmark_outline),
                                        Text("   Save")
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
                  page: 1,
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
                  page: 1,
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
                          LikeHelper likeHelper = LikeHelper();

                          Data data = Data(
                              id: id,
                              userId: userId,
                              description: description,
                              title: title,
                              image_path: image_path,
                              eventCategory: eventCategory,
                              eventDescription: eventDescription,
                              comments: comments);

                          await likeHelper.insert(data.toJson(), image_bits, 1);
                          likeHelper.readdata();

                          print(likeHelper.dataset.toString());

                          await helper.update(
                              uniqueid, data.toJson(), image_bits, 1);
                          await helper.readdata();
                          setState(() {
                            data_to_display = helper.dataset;
                          });
                        },
                        child: Row(
                          // alignment: WrapAlignment.center,
                          children: [
                            Icon(
                              liked == 0
                                  ? Ionicons.thumbs_up_outline
                                  : Ionicons.thumbs_up,
                              color: liked == 1 ? Colors.blue : Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Like",
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
                          var pop = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return Feedpage(
                              page: 1,
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
