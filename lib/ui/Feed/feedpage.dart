import 'package:demoapp/Data_model/Data.dart';
import 'package:demoapp/Data_model/Savedatabasehelper.dart';
import 'package:demoapp/Data_model/databaseHelper.dart';
import 'package:demoapp/Data_model/liked_database.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:ionicons/ionicons.dart';

class Feedpage extends StatefulWidget {
  final page;
  final uniqueid;
  final id;
  final userId;
  final description;
  final title;
  final image_path;
  final eventCategory;
  final eventDescription;
  final comments;
  final image_bits;
  final liked;
  const Feedpage(
      {Key? key,
      required this.page,
      required this.uniqueid,
      this.id,
      this.userId,
      this.description,
      this.title,
      this.image_path,
      this.eventCategory,
      this.eventDescription,
      this.comments,
      this.image_bits,
      this.liked})
      : super(key: key);
  @override
  FeedpageState createState() => FeedpageState();
}

class FeedpageState extends State<Feedpage> {
  TextEditingController comments = TextEditingController();
  String texts = "";
  late List items;
  var helper;

  @override
  void initState() {
    if (widget.page == 1) {
      helper = Helper();
    } else if (widget.page == 2) {
      helper = LikeHelper();
    } else if (widget.page == 3) {
      helper = SaveHelper();
    }
    items = widget.comments;
    helper.readdata();
    print(widget.comments);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title.toString()),
        ),
        body: ListView.builder(
            itemCount: items.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
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
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                image: AssetImage(
                                  'assets/logoimage.jpg',
                                )),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // children: [Text(id) , ],
                              children: [Text(widget.title), Text("Arneo")],
                            ),
                            trailing: IconButton(
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
                                    query:
                                        encodeQueryParameters(<String, String>{
                                      'subject': widget.title.toString(),
                                      'body': widget.eventDescription.toString()
                                    }));

                                await launchUrl(emailuri);
                              },
                              icon: Icon(Ionicons.arrow_redo_outline),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Container(
                          child: Image.memory(
                        widget.image_bits,
                        fit: BoxFit.fill,
                      )),
                    ),
                    SizedBox(
                      // height: MediaQuery.of(context).size.height * 0.05,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: widget.eventDescription.toString(),
                                  style: TextStyle(color: Colors.black)),
                            ]),
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
                                Row(
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
                              ],
                            )),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      // child: Wrap(
                      //   children: [
                      //     Card(
                      //       child: TextFormField(
                      //         autofocus: false,
                      //         controller: comments,
                      //         validator: (input) {},
                      //         onChanged: (value) {
                      //           print(value);
                      //         },
                      //       ),
                      //       color: Colors.amber,
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(30)),
                      //     ),
                      //     IconButton(onPressed: () {}, icon: Icon(Icons.send))
                      //   ],
                      // ),
                      child: Card(
                        elevation: 0,
                        borderOnForeground: true,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextFormField(
                                  controller: comments,
                                  onChanged: (v) {
                                    // texts = v;
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  items.add(comments.text);

                                  Data data = Data(
                                      id: widget.id,
                                      userId: widget.userId,
                                      description: widget.description,
                                      title: widget.title,
                                      image_path: widget.image_path,
                                      eventCategory: widget.eventCategory,
                                      eventDescription: widget.eventDescription,
                                      comments: items);

                                  if (widget.page != 3) {
                                    await helper.update(
                                        widget.uniqueid,
                                        data.toJson(),
                                        widget.image_bits,
                                        widget.liked);
                                  } else {
                                    await helper.update(
                                      widget.uniqueid,
                                      data.toJson(),
                                      widget.image_bits,
                                    );
                                  }

                                  await helper.readdata();

                                  setState(() {
                                    comments.text = "";
                                  });
                                },
                                icon: Icon(Icons.send))
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(widget.comments[index - 1]),
                  ),
                );
              }
            }));
  }
}
