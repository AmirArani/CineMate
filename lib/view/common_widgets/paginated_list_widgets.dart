import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/model/movie_model.dart';
import '../../data/model/tv_show_model.dart';
import '../../gen/assets.gen.dart';
import '../../utils/routes/route_data.dart';
import '../../utils/theme_data.dart';
import 'shimmers.dart';

class ListMovieItem extends StatelessWidget {
  final MovieModel item;
  final int index;
  final PagingController<int, dynamic> _pagingController;
  final String cat;
  final Future<bool> Function() onDelete;

  const ListMovieItem(
      {super.key,
      required pagingController,
      required this.item,
      required this.onDelete,
      required this.index,
      required this.cat})
      : _pagingController = pagingController;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(index.toString()),
      background: DismissibleDeleteBackground(isSecondary: false),
      secondaryBackground: DismissibleDeleteBackground(isSecondary: true),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Delete!'),
            content: Text('Are you sure you want to delete ${item.title} form favorites?'),
            //TODO: make item title bold
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ).then((shouldDelete) async {
          if (shouldDelete == null) {
            return null;
          } else {
            try {
              final bool success = shouldDelete ? await onDelete() : false;

              success ? _pagingController.itemList?.removeAt(index) : null;
              (_pagingController.itemList!.isEmpty) ? _pagingController.refresh() : null;
              return success;
            } catch (e) {
              return false;
            }
          }
        });
      },
      child: GestureDetector(
        onTap: () =>
            MovieDetailRouteData(id: item.id, posterPath: item.posterPath, cat: cat).push(context),
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
          margin: index == 0
              ? EdgeInsets.fromLTRB(24, 24, 24, 8)
              : EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.overview,
                        style: Theme.of(context).textTheme.bodySmall,
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
                tag: '${item.id}$cat',
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
      ),
    );
  }
}

class ListShowItem extends StatelessWidget {
  final TvShowModel item;
  final int index;
  final PagingController<int, dynamic> _pagingController;
  final String cat;
  final Future<bool> Function() onDelete;

  const ListShowItem(
      {super.key,
      required pagingController,
      required this.item,
      required this.onDelete,
      required this.index,
      required this.cat})
      : _pagingController = pagingController;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(index.toString()),
      background: DismissibleDeleteBackground(isSecondary: false),
      secondaryBackground: DismissibleDeleteBackground(isSecondary: true),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Delete!'),
            content: Text('Are you sure you want to delete ${item.title} form favorites?'),
            //TODO: make item title bold
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ).then((shouldDelete) async {
          if (shouldDelete == null) {
            return null;
          } else {
            try {
              // final bool success =
              //     shouldDelete ? await accountRepo.editFavorite(item: item, delete: true) : false;
              final bool success = shouldDelete ? await onDelete() : false;

              success ? _pagingController.itemList?.removeAt(index) : null;
              (_pagingController.itemList!.isEmpty) ? _pagingController.refresh() : null;
              return success;
            } catch (e) {
              return false;
            }
          }
        });
      },
      child: GestureDetector(
        onTap: () => TvShowDetailRouteData(
          id: item.id,
          posterPath: item.posterPath,
          cat: cat,
        ).push(context),
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
          margin: index == 0
              ? EdgeInsets.fromLTRB(24, 24, 24, 8)
              : EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.overview,
                        style: Theme.of(context).textTheme.bodySmall,
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
                tag: '${item.id}$cat',
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
      ),
    );
  }
}

class DismissibleDeleteBackground extends StatelessWidget {
  final bool isSecondary;

  const DismissibleDeleteBackground({super.key, required this.isSecondary});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade200,
      child: Row(
        mainAxisAlignment: isSecondary ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class NewPageProgress extends StatelessWidget {
  const NewPageProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Lottie.asset('assets/animation/Animation_wait.json',
            repeat: true, frameRate: FrameRate.max, height: 50, width: 50),
      ),
    );
  }
}

class FirstPageProgress extends StatelessWidget {
  const FirstPageProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        defShim(child: ListItemShimmer(first: true)),
        defShim(child: ListItemShimmer(first: false)),
        defShim(child: ListItemShimmer(first: false)),
        defShim(child: ListItemShimmer(first: false)),
      ],
    );
  }
}

class ListItemShimmer extends StatelessWidget {
  final bool first;

  const ListItemShimmer({super.key, required this.first});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: LightThemeColors.tertiary,
        highlightColor: LightThemeColors.secondary,
        child: Container(
          height: 165,
          margin: first
              ? EdgeInsets.fromLTRB(24, 24, 24, 8)
              : EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: Colors.grey,
          ),
        ));
  }
}

class FirstPageError extends StatelessWidget {
  const FirstPageError({super.key, required pagingController, required this.title})
      : _pagingController = pagingController;

  final PagingController<int, dynamic> _pagingController;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.img.errorState2.image(width: 150, height: 150),
        SizedBox(height: 18),
        Text(
          'Loading $title Failed!',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Text('Please check your internet connection and try again.'),
        SizedBox(height: 18),
        PageRefreshButton(
          pagingController: _pagingController,
        ),
      ],
    );
  }
}

class NoItemsFound extends StatelessWidget {
  final String title;
  final String type;

  const NoItemsFound({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.img.emptyState.image(width: 150, height: 150),
        SizedBox(height: 18),
        Text(
          'No $title Found!',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Text('Please $type $title and check again.'),
      ],
    );
  }
}

class NoMoreItems extends StatelessWidget {
  final int? itemsCount;

  const NoMoreItems({super.key, this.itemsCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 32, 0, 24),
      child: Center(
          child: Column(
        spacing: 12,
        children: [
          itemsCount != null
              ? itemsCount != 1
                  ? Text('$itemsCount Items')
                  : Text('$itemsCount Item')
              : Text('No More Items!'),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: Colors.grey.shade500, shape: BoxShape.circle),
          )
        ],
      )),
    );
  }
}

class NewPageError extends StatelessWidget {
  const NewPageError({
    super.key,
    required pagingController,
  }) : _pagingController = pagingController;

  final PagingController<int, dynamic> _pagingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 32, 0, 24),
      child: Center(
          child: Column(
        spacing: 8,
        children: [
          Icon(Icons.error_outline_outlined, color: Colors.grey.shade500),
          Text('Loading Failed!'),
          PageRefreshButton(pagingController: _pagingController),
        ],
      )),
    );
  }
}

class PageRefreshButton extends StatelessWidget {
  const PageRefreshButton({super.key, required pagingController})
      : _pagingController = pagingController;

  final PagingController<int, dynamic> _pagingController;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () =>
          _pagingController.notifyPageRequestListeners(_pagingController.nextPageKey ?? 1),
      label: Text("Retry"),
      icon: Assets.img.icons.profile.reload.svg(),
      style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(LightThemeColors.primary)),
    );
  }
}

var tempMovie = MovieModel(
    id: -1,
    title: '',
    overview: '',
    originalLanguage: '',
    posterPath: '',
    backdropPath: '',
    releaseDate: '',
    vote: -1);
