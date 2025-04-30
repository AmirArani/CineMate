import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemate/data/model/tv_show_model.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/model/credit_model.dart';
import '../../data/model/review_model.dart';
import '../../gen/assets.gen.dart';
import '../../utils/theme_data.dart';
import '../tv_show/tabsBloc/tv_show_tabs_bloc.dart';
import 'general_widgets.dart';
import 'shimmers.dart';

class TabOverview extends StatelessWidget {
  final PageController _controller = PageController(initialPage: 1, viewportFraction: 0.88);
  final String overView;
  final String releaseDate;
  final String? status;
  final String? originCountry;
  final String? homePageURL;
  final String? imdbId;
  final bool isShow;
  final EpisodeModel? nextEpisode;
  final EpisodeModel? lastEpisode;
  final bool isLoaded;
  final List<String>? backdropPaths;

  TabOverview(
      {super.key,
      required this.overView,
      required this.releaseDate,
      required this.status,
      required this.originCountry,
      required this.homePageURL,
      required this.imdbId,
      required this.isShow,
      required this.nextEpisode,
      required this.lastEpisode,
      required this.isLoaded,
      required this.backdropPaths});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.fromLTRB(32, 15, 32, 0), child: Text(overView)),
            // Show Next to air Episode;
            EpisodeBanner(nextEpisode: nextEpisode, lastEpisode: lastEpisode),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isShow ? 'First Air: $releaseDate' : 'Release Date: $releaseDate'),
                    (status != null) ? Text('Status: $status') : const SizedBox(),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  spacing: 10,
                  children: [
                    const Text('Origin Country: '),
                    (originCountry != null)
                        ? CountryFlag.fromCountryCode(originCountry!,
                            width: 30, height: 20, shape: const RoundedRectangle(4))
                        : defBoxShim(height: 20, width: 30, radius: 4, margin: EdgeInsets.zero),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                        onPressed: (!isLoaded || homePageURL == null || homePageURL!.isEmpty)
                            ? null
                            : () async {
                                if (await canLaunchUrl(Uri.parse(homePageURL!))) {
                                  await launchUrl(Uri.parse(homePageURL!),
                                      mode: LaunchMode.inAppBrowserView);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Could not open Homepage'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                        icon: const Icon(Icons.language),
                        label: const Text('Home Page')),
                    isShow
                        ? SizedBox()
                        : OutlinedButton.icon(
                            onPressed: (!isLoaded || imdbId == null || imdbId!.isEmpty)
                                ? null
                                : () async {
                                    if (await canLaunchUrl(
                                        Uri.parse('https://www.imdb.com/title/$imdbId'))) {
                                      await launchUrl(
                                          Uri.parse('https://www.imdb.com/title/$imdbId'),
                                          mode: LaunchMode.inAppBrowserView);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Could not openIMDb Page')),
                                      );
                                    }
                                  },
                            icon: (!isLoaded || imdbId == null || imdbId!.isEmpty)
                                ? Assets.img.icons.iMDbDisabled
                                    .image(height: 20, opacity: const AlwaysStoppedAnimation(.5))
                                : Assets.img.icons.iMDb.image(height: 20),
                            label: const Text('IMDb Page')),
                  ],
                )),
            BackdropSlider(
              controller: _controller,
              isLoaded: isLoaded,
              backdropPaths: backdropPaths,
            ),
            const SizedBox(height: 100),
          ],
        ));
  }
}

class EpisodeBanner extends StatelessWidget {
  const EpisodeBanner({
    super.key,
    required this.nextEpisode,
    required this.lastEpisode,
  });

  final EpisodeModel? nextEpisode;
  final EpisodeModel? lastEpisode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: (BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.3),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 5))
            ])),
        width: 350,
        child: nextEpisode != null
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Next Episode!',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  EpisodeListItem(episode: nextEpisode!, isSingle: true),
                ],
              )
            : lastEpisode != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Last Episode',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      EpisodeListItem(episode: lastEpisode!, isSingle: true),
                    ],
                  )
                : SizedBox(),
      ),
    );
  }
}

