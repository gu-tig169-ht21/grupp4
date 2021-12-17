import 'package:my_first_app/pub_crawl_model.dart';

class User {
  final email;
  final uid;
  List<Pub>? favorites;

  User({required this.email, required this.uid, this.favorites});
}
