class Battlefield {
  final String id;
  final String description;
  final List<String> judgeIds;
  final String competitionType;
  final bool penaltyVetlen;
  final bool penaltyEljarasi;
  final bool penaltyMNT;
  final bool penaltyAlak;
  final bool penaltyJokerNyilt;
  final bool penaltyJokerOptikai;
  final bool penaltyEgyeb;
  Battlefield({this.id, this.description, this.judgeIds, this.competitionType, this.penaltyVetlen, this.penaltyEljarasi, this.penaltyMNT,
    this.penaltyAlak, this.penaltyJokerNyilt, this.penaltyJokerOptikai, this.penaltyEgyeb});
  Battlefield.fromData(Map<String, dynamic> data)
      : id = data['id'],
      description = data['description'],
      judgeIds = data['judgeIds'],
      competitionType = data['competitionType'],
      penaltyVetlen = data['penaltyVetlen'],
      penaltyEljarasi = data['penaltyEljarasi'],
      penaltyMNT = data['penaltyMNT'],
      penaltyAlak = data['penaltyAlak'],
      penaltyJokerNyilt = data['penaltyJokerNyilt'],
      penaltyJokerOptikai = data['penaltyJokerOptikai'],
      penaltyEgyeb = data['penaltyEgyeb'];
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'judgeIds':judgeIds,
      'competitionType':competitionType,
      'penaltyVetlen':penaltyVetlen,
      'penaltyEljarasi':penaltyEljarasi,
      'penaltyMNT':penaltyMNT,
      'penaltyAlak':penaltyAlak,
      'penaltyJokerNyilt':penaltyJokerNyilt,
      'penaltyJokerOptikai':penaltyJokerOptikai,
      'penaltyEgyeb':penaltyEgyeb
    };
  }
}
