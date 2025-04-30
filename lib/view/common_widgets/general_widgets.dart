import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/genre_model.dart';
import '../../data/model/movie_model.dart';
import '../../data/model/person_model.dart';
import '../../data/model/tv_show_model.dart';
import '../../gen/assets.gen.dart';
import '../../utils/helpers/exception.dart';
import '../../utils/routes/route_data.dart';
import '../../utils/theme_data.dart';
import 'shimmers.dart';

class GenresTopList extends StatelessWidget {
  final List<GenreModel>? allGenres;

  const GenresTopList({super.key, required this.allGenres});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(27, 0, 27, 0),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: allGenres?.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            decoration: const BoxDecoration(
              color: Color(0xff858585),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: InkWell(
              radius: 8,
              onTap: () =>
                  DiscoverScreenRouteData(genreId: allGenres![index].id.toString()).push(context),
              child: SizedBox(
                height: 30,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Text(
                      allGenres![index].name,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class VerticalListItem extends StatelessWidget {
  final dynamic item;
  final String category;

  const VerticalListItem({super.key, required this.item, required this.category});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return GestureDetector(
      onTap: () => (item is TvShowModel)
          ? TvShowDetailRouteData(
              id: item.id,
              posterPath: item.posterPath,
              cat: category,
            ).push(context)
          : (item is MovieModel)
              ? MovieDetailRouteData(id: item.id, posterPath: item.posterPath, cat: category)
                  .push(context)
              : null,
      child: Container(
        height: 165,
        decoration: (BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3), //color of shadow
              spreadRadius: 1, //spread radius
              blurRadius: 10, // blur radius
              offset: const Offset(0, 5), // changes position of shadow
            )
          ],
        )),
        margin: const EdgeInsets.fromLTRB(8, 16, 8, 0),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: themeData.textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.overview,
                      style: themeData.textTheme.bodySmall,
                      maxLines: 4,
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 12),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: LightThemeColors.primary.withValues(alpha: 0.8),
                              ),
                              child: Text(
                                item.originalLanguage,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Icon(CupertinoIcons.star, size: 18),
                            const SizedBox(width: 4),
                            Text(item.vote.toStringAsFixed(1),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.normal)),
                          ],
                        ),
                        Text(
                          item.releaseDate,
                          style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Hero(
              transitionOnUserGestures: true,
              tag: item.id.toString() + category,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                child: CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w185${item.posterPath}',
                  width: 110,
                  height: 160,
                  fit: BoxFit.fill,
                  fadeInCurve: Curves.easeIn,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholder: (context, url) =>
                      defBoxShim(height: 170, width: 110, margin: EdgeInsets.zero),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalList extends StatelessWidget {
  const HorizontalList({
    super.key,
    required this.items,
    required this.themeData,
    required this.category,
  });

  final List<dynamic>? items;
  final ThemeData themeData;
  final String category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items?.length,
        itemBuilder: (context, index) {
          dynamic item = items![index];

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
                        style: themeData.textTheme.bodyMedium!.copyWith(
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
        },
      ),
    );
  }
}

class HorizontalPersonListItem extends StatelessWidget {
  final ThemeData themeData;
  final PersonModel person;
  final String category;

  const HorizontalPersonListItem(
      {super.key, required this.themeData, required this.person, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => PersonDetailRouteData(
        id: person.id,
        name: person.name,
        knownForDepartment: person.knownForDepartment,
        profilePath: person.profilePath,
        cat: category,
      ).push(context),
      child: Container(
        margin: const EdgeInsets.fromLTRB(9, 0, 9, 0),
        width: 67,
        height: 135,
        child: Column(
          children: [
            Hero(
              transitionOnUserGestures: true,
              tag: person.id.toString() + category,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(33.36),
                child: CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w185${person.profilePath}',
                  width: 66.72,
                  height: 100,
                  fit: BoxFit.cover,
                  fadeInCurve: Curves.easeIn,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                width: 67,
                height: 35,
                child: Center(
                  child: Text(
                    person.name,
                    style: themeData.textTheme.bodyMedium!
                        .copyWith(fontSize: 14, overflow: TextOverflow.ellipsis),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerticalPersonListItem extends StatelessWidget {
  final int id;
  final String name;
  final String profilePath;
  final String knownForDepartment;
  final String subtitle;
  final String category;

  const VerticalPersonListItem(
      {super.key,
      required this.id,
      required this.name,
      required this.profilePath,
      required this.knownForDepartment,
      required this.subtitle,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => PersonDetailRouteData(
        id: id,
        name: name,
        profilePath: profilePath,
        knownForDepartment: knownForDepartment,
        cat: category,
      ).push(context),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(9, 0, 9, 0),
                width: 67,
                height: 110,
                child: Column(
                  children: [
                    Hero(
                      transitionOnUserGestures: true,
                      tag: id.toString() + category,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(33.36),
                        child: CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/w185$profilePath',
                          width: 66.72,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                              child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(strokeWidth: 2))),
                          fadeInCurve: Curves.easeIn,
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    name,
                    style: const TextStyle(
                        color: LightThemeColors.primary, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(subtitle),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.exception,
    required this.onPressed,
  });

  final AppException exception;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Assets.img.errorState.image(height: 150),
        const SizedBox(height: 54),
        Text(exception.message),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('Retry...'),
        ),
      ],
    );
  }
}

PreferredSize buildDefaultTabBar({required Text title}) {
  return PreferredSize(
    preferredSize: const Size(double.infinity, 64),
    child: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: LightThemeColors.primary.withValues(alpha: .9),
            centerTitle: true,
            title: title.data == 'CineMate' ? Assets.img.title.image(height: 24) : title),
      ),
    ),
  );
}
