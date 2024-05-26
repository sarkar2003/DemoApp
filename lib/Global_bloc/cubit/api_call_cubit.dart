import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:demoapp/Data_model/Data.dart';
import 'package:demoapp/Data_model/databaseHelper.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'api_call_state.dart';

class ApiCallCubit extends Cubit<ApiCallState> {
  ApiCallCubit() : super(LoadingVal());

  Helper helper = Helper();
  late Data data;

  Future getDataCall(String url) async {
    var response = await http.get(Uri.parse(url));

    var dataset = json.decode(response.body);

    for (int i = 0; i < dataset.length; i++) {
      data = Data(
          id: dataset[i]['_id'],
          userId: dataset[i]['userId'],
          description: dataset[i]['description'],
          title: dataset[i]['title'],
          image_path: dataset[i]['image'][0],
          eventCategory: dataset[i]['eventCategory'],
          eventDescription: dataset[i]['eventDescription'],
          comments: dataset[i]['comments']);
      Int8List _bytes;
      ByteData img = await NetworkAssetBundle(Uri.parse(dataset[i]['image'][0]))
          .load(dataset[i]['image'][0]);

      _bytes = img.buffer.asInt8List();
      await helper.insert(data.toJson(), _bytes, 0);
      await helper.readdata();
    }

    // print(data.toJson());

    // print(json.decode(response.body));
    emit(SuccessCall());
    return 1;
  }

  void internet_changed() async {
    emit(LoadingVal());
  }
}
