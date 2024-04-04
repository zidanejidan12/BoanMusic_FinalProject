class Artist {
  int id;
  String fName;
  String lName;
  int activeYears;
  String description;
  DateTime birthDate;
  String imageURL;
  bool isActive;

  Artist({
    required this.id,
    required this.fName,
    required this.lName,
    required this.activeYears,
    required this.description,
    required this.birthDate,
    required this.imageURL,
    required this.isActive,
  });
}
