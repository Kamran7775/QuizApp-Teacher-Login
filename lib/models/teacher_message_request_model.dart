class TeacherMessageRequestChangeModel {
  String? membershipExpiredMessage;

  TeacherMessageRequestChangeModel({this.membershipExpiredMessage});

  TeacherMessageRequestChangeModel.fromJson(Map<String, dynamic> json) {
    membershipExpiredMessage = json['membership_expired_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['membership_expired_message'] = this.membershipExpiredMessage;
    return data;
  }
}
