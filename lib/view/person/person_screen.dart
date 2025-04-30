import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/model/media_model.dart';
import '../../data/model/movie_model.dart';
import '../../data/model/person_model.dart';
import '../../data/model/tv_show_model.dart';
import '../../data/repo/movie_repo.dart';
import '../../data/repo/tv_repo.dart';
import '../../gen/assets.gen.dart';
import '../../utils/routes/route_data.dart';
import '../../utils/theme_data.dart';
import '../common_widgets/general_widgets.dart';
import '../common_widgets/shimmers.dart';
import '../common_widgets/tabs_widgets.dart';
import 'bloc/person_bloc.dart';

class PersonScreen extends StatelessWidget {
  final int personId;
  final String profilePath;
  final String category;
  final String name;
  final String knownForDepartment;

  const PersonScreen(
      {super.key,
      required this.personId,
      required this.profilePath,
      required this.category,
      required this.name,
      required this.knownForDepartment});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonBloc, PersonState>(
      builder: (context, state) {
        return Scaffold(
          appBar: buildDefaultTabBar(
              title: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w500),
          )),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 24),
                (state is! PersonLoaded)
                    ? Hero(
                        transitionOnUserGestures: true,
                        tag: personId.toString() + category,
                        child: _Image(profilePath: 'w185$profilePath', placeHolder: null),
                      )
                    : SizedBox(
                        height: 300,
                        child: PageView.builder(
                          pageSnapping: true,
                          controller: PageController(viewportFraction: 0.57, keepPage: true),
                          itemCount: state.imagesPaths.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => Hero(
                            transitionOnUserGestures: true,
                            tag: index == 0 ? personId.toString() + category : index,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: _Image(
                                profilePath: 'original${state.imagesPaths[index]}',
                                placeHolder: (ctx, url) => index == 0
                                    ? _Image(profilePath: 'w185$profilePath', placeHolder: null)
                                    : defBoxShim(
                                        height: 300,
                                        width: 200,
                                        radius: 200,
                                        margin: EdgeInsets.zero),
                              ),
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text('Known for: ${state.person.knownForDepartment}'),
                ),
                _Overview(state: state),
                state.person.knownFor == null
                    ? KnowForShimmer()
                    : _MostKnowForList(category: category, state: state),
                (state is PersonLoaded)
                    ? _MoviesAndShows(category: category, state: state)
                    : SizedBox(),
                _Info(state: state),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({required this.profilePath, required this.placeHolder});

  final String profilePath;
  final Widget Function(BuildContext, String)? placeHolder;
  final double width = 200;
  final double height = 300;
  final BoxFit defaultFit = BoxFit.fitHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(200),
      child: CachedNetworkImage(
        imageUrl: 'https://image.tmdb.org/t/p/$profilePath',
        width: width,
        height: height,
        fit: defaultFit,
        fadeInCurve: Curves.easeIn,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        placeholder: placeHolder,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final SvgGenImage icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon.svg(width: 24, theme: SvgTheme(currentColor: LightThemeColors.primary)),
          Text(
            title,
            style: TextStyle(
              color: LightThemeColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final PersonState state;

  const _Overview({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
      child: Column(
        children: [
          _SectionTitle(title: 'Overview', icon: Assets.img.icons.overview),
          state is PersonLoaded
              ? ExpandableText(text: (state as PersonLoaded).personData.biography, maxLines: 5)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    defBoxShim(height: 15, width: 300, margin: EdgeInsets.all(4)),
                    defBoxShim(height: 15, width: 280, margin: EdgeInsets.all(4)),
                    defBoxShim(height: 15, width: 260, margin: EdgeInsets.all(4)),
                    defBoxShim(height: 15, width: 290, margin: EdgeInsets.all(4)),
                    defBoxShim(height: 15, width: 150, margin: EdgeInsets.all(4)),
                  ],
                ),
          SizedBox(height: 18),
          _SectionTitle(title: 'Knows For', icon: Assets.img.icons.person.sparkles),
        ],
      ),
    );
  }
}

class _MostKnowForList extends StatelessWidget {
  final String category;
  final PersonState state;

  const _MostKnowForList({required this.category, required this.state});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          final items = state.person.knownFor;
          final item = items![index].mediaType == MediaType.movie
              ? items[index].movie
              : items[index].mediaType == MediaType.tv
                  ? items[index].show
                  : null;

          if (item is MovieModel) {
            movieRepository.updateCachedMovies(newMovies: [item]);
          } else if (item is TvShowModel) {
            tvShowRepository.updateCachedTvShows(newShows: [item]);
          }
          return _KnowForListItem(item: item, category: category);
        },
      ),
    );
  }
}

