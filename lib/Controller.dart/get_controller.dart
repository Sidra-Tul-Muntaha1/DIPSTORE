import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';

class GetController extends GetxController {
  final stringvalue = 'ABC'.obs;
  final isChecked = false.obs;
  final data = {
    // 'key': 'value',
    // 'key1': 'value',
  }.obs;

  void fetchData() async {
    final reponse = await get(
      Uri.parse('https://dummyjson.com/users'),
    );

    data.value = jsonDecode(reponse.body);
  }

  @override
  void onReady() {
    super.onReady();
    fetchData();
  }
}