import 'package:my_first_app/models/pub_crawl_model.dart';

class User {
  final dynamic email;
  final dynamic uid;
  List<Pub>? favorites;

  User({required this.email, required this.uid, this.favorites});
}
