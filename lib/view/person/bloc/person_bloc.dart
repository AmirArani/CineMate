import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/media_model.dart';
import '../../../data/model/person_model.dart';
import '../../../data/repo/person_repo.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc() : super(PersonLoading(person: _tempPerson, knownForItems: [])) {
    on<PersonEvent>((event, emit) async {
      if (event is PersonLoadEvent) {
        await _handlePersonLoadEvent(emit, event);
      }
    });
  }
}

Future<void> _handlePersonLoadEvent(Emitter emit, PersonLoadEvent event) async {
  final int id = event.id;
  PersonModel? person = personRepository.getPersonById(id: id);

  try {
    emit(PersonLoading(person: person ?? _tempPerson, knownForItems: []));

    PersonDetailModel personData = await personRepository.getPersonDetail(id: id);
    List<String> imagePaths = await personRepository.getImages(id: id);
    PersonMovieCreditModel movieCredits = await personRepository.getCreditMovies(id: id);
    PersonTvsShowCreditModel showCredits = await personRepository.getCreditTvShows(id: id);

    List<dynamic> knownForMediaItems = (person != null && person.knownFor != null)
        ? convertKnownForItems(person.knownFor!)
        : getTop3PopularShowsAndMovies(showCredits, movieCredits);

    List<MediaModel> convertedKnownForItems = [];
    if (person != null && person.knownFor == null && knownForMediaItems.isNotEmpty) {
      convertedKnownForItems = convertMediaItemsToKnownForItems(knownForMediaItems);
      person = person.copyWith(knownFor: convertedKnownForItems); // Update person.knownFor
    }

    emit(PersonLoaded(
        person: person ??
            PersonModel(
                id: personData.id,
                name: personData.name,
                gender: personData.gender,
                profilePath: personData.profilePath,
                knownForDepartment: personData.knownForDepartment,
                knownFor: convertMediaItemsToKnownForItems(knownForMediaItems)),
        personData: personData,
        knownForItems: knownForMediaItems,
        movieCredits: movieCredits,
        showCredits: showCredits,
        imagesPaths: imagePaths));
  } catch (error) {
    emit(PersonError(person: person ?? _tempPerson, knownForItems: []));
  }
}

List<MediaModel> convertMediaItemsToKnownForItems(List<dynamic> knownForMediaItems) {
  List<MediaModel> convertedItems = [];

  for (var mediaItem in knownForMediaItems) {
    if (mediaItem is PersonMovieCastItemModel) {
      convertedItems.add(MediaModel(mediaType: MediaType.movie, movie: mediaItem.movie));
    } else if (mediaItem is PersonMovieCrewItemModel) {
      convertedItems.add(MediaModel(mediaType: MediaType.movie, movie: mediaItem.movie));
    } else if (mediaItem is PersonTvShowCastItemModel) {
      convertedItems.add(MediaModel(mediaType: MediaType.tv, show: mediaItem.show));
    } else if (mediaItem is PersonTvShowCrewItemModel) {
      convertedItems.add(MediaModel(mediaType: MediaType.tv, show: mediaItem.show));
    }
  }
  return convertedItems;
}

List<dynamic> convertKnownForItems(List<MediaModel> knownFor) {
  List<dynamic> knownForItems = List.empty(growable: true);

  for (MediaModel item in knownFor) {
    if (item.mediaType == MediaType.movie) {
      knownForItems.add(item.movie);
    } else if (item.mediaType == MediaType.tv) {
      knownForItems.add(item.show);
    }
  }
  return knownForItems;
}

List<dynamic> getTop3PopularShowsAndMovies(
    PersonTvsShowCreditModel tvShowCredits, PersonMovieCreditModel movieCredits) {
  List<dynamic> allItems = [];

  // Add all cast and crew item models to the list
  allItems.addAll(tvShowCredits.cast);
  allItems.addAll(tvShowCredits.crew);
  allItems.addAll(movieCredits.cast);
  allItems.addAll(movieCredits.crew);

  // Sort all items by popularity in descending order
  allItems.sort((a, b) {
    double popularityA = 0;
    double popularityB = 0;

    if (a is PersonTvShowCastItemModel) {
      popularityA = a.popularity;
    } else if (a is PersonTvShowCrewItemModel) {
      popularityA = a.popularity;
    } else if (a is PersonMovieCastItemModel) {
      popularityA = a.popularity;
    } else if (a is PersonMovieCrewItemModel) {
      popularityA = a.popularity;
    }

    if (b is PersonTvShowCastItemModel) {
      popularityB = b.popularity;
    } else if (b is PersonTvShowCrewItemModel) {
      popularityB = b.popularity;
    } else if (b is PersonMovieCastItemModel) {
      popularityB = b.popularity;
    } else if (b is PersonMovieCrewItemModel) {
      popularityB = b.popularity;
    }

    return popularityB.compareTo(popularityA); // Descending order
  });

  // Take the top 3 items or fewer if there are less than 3
  return allItems.take(3).toList();
}

PersonModel _tempPerson = PersonModel(
  id: -1,
  name: 'null',
  gender: Gender.notSet,
  profilePath: 'null',
  knownForDepartment: 'null',
  knownFor: null,
);
