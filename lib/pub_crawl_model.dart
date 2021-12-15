class PubCrawlModel {
  String crawlID;
  String title;
  String description;
  double? rating;
  List<Pub> pubs = [
    Pub(
        pubID: "1",
        name: "Steampunk",
        adress: "Nybrogatan 3",
        description: "Gammal"),
    Pub(pubID: "2", name: "Brygghuset", adress: "Andra Långgatan 2b"),
    Pub(
        pubID: "3",
        name: "Henriksberg",
        adress: "Gamla vägen 7",
        description: "Fin")
  ];

  PubCrawlModel({
    required this.crawlID,
    required this.title,
    required this.description,
    this.rating,
    required this.pubs,
  });
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

  String get ID => pubID;
  String get pubname => name;
  String get pubadress => adress;
  String? get pubdescription => description;
}