class BackdropSlider extends StatelessWidget {
  final PageController _controller;
  final List<String>? backdropPaths;
  final bool isLoaded;

  const BackdropSlider({
    super.key,
    required PageController controller,
    required this.backdropPaths,
    required this.isLoaded,
  }) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return (isLoaded && backdropPaths != null)
        ? Column(
            spacing: 10,
            children: [
              SizedBox(
                height: 220,
                child: PageView.builder(
                  // pageSnapping: true,
                  controller: _controller,
                  itemCount: backdropPaths!.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w400${backdropPaths![index]}',
                        fadeInCurve: Curves.easeIn,
                        fit: BoxFit.fill,
                        placeholder: (context, url) {
                          return Center(
                              child: defBoxShim(
                            height: 250,
                            width: MediaQuery.of(context).size.width * 0.91,
                          ));
                        },
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                child: SmoothPageIndicator(
                  count: backdropPaths!.length,
                  controller: _controller,
                  axisDirection: Axis.horizontal,
                  effect: SwapEffect(
                    spacing: 4,
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: LightThemeColors.primary,
                    dotColor: LightThemeColors.primary.withValues(alpha: .1),
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: defBoxShim(
            height: 220,
            width: MediaQuery.of(context).size.width * 0.88,
          ));
  }
}

class TabCastAndCrew extends StatelessWidget {
  final int id;
  final CreditModel? credits;
  final bool isLoading;
  final bool isFailed;

  const TabCastAndCrew(
      {super.key,
      required this.id,
      required this.credits,
      required this.isLoading,
      required this.isFailed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 32, 0),
      child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: (credits != null)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text('Cast', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: credits!.cast.length,
                      itemBuilder: (context, index) {
                        CastModel cast = credits!.cast[index];
                        return VerticalPersonListItem(
                          id: cast.id,
                          name: cast.name,
                          knownForDepartment: cast.knownForDepartment,
                          profilePath: cast.profilePath,
                          subtitle: cast.character,
                          category: 'casts$index$id',
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Crew',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: credits!.crew.length,
                      itemBuilder: (context, index) {
                        CrewModel crew = credits!.crew[index];
                        return VerticalPersonListItem(
                          id: crew.id,
                          name: crew.name,
                          knownForDepartment: crew.knownForDepartment,
                          profilePath: crew.profilePath,
                          subtitle: crew.job,
                          category: 'crews$index$id',
                        );
                      },
                    ),
                    SizedBox(height: 100)
                  ],
                )
              : (isLoading)
                  ? defShim(
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text('Cast', style: Theme.of(context).textTheme.titleLarge),
                          const PersonItemShimmer(),
                          const PersonItemShimmer(),
                          const PersonItemShimmer(),
                          const PersonItemShimmer(),
                        ],
                      ),
                    )
                  : (isFailed)
                      ? const TabErrorState(text: 'Loading Movie Credits Failed!')
                      : const SizedBox()),
    );
  }
}

class TabSeasonAndEpisode extends StatelessWidget {
  final TvShowDetailModel? showData;

  const TabSeasonAndEpisode(this.showData, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvShowTabsBloc, TvShowTabsState>(
      builder: (context, state) {
        if (showData == null) {
          // shimmer seasons:
          return VerticalListShimmer();
        } else {
          if (state.seasonsData == null) {
            if (state.isLoadingSeasons) {
              //shimmer episodes
              return SingleChildScrollView(
                child: ExpansionPanelList.radio(
                  dividerColor: Colors.transparent,
                  elevation: 0,
                  children: List.generate(
                    showData!.seasons.length,
                    (index) => buildSeasonListItem(
                      index: index,
                      season: showData!.seasons[index],
                      seasonData: null,
                    ),
                  ),
                ),
              );
            } else if (state.isSeasonsFailed) {
              // error state
              return const TabErrorState(text: 'Loading Seasons and Episodes Data Failed!');
            } else {
              // error state
              return const TabErrorState(text: 'Loading Seasons and Episodes Data Failed!');
            }
          } else {
            if (showData!.seasons.isEmpty) {
              // Empty state
              const TabEmptyState(text: 'No Seasons or Episodes Found!');
            } else {
              //success state
              return SingleChildScrollView(
                child: ExpansionPanelList.radio(
                  dividerColor: Colors.transparent,
                  elevation: 0,
                  children: List.generate(
                    showData!.seasons.length,
                    (index) => buildSeasonListItem(
                      index: index,
                      season: showData!.seasons[index],
                      seasonData: state.seasonsData![index],
                    ),
                  ),
                ),
              );
            }
          }
        }

        return SizedBox();
      },
    );
  }
}

