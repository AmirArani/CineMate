class ListPreferences {
  final SortMethod sortMethod;

  ListPreferences({required this.sortMethod});

  ListPreferences copyWith({SortMethod? sortMethod}) {
    return ListPreferences(
      sortMethod: sortMethod ?? this.sortMethod,
    );
  }
}

enum SortMethod { createdAtAsc, createdAtDesc, ratingAsc, ratingDesc }

extension Sort on SortMethod {
  String get toServerString {
    switch (this) {
      case SortMethod.createdAtAsc:
        return 'created_at.asc';
      case SortMethod.createdAtDesc:
        return 'created_at.desc';
      case SortMethod.ratingAsc:
        return 'rating.asc';
      case SortMethod.ratingDesc:
        return 'rating.desc';
    }
  }

  SortMethodConverter get toHumanString {
    switch (this) {
      case SortMethod.createdAtAsc:
        return SortMethodConverter(isAscending: true, sortMethod: 'Created At');
      case SortMethod.createdAtDesc:
        return SortMethodConverter(isAscending: false, sortMethod: 'Created At');
      case SortMethod.ratingAsc:
        return SortMethodConverter(isAscending: true, sortMethod: 'Rating');
      case SortMethod.ratingDesc:
        return SortMethodConverter(isAscending: false, sortMethod: 'Rating');
    }
  }
}

class SortMethodConverter {
  final bool isAscending;
  final String sortMethod;

  SortMethodConverter({required this.isAscending, required this.sortMethod});
}
