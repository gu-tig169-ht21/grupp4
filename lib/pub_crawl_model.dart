class PubCrawlModel {
  String crawlID;
  String title;
  String description;
  int? rating;
  List<Pub> pubs = [];

  PubCrawlModel(
      {required this.crawlID,
      required this.title,
      required this.description,
      this.rating,
      required this.pubs});
}

class Pub {
  String pubID;
  String name;
  String adress;
  //TODO: få in longitud/lattitud
  String? description;

  Pub(
      {required this.pubID,
      required this.name,
      required this.adress,
      this.description});
}