ExpansionPanelRadio buildSeasonListItem(
    {required int index, required SeasonModel season, required SeasonDetailModel? seasonData}) {
  return ExpansionPanelRadio(
    value: index,
    splashColor: Colors.transparent,
    headerBuilder: (BuildContext context, bool isExpanded) {
      return Padding(
        padding: EdgeInsets.only(top: index == 0 ? 12 : 0),
        child: Column(
          children: [
            Container(
              decoration: (BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.3),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                  ])),
              margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w185${season.posterPath}',
                        height: isExpanded ? 200 : 130,
                        fit: BoxFit.cover,
                        fadeInCurve: Curves.easeIn,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(season.name,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontSize: isExpanded ? 20 : 18, fontWeight: FontWeight.w500)),
                        isExpanded
                            ? const SizedBox()
                            : Text(
                                season.overview,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                        Text(
                          'Air Date: ${season.airDate}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          width: 240,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Episodes: ${season.episodeCount}',
                                style: TextStyle(fontSize: 14),
                              ),
                              Row(
                                children: [
                                  const Icon(CupertinoIcons.star, size: 15),
                                  const SizedBox(width: 4),
                                  Text(season.vote.toStringAsFixed(1),
                                      style: TextStyle(fontSize: 14)),
                                  SizedBox(width: 8)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
    body: Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Text(season.overview),
          const SizedBox(height: 16),
          seasonData == null
              ? VerticalListShimmer()
              : ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: seasonData.episodes.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index2) =>
                      EpisodeListItem(episode: seasonData.episodes[index2]),
                )
        ],
      ),
    ),
    canTapOnHeader: true,
  );
}

class EpisodeListItem extends StatelessWidget {
  const EpisodeListItem({super.key, required this.episode, this.isSingle = false});

  final EpisodeModel episode;
  final bool isSingle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Row(
                      children: [
                        isSingle ? Text('Season ${episode.seasonNumber} | ') : SizedBox(),
                        Stack(
                          alignment: Alignment.center,
                          fit: StackFit.passthrough,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 0.8, color: Colors.blueGrey)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                              child: Text(episode.episodeNumber.toString(),
                                  style:
                                      const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ],
                    ),
                    Text(episode.name,
                        softWrap: true,
                        maxLines: 2,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(episode.airDate, style: TextStyle(fontSize: 14)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(CupertinoIcons.star, size: 15),
                            const SizedBox(width: 4),
                            Text(episode.vote.toStringAsFixed(1), style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(CupertinoIcons.clock, size: 15),
                            SizedBox(width: 4),
                            Text('${episode.runtime % 60}m', style: TextStyle(fontSize: 14)),
                            SizedBox(width: 8),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w185${episode.stillPath}',
                    height: 120,
                    fit: BoxFit.cover,
                    fadeInCurve: Curves.easeIn,
                    errorWidget: (context, url, error) => const Icon(Icons.error)),
              ),
            ],
          ),
          SizedBox(height: 12),
          ExpandableText(text: episode.overview),
          isSingle ? SizedBox() : Divider(thickness: 0.2),
        ],
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;
  final TextStyle? readMoreStyle;
  final TextStyle? readLessStyle; // Added style for "Read less..."

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 2,
    this.style,
    this.readMoreStyle,
    this.readLessStyle, // Initialize readLessStyle
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);
        final isTextOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.text,
                maxLines: _isExpanded ? null : widget.maxLines,
                overflow: _isExpanded ? null : TextOverflow.ellipsis,
                style: widget.style,
              ),
            ),
            if (isTextOverflowing) // Now condition is just if text overflows
              _isExpanded
                  ? InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      onTap: () {
                        setState(() {
                          _isExpanded = false; // Collapse text
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Read less',
                          style: widget.readLessStyle ??
                              TextStyle(color: Colors.blue), // Use readLessStyle
                        ),
                      ),
                    )
                  : InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _isExpanded = true; // Expand text
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Read more...',
                          style: widget.readMoreStyle ?? TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
          ],
        );
      },
    );
  }
}

