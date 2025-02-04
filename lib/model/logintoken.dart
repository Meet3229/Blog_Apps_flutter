class Logintokanmodel {
  String? _idToken;

  Logintokanmodel({String? idToken}) {
    if (idToken != null) {
      this._idToken = idToken;
    }
  }

  String? get idToken => _idToken;
  set idToken(String? idToken) => _idToken = idToken;

  Logintokanmodel.fromJson(Map<String, dynamic> json) {
    _idToken = json['id_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_token'] = this._idToken;
    return data;
  }
}
