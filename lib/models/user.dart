class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String userRole;
  final String MDLSZ;
  final int serialNumber;
  final String category;
  final String division;
  User({this.id, this.firstName, this.lastName, this.email, this.userRole, this.MDLSZ, this.serialNumber, this.category, this.division});
  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        firstName = data['firstName'],
        lastName = data['lastName'],
        email = data['email'],
        userRole = data['userRole'],
        MDLSZ = data['MDLSZ'],
        serialNumber = data['serialNumber'],
        category = data['category'],
        division = data['division'];
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'userRole': userRole,
      'MDLSZ': MDLSZ,
      'serialNumber': serialNumber,
      'category': category,
      'division': division,
    };
  }
}
