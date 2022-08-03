class StudentRequestModel {
  String? username;
  String? firstName;
  String? lastName;
  String? fatherName;
  String? phoneNumber;
  bool? isActive;
  int? allowedMobileCount;
  int? allowedPcCount;
  int? remainingDays;

  StudentRequestModel(
      {this.username,
      this.firstName,
      this.lastName,
      this.fatherName,
      this.phoneNumber,
      this.isActive,
      this.allowedMobileCount,
      this.allowedPcCount,
      this.remainingDays});

  StudentRequestModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    fatherName = json['father_name'];
    phoneNumber = json['phone_number'];
    isActive = json['is_active'];
    allowedMobileCount = json['allowed_mobile_count'];
    allowedPcCount = json['allowed_pc_count'];
    remainingDays = json['remaining_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['father_name'] = this.fatherName;
    data['phone_number'] = this.phoneNumber;
    data['is_active'] = this.isActive;
    data['allowed_mobile_count'] = this.allowedMobileCount;
    data['allowed_pc_count'] = this.allowedPcCount;
    data['remaining_days'] = this.remainingDays;
    return data;
  }
}
