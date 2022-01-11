class PubCrawlModel {
  String crawlID;
  String title;
  String description;
  String? rating;
  String pubs;
  String imgRef;

  PubCrawlModel(
      {required this.crawlID,
      required this.title,
      required this.description,
      this.rating,
      required this.pubs,
      required this.imgRef});

  String get id => crawlID;
  String get crawlTitle => title;
  String get crawlDescription => description;
  String? get crawlRating => rating;
  String get crawlPubs => pubs;
}

class Pub {
  String name;
  String adress;
  String? description;
  bool isfavourite = false;

  Pub({
    required this.name,
    required this.adress,
    this.description,
    required this.isfavourite,
  });

  String get pubname => name;
  String get pubadress => adress;
  String? get pubdescription => description;
}
