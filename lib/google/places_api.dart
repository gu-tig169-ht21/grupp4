import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //namespace
import 'dart:convert';

var nyckel = 'AIzaSyCuPHW1WY319HfTCohnUXfBc7zMwVfgbmk';
const API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?address=';

class Api {
  //todo, skapa variabel som tar emot adress
  static void getPlace() async {
    var response =
        await http.get(Uri.parse('$API_URL/Henriksbergs Konsert & Restaurang AB (Henriksberg)&key=$nyckel'));
    String bodyString = response.body;
    var json = jsonDecode(bodyString);
    print(json.toString());
    Map<String, dynamic> map = jsonDecode(bodyString);
    print(json['results'][0]['geometry']['location']['lat']);
    print(json['results'][0]['geometry']['location']['lng']);
  }
}
