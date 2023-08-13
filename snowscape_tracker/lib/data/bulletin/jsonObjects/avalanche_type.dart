class AvalancheType {
  int? sAvalancheTypeId;

  AvalancheType({
    required this.sAvalancheTypeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'sAvalancheTypeId': sAvalancheTypeId,
    };
  }

  factory AvalancheType.fromJson(Map<String, dynamic> json) {
    return AvalancheType(
      sAvalancheTypeId: json['s_avalanche_type_id'],
    );
  }
}
