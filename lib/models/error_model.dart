class ErrorModel {
  ErrorModel({
    required this.status,
    required this.errors,
  });
  late final Status status;
  late final Errors errors;

  ErrorModel.fromJson(Map<String, dynamic> json) {
    status = Status.fromJson(json['status']);
    errors = Errors.fromJson(json['errors']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status.toJson();
    data['errors'] = errors.toJson();
    return data;
  }
}

class Status {
  Status({
    required this.message,
    required this.code,
  });
  late final String message;
  late final String code;

  Status.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    data['code'] = code;
    return data;
  }
}

class Errors {
  Errors({
    required this.username,
  });
  late final List<String> username;

  Errors.fromJson(Map<String, dynamic> json) {
    username = List.castFrom<dynamic, String>(json['username']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    return data;
  }
}