class TabsReviews extends StatelessWidget {
  final int id;
  final List<ReviewModel>? reviews;
  final bool isLoading;
  final bool isFailed;

  const TabsReviews(
      {super.key,
      required this.id,
      required this.reviews,
      required this.isLoading,
      required this.isFailed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: (reviews != null)
            ? (reviews!.isNotEmpty)
                ? ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: reviews!.length + 1,
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.grey, thickness: 0.5),
                    itemBuilder: (context, index) {
                      return index == reviews!.length
                          ? SizedBox(height: 100)
                          : ReviewItem(
                              avatar: reviews![index].avatar,
                              author: reviews![index].author,
                              content: reviews![index].content,
                              url: reviews![index].url,
                            );
                    },
                  )
                : const TabEmptyState(text: 'No Reviews Found!')
            : (isLoading)
                ? const ReviewListShimmer()
                : (isFailed)
                    ? const TabErrorState(text: 'Loading Reviews Failed!')
                    : const SizedBox());
  }
}

class ReviewItem extends StatefulWidget {
  const ReviewItem({
    super.key,
    required this.avatar,
    required this.author,
    required this.content,
    required this.url,
  });

  final String avatar;
  final String author;
  final String content;
  final String url;

  @override
  State<ReviewItem> createState() => ReviewItemState();
}

class ReviewItemState extends State<ReviewItem> {
  bool extended = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageUrl: widget.avatar.contains('gravatar')
                    ? widget.avatar.substring(1)
                    : 'https://image.tmdb.org/t/p/w185${widget.avatar}',
                fadeInCurve: Curves.easeIn,
                width: 48,
                height: 48,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.author,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            const Expanded(child: SizedBox()),
            TextButton(
                onPressed: () => setState(() => extended = !extended),
                child: Row(
                  children: [
                    extended
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(CupertinoIcons.arrow_down_right_arrow_up_left),
                          )
                        : const SizedBox(),
                    Text(
                      extended ? 'Collapse' : 'Read More',
                      style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                    ),
                  ],
                ))
          ],
        ),
        const SizedBox(height: 8),
        extended
            ? Text(widget.content)
            : Text(
                widget.content,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class TabSimilar extends StatelessWidget {
  final int id;
  final List<dynamic>? items;
  final bool isLoading;
  final bool isFailed;
  final bool isMovie;

  const TabSimilar(
      {super.key,
      required this.id,
      required this.items,
      required this.isLoading,
      required this.isFailed,
      required this.isMovie});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              (items != null)
                  ? (items!.isNotEmpty)
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items!.length,
                          itemBuilder: (context, index) => VerticalListItem(
                            item: items![index],
                            category: 'similar',
                            // isMovie: isMovie,
                          ),
                        )
                      : const TabEmptyState(text: 'No Items Found!')
                  : (isLoading)
                      ? const VerticalListShimmer()
                      : (isFailed)
                          ? const TabErrorState(text: 'Loading Similar Items Failed!')
                          : const SizedBox(),
              SizedBox(height: 100)
            ])));
  }
}

class TabEmptyState extends StatelessWidget {
  final String text;

  const TabEmptyState({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        Center(child: Assets.img.emptyState.image(height: 180)),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500))
      ],
    );
  }
}

class TabErrorState extends StatelessWidget {
  final String text;

  const TabErrorState({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        Center(child: Assets.img.errorState2.image(height: 180)),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500))
      ],
    );
  }
}
