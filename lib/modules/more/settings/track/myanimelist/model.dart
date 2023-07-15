class MyAnimeListOAuth {
  String? tokenType;
  int? expiresIn;
  String? accessToken;
  String? refreshToken;

  MyAnimeListOAuth(
      {this.tokenType, this.expiresIn, this.accessToken, this.refreshToken});

  MyAnimeListOAuth.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'];
    expiresIn = (json['expires_in'] as int) * 1000 +
        DateTime.now().millisecondsSinceEpoch;
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    return data;
  }
}
