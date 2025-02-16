import 'dart:convert';
import 'package:flutmisho/commons.dart';
import 'package:flutmisho/data/models/all_items.dart';
import 'package:http/http.dart' as http;

class MishosService {
  Future<List<MishosItem>> fetchAll() async {
    final response = await http.get(Uri.parse(Constants.BASE_URL));
    if (response.statusCode == 200) {
      // Decode the response as a Map
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Extract the list from the 'data' key
      final List<dynamic> list = jsonResponse['data'];

      // Map each JSON object to a MishosItem instance
      return list.map((json) => MishosItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
