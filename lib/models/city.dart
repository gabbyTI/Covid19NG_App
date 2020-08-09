class City {
  final String name;
  final String confirmedCases;
  final String casesOnAdmission;
  final String discharged;
  final String death;

  City({
    this.name,
    this.confirmedCases,
    this.casesOnAdmission,
    this.discharged,
    this.death,
  });
  factory City.fromJson(Map<String, dynamic> data) {
    return City(
      name: data["state"],
      confirmedCases: data["confirmedCases"].toString(),
      casesOnAdmission: data["casesOnAdmission"].toString(),
      discharged: data["discharged"].toString(),
      death: data["death"].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "confirmedCases": confirmedCases,
      "casesOnAdmission": casesOnAdmission,
      "discharged": discharged,
      "death": death,
    };
  }
}
