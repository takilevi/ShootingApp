class Result {
  final String id;
  final String description;
  final String competitorId;
  final String judgeId;
  final double time;
  final int penaltyByCompetitionType; //Idpa :(+0) (+1) (+3) Körkörös: (+0) (+1) (+2)......(+8) (+9)
  final int penaltyVetlen;
  final int penaltyEljarasi;
  final int penaltyMNT;
  final int penaltyAlak;
  final int penaltyJokerNyilt;
  final int penaltyJokerOptikai;
  final int penaltyEgyeb;
  Result({this.id, this.description, this.competitorId, this.judgeId, this.time, this.penaltyByCompetitionType, this.penaltyVetlen, this.penaltyEljarasi, this.penaltyMNT,
    this.penaltyAlak, this.penaltyJokerNyilt, this.penaltyJokerOptikai, this.penaltyEgyeb});
  Result.fromData(Map<String, dynamic> data)
      : id = data['id'],
        description = data['description'],
        competitorId = data['competitorId'],
        judgeId = data['judgeId'],
        time = data["time"],
        penaltyByCompetitionType = data["penaltyByCompetitionType"],
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
      'competitorId':competitorId,
      'judgeId':judgeId,
      'time':time,
      'penaltyByCompetitionType':penaltyByCompetitionType,
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
