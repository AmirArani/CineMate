import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/genre_model.dart';
import '../../utils/routes/route_data.dart';
import '../../utils/theme_data.dart';
import 'shimmers.dart';

class TopBackDrop extends StatelessWidget {
  final String backdropPath;

  const TopBackDrop({super.key, required this.backdropPath});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        child: CachedNetworkImage(
          height: 225,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          imageUrl: 'https://image.tmdb.org/t/p/w500$backdropPath',
          fadeInCurve: Curves.easeIn,
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade300,
            child: const Center(child: Icon(Icons.error)),
          ),
        ));
  }
}

class MainPoster extends StatelessWidget {
  final int id;
  final String posterPath;
  final String category;

  const MainPoster({super.key, required this.id, required this.posterPath, required this.category});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 170,
      left: 20,
      child: Hero(
        transitionOnUserGestures: true,
        tag: '$id$category',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: LightThemeColors.gray.withValues(alpha: 0.5),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w185$posterPath',
              width: 172,
              height: 257,
              fit: BoxFit.cover,
              fadeInCurve: Curves.easeIn,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleAndInfo extends StatelessWidget {
  final String title;
  final String? tagLine;
  final String originalLanguage;
  final double vote;
  final int? runtime;
  final List<GenreModel>? genres;

  const TitleAndInfo(
      {super.key,
      required this.title,
      required this.tagLine,
      required this.originalLanguage,
      required this.vote,
      required this.runtime,
      required this.genres});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 240,
      left: 205,
      width: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (tagLine != null)
                  ? Text(tagLine!)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        defBoxShim(height: 16, width: 150, margin: EdgeInsets.all(4)),
                        defBoxShim(height: 16, width: 80, margin: EdgeInsets.all(4)),
                      ],
                    ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: LightThemeColors.primary.withValues(alpha: 0.8),
                    ),
                    child: Text(
                      originalLanguage,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Icon(CupertinoIcons.star, size: 18),
                  const SizedBox(width: 4),
                  Text(vote.toStringAsFixed(1),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.normal)),
                  const SizedBox(width: 15),
                  (runtime != null)
                      ? Icon(CupertinoIcons.clock, size: 18, color: LightThemeColors.primary)
                      : SizedBox(),
                  const SizedBox(width: 4),
                  (runtime != null)
                      ? Text('${(runtime! / 60).toInt()}h ${runtime! % 60}m',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.normal))
                      : const SizedBox(),
                ],
              ),
              const SizedBox(height: 12),
              (genres != null)
                  ? Wrap(
                      clipBehavior: Clip.hardEdge,
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        for (var genre in genres!)
                          InkWell(
                            radius: 5,
                            onTap: () =>
                                DiscoverScreenRouteData(genreId: genre.id.toString()).push(context),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color(0xff858585),
                              ),
                              child: Text(
                                genre.name,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ],
                    )
                  : const GenresShimmer(),
            ],
          ),
        ],
      ),
    );
  }
}

class MovieAndShowTabBar extends StatelessWidget {
  final int id;
  final List<Widget> tabLabels;
  final List<Widget> tabs;
  final void Function(int index)? onTap;

  const MovieAndShowTabBar(
      {super.key,
      required this.id,
      required this.tabLabels,
      required this.tabs,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabLabels.length,
      child: SizedBox(
        height: 700,
        child: Scaffold(
          appBar: TabBar(
            physics: const BouncingScrollPhysics(),
            labelColor: LightThemeColors.primary,
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            unselectedLabelColor: LightThemeColors.primary.withValues(alpha: 0.4),
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: false,
            enableFeedback: false,
            automaticIndicatorColorAdjustment: true,
            indicatorWeight: 2,
            labelPadding: const EdgeInsets.symmetric(horizontal: 0),
            indicatorAnimation: TabIndicatorAnimation.elastic,
            onTap: onTap,
            tabs: tabLabels,
          ),
          body: TabBarView(children: tabs),
        ),
      ),
    );
  }
}
