import 'dart:convert';
import 'package:demoapp/ui/Community/CommunityPage.dart';
import 'package:demoapp/ui/Feed/FeedList.dart';
import 'package:demoapp/ui/Like/likelist.dart';
import 'package:demoapp/ui/Saved/SavedPage.dart';
import 'package:ionicons/ionicons.dart';

import 'package:demoapp/Data_model/databaseHelper.dart';
import 'package:demoapp/Global_bloc/cubit/api_call_cubit.dart';
import 'package:demoapp/Global_bloc/cubit/internet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class Homepage extends StatefulWidget {
  // final title;
  const Homepage({Key? key}) : super(key: key);
  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  Helper helper = Helper();
  var data_to_display = [];

  getdata() async {
    await helper.readdata();
    setState(() {
      data_to_display = helper.dataset;
    });
  }

  getmoredata() async {
    await BlocProvider.of<ApiCallCubit>(context).getDataCall(url);
    await helper.readdata();
    setState(() {
      Show_loading_animation = false;
    });
    getdata();
  }

  //global variables
  bool internetconnected = false;
  bool data_present_offline = false;
  bool Show_loading_animation = true;
  String url = "https://post-api-omega.vercel.app/api/posts?page=1";
  int pages = 1;

  @override
  void initState() {
    getdata();

    if (data_to_display.length > 10) {
      helper.deletedata();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
          ),
          centerTitle: true,
          title: Text("DemoApp"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: MaterialButton(
                elevation: 0,
                onPressed: () {},
                child: Image(
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: MediaQuery.of(context).size.height * 0.1,
                  image: AssetImage('assets/notif_icon.jpg'),
                ),
              ),
            )
          ],
        ),
        body: MultiBlocListener(
            listeners: [
              BlocListener<InternetCubit, InternetState>(
                listener: (context, internetstate) {
                  if (internetstate is InternetConnected) {
                    setState(() {
                      internetconnected = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Internet Connected")));
                  } else if (internetstate is InternetDisconnected) {
                    setState(() {
                      internetconnected = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Internet Disconnected")));

                    BlocProvider.of<ApiCallCubit>(context).internet_changed();
                  }
                },
              ),
              BlocListener<ApiCallCubit, ApiCallState>(
                listener: (context, apistate) {
                  if (apistate is LoadingVal && data_present_offline == false) {
                    setState(() {
                      Show_loading_animation = true;
                    });
                    print("here");
                    // BlocProvider.of<ApiCallCubit>(context).getDataCall(url);
                    getmoredata();
                  } else if (apistate is LoadingVal &&
                      data_present_offline == true) {
                    setState(() {
                      Show_loading_animation = false;
                    });
                  } else if (apistate is SuccessCall) {
                    setState(() {
                      data_present_offline = true;
                      Show_loading_animation = false;
                    });
                  }
                },
              )
            ],
            child: Stack(
              children: [
                BlocBuilder<InternetCubit, InternetState>(
                  builder: (internetcontext, internetstate) {
                    if (internetstate is InternetInitial) {
                      getmoredata();
                      Show_loading_animation = false;
                      return Center(child: CircularProgressIndicator());
                    } else if (internetstate is InternetConnected &&
                        Show_loading_animation == true) {
                      getmoredata();
                      Show_loading_animation = false;

                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (data_present_offline) {
                        Show_loading_animation = false;
                      }
                      return Visibility(visible: false, child: Container());
                    }
                  },
                ),
                pages == 1
                    ? BlocProvider.value(
                        child: Feedlist(
                          internet_prev: internetconnected,
                        ),
                        value: BlocProvider.of<InternetCubit>(context))
                    : pages == 2
                        ? BlocProvider.value(
                            child: Likelist(
                              internet_prev: internetconnected,
                            ),
                            value: BlocProvider.of<InternetCubit>(context))
                        : pages == 4
                            ? BlocProvider.value(
                                child: SaveList(
                                  internet_prev: internetconnected,
                                ),
                                value: BlocProvider.of<InternetCubit>(context))
                            : CommunityPage(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    child: Card(
                      elevation: 0,
                      color: Colors.black87,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.7,
                          right: 20,
                          left: 20,
                          bottom: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: SingleChildScrollView(
                        child: ButtonBar(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  pages = 1;
                                });
                              },
                              selectedIcon: Icon(Icons.home_outlined),
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.home,
                                    color: pages == 1
                                        ? Colors.blueAccent
                                        : Colors.white,
                                    size: 50,
                                  ),
                                  Text(
                                    "Feed",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  pages = 2;
                                });
                              },
                              // selectedIcon: Icon(Icons.like),
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Ionicons.heart,
                                    size: 50,
                                    color: pages == 2
                                        ? Colors.blueAccent
                                        : Colors.white,
                                  ),
                                  Text(
                                    "Like",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  )
                                ],
                              ),
                              isSelected: false,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  pages = 3;
                                });
                              },
                              // selectedIcon: Icon(Icons.like),
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Ionicons.people,
                                    size: 50,
                                    color: pages == 3
                                        ? Colors.blueAccent
                                        : Colors.white,
                                  ),
                                  Text(
                                    "Communinity",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                              isSelected: false,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  pages = 4;
                                });
                              },
                              // selectedIcon: Icon(Icons.like),
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Ionicons.bookmark_outline,
                                    color: pages == 4
                                        ? Colors.blueAccent
                                        : Colors.white,
                                    size: 50,
                                  ),
                                  Text(
                                    "Saved",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  )
                                ],
                              ),
                              isSelected: false,
                            )
                          ],
                          alignment: MainAxisAlignment.center,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
