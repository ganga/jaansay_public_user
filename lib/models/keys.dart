class KeyMaster {
  KeyMaster({
    this.kmId,
    this.name,
    this.description,
    this.ktId,
    this.isGeneral,
    this.kaId,
    this.koptId,
    this.answer,
    this.optionIds,
    this.options,
  });

  int kmId;
  String name;
  String description;
  int ktId;
  int isGeneral;
  int kaId;
  int koptId;
  String answer;
  List<int> optionIds;
  List<String> options;

  factory KeyMaster.fromJson(Map<String, dynamic> json) => KeyMaster(
        kmId: json["km_id"],
        name: json["name"],
        description: json["description"],
        ktId: json["kt_id"],
        isGeneral: json["is_general"],
        kaId: json["ka_id"],
        koptId: json["kopt_id"],
        answer: json["answer"],
        optionIds: json["option_ids"] == null
            ? []
            : json["option_ids"]
                .toString()
                .split(",")
                .map((e) => int.parse(e))
                .toList(),
        options: json["options"] == null
            ? []
            : json["options"].toString().split(","),
      );
}
