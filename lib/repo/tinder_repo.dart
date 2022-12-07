import 'dart:convert';
import 'package:http/http.dart';

import '../model/tinder_model.dart';
import '../utils/config.dart';

class RepositoryTinder {
  String endPoint = Config.PRODUCTS;
  Future getLiveTenderDetailsData() async {
    Response response = await get(Uri.parse(endPoint));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result.map((e) => TinderModel.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
