class AccountStateModel {
  final int id;
  final bool favorite;
  final bool watchlist;
  final double? rate;

  AccountStateModel(
      {required this.id, required this.favorite, required this.watchlist, required this.rate});

  AccountStateModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        favorite = json['favorite'],
        watchlist = json['watchlist'],
        rate = json['rated'] == false ? null : json['rated']['value'] / 2;

  AccountStateModel copyWith({
    int? id,
    bool? favorite,
    bool? watchlist,
    double? rate,
  }) {
    return AccountStateModel(
      id: id ?? this.id,
      favorite: favorite ?? this.favorite,
      watchlist: watchlist ?? this.watchlist,
      rate: rate ?? this.rate,
    );
  }
}