class _KnowForListItem extends StatelessWidget {
  const _KnowForListItem({required this.item, required this.category});

  final dynamic item;
  final String category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => (item is MovieModel)
          ? MovieDetailRouteData(
              id: item.id,
              posterPath: item.posterPath,
              cat: category,
            ).push(context)
          : (item is TvShowModel)
              ? TvShowDetailRouteData(
                  id: item.id,
                  posterPath: item.posterPath,
                  cat: category,
                ).push(context)
              : null,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 5),
        width: 112,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(14)),
          boxShadow: [
            BoxShadow(
              color: Color(0x0601B4E4),
              blurRadius: 3,
              spreadRadius: 0,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Hero(
              transitionOnUserGestures: true,
              tag: item.id.toString() + category,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                  topLeft: Radius.circular(14),
                ),
                child: CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w185${item.posterPath}',
                  width: 112,
                  height: 171,
                  fit: BoxFit.cover,
                  fadeInCurve: Curves.easeIn,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 100,
              height: 35,
              child: Center(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                        height: 1.2,
                      ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoviesAndShows extends StatelessWidget {
  final String category;
  final PersonLoaded state;

  const _MoviesAndShows({required this.category, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (state.movieCredits.cast.isNotEmpty || state.movieCredits.crew.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
                child: _SectionTitle(title: 'Movies', icon: Assets.img.icons.movie2),
              )
            : SizedBox(),
        (state.movieCredits.cast.isNotEmpty)
            ? _MoviesList(
                items: state.movieCredits.cast,
                category: '${category}movie-cast',
                title: 'Cast',
              )
            : SizedBox(),
        (state.movieCredits.crew.isNotEmpty)
            ? _MoviesList(
                items: state.movieCredits.crew,
                category: '${category}movie-crew',
                title: 'Crew',
              )
            : SizedBox(),
        (state.showCredits.cast.isNotEmpty || state.showCredits.crew.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
                child: _SectionTitle(title: 'Shows', icon: Assets.img.icons.show2),
              )
            : SizedBox(),
        (state.showCredits.cast.isNotEmpty)
            ? _ShowsList(
                items: state.showCredits.cast,
                category: '${category}show-cast',
                title: 'Cast',
              )
            : SizedBox(),
        (state.showCredits.crew.isNotEmpty)
            ? _ShowsList(
                items: state.showCredits.crew,
                category: '${category}show-crew',
                title: 'Crew',
              )
            : SizedBox(),
      ],
    );
  }
}

class _MoviesList extends StatelessWidget {
  const _MoviesList({
    required this.items,
    required this.category,
    required this.title,
  });

  final List<dynamic>? items;
  final String category;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 0, 8),
          child: Text(title),
        ),
        SizedBox(
          height: 254,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: items?.length,
            itemBuilder: (context, index) {
              dynamic item = items![index];
              MovieModel movie = item.movie;

              return GestureDetector(
                onTap: () => MovieDetailRouteData(
                  id: movie.id,
                  posterPath: movie.posterPath,
                  cat: category,
                ).push(context),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                      width: 112,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(14),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x0601B4E4),
                            blurRadius: 3,
                            spreadRadius: 0,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Hero(
                            transitionOnUserGestures: true,
                            tag: movie.id.toString() + category + index.toString(),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(14),
                                topLeft: Radius.circular(14),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/w185${movie.posterPath}',
                                width: 112,
                                height: 171,
                                fit: BoxFit.cover,
                                fadeInCurve: Curves.easeIn,
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 100,
                            height: 35,
                            child: Center(
                              child: Text(
                                movie.title,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                      height: 1.2,
                                    ),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                        width: 100,
                        height: 35,
                        child: Text(
                          item is PersonMovieCastItemModel && item.character.isNotEmpty
                              ? 'as "${item.character}"'
                              : item is PersonMovieCrewItemModel && item.job.isNotEmpty
                                  ? item.job
                                  : '',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 13,
                                overflow: TextOverflow.ellipsis,
                                height: 1.2,
                              ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        )),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ShowsList extends StatelessWidget {
  const _ShowsList({
    required this.items,
    required this.category,
    required this.title,
  });

  final List<dynamic>? items;
  final String category;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 0, 8),
          child: Text(title),
        ),
        SizedBox(
          height: 254,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: items?.length,
            itemBuilder: (context, index) {
              dynamic item = items![index];
              TvShowModel show = item.show;

              return GestureDetector(
                onTap: () => TvShowDetailRouteData(
                  id: show.id,
                  posterPath: show.posterPath,
                  cat: category,
                ).push(context),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                      width: 112,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(14),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x0601B4E4),
                            blurRadius: 3,
                            spreadRadius: 0,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Hero(
                            transitionOnUserGestures: true,
                            tag: show.id.toString() + category + index.toString(),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(14),
                                topLeft: Radius.circular(14),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/w185${show.posterPath}',
                                width: 112,
                                height: 171,
                                fit: BoxFit.cover,
                                fadeInCurve: Curves.easeIn,
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 100,
                            height: 35,
                            child: Center(
                              child: Text(
                                show.title,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                      height: 1.2,
                                    ),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                        width: 100,
                        height: 35,
                        child: Text(
                          item is PersonTvShowCastItemModel && item.character.isNotEmpty
                              ? 'as "${item.character}"'
                              : item is PersonTvShowCrewItemModel && item.job.isNotEmpty
                                  ? item.job
                                  : '',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 13,
                                overflow: TextOverflow.ellipsis,
                                height: 1.2,
                              ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        )),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  final PersonState state;

  const _Info({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 60),
      child: Column(
        children: [
          _SectionTitle(title: 'Info', icon: Assets.img.icons.person.infoCircle),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 0, 10),
                child: Row(
                  children: [
                    _InfoItemTitle(title: 'Birthday:', icon: Assets.img.icons.person.birthdayIcon),
                    Text(state is PersonLoaded ? (state as PersonLoaded).personData.birthday : '')
                  ],
                ),
              ),
              state is PersonLoaded && (state as PersonLoaded).personData.deathday != 'null'
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 0, 10),
                      child: Row(
                        children: [
                          _InfoItemTitle(title: 'Deathday:', icon: Assets.img.icons.person.grave),
                          Text((state as PersonLoaded).personData.deathday!)
                        ],
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 0, 10),
                child: Row(
                  children: [
                    _InfoItemTitle(title: 'Place of Birth:', icon: Assets.img.icons.person.mapPin),
                    Flexible(
                        child: Text(
                      state is PersonLoaded ? (state as PersonLoaded).personData.placeOfBirth : '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 0, 10),
                child: Row(
                  children: [
                    _InfoItemTitle(title: 'Gender:', icon: Assets.img.icons.person.genderIcon),
                    state is PersonLoaded
                        ? Row(
                            children: [
                              Text((state as PersonLoaded).personData.gender.toHumanString()),
                              (state as PersonLoaded).personData.gender == Gender.male
                                  ? Assets.img.icons.person.genderMale.svg(
                                      theme: SvgTheme(currentColor: LightThemeColors.gray),
                                      height: 20)
                                  : (state as PersonLoaded).personData.gender == Gender.female
                                      ? Assets.img.icons.person.genderFemme.svg(
                                          theme: SvgTheme(currentColor: LightThemeColors.gray),
                                          height: 20)
                                      : (state as PersonLoaded).personData.gender ==
                                              Gender.nonBinary
                                          ? Assets.img.icons.person.genderGenderqueer.svg(
                                              theme: SvgTheme(currentColor: LightThemeColors.gray),
                                              height: 20)
                                          : SizedBox(),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 0, 10),
                child: Row(
                  children: [
                    _InfoItemTitle(title: 'Popularity:', icon: Assets.img.icons.person.popularIcon),
                    Text(state is PersonLoaded
                        ? (state as PersonLoaded).personData.popularity.toStringAsFixed(1)
                        : '')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                child: _InfoItemTitle(title: 'Also Known as', icon: Assets.img.icons.person.names),
              ),
              state is PersonLoaded
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(36, 0, 0, 10),
                      child: createOtherNamesString(
                          names: (state as PersonLoaded).personData.alsoKnownAs),
                    )
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItemTitle extends StatelessWidget {
  final String title;
  final SvgGenImage icon;

  const _InfoItemTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon.svg(width: 20, theme: SvgTheme(currentColor: LightThemeColors.gray)),
          Text(
            title,
            style: TextStyle(
              color: LightThemeColors.gray,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

Text createOtherNamesString({required List<String> names}) {
  String string = '';
  for (int i = 0; i < names.length; i++) {
    string = string + names[i];
    if (names.length > 1 && names.length - 1 != i) {
      string = '$string  |  ';
    }
  }
  return Text(
    string,
    style: TextStyle(fontSize: 15),
    // textAlign: TextAlign.center,
  );
}
