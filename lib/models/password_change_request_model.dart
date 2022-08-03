class PasswordChangeRequestModel {
  String? oldPassword;
  String? newPassword;

  PasswordChangeRequestModel({this.oldPassword, this.newPassword});

  PasswordChangeRequestModel.fromJson(Map<String, dynamic> json) {
    oldPassword = json['old_password'];
    newPassword = json['new_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['old_password'] = this.oldPassword;
    data['new_password'] = this.newPassword;
    return data;
  }
}
