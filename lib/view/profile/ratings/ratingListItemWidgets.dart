import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../data/model/rating_model.dart';
import '../../../data/repo/account_repo.dart';
import '../../../utils/routes/route_data.dart';
import '../../../utils/theme_data.dart';
import '../../common_widgets/paginated_list_widgets.dart';
import '../../common_widgets/rating_bar.dart';
import '../../common_widgets/shimmers.dart';

class ListRatedMovieItem extends StatefulWidget {
  final RatedMovieModel item;
  final int index;
  final PagingController<int, RatedMovieModel> _pagingController;
  final String cat;

  const ListRatedMovieItem(
      {super.key,
      required pagingController,
      required this.item,
      required this.index,
      required this.cat})
      : _pagingController = pagingController;

  @override
  State<ListRatedMovieItem> createState() => _ListRatedMovieItemState();
}

class _ListRatedMovieItemState extends State<ListRatedMovieItem> {
  double? newRate;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.index.toString()),
      background: DismissibleDeleteBackground(isSecondary: false),
      secondaryBackground: DismissibleDeleteBackground(isSecondary: true),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Delete!'),
            content: Text('Are you sure you want to delete Rating of ${widget.item.movie.title}?'),
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
              final bool success =
                  shouldDelete ? await accountRepo.deleteRating(item: widget.item) : false;
              success ? widget._pagingController.itemList?.removeAt(widget.index) : null;
              (widget._pagingController.itemList!.isEmpty)
                  ? widget._pagingController.refresh()
                  : null;
              return success;
            } catch (e) {
              return false;
            }
          }
        });
      },
      child: GestureDetector(
        onTap: () => MovieDetailRouteData(
                id: widget.item.movie.id, posterPath: widget.item.movie.posterPath, cat: widget.cat)
            .push(context),
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
          margin: widget.index == 0
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
                        widget.item.movie.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.item.movie.overview,
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
                                  widget.item.movie.originalLanguage,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Icon(CupertinoIcons.star, size: 18),
                              const SizedBox(width: 4),
                              Text(widget.item.movie.vote.toStringAsFixed(1),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontWeight: FontWeight.normal)),
                            ],
                          ),
                          RatingBar.readOnly(
                            size: 20,
                            initialRating: newRate ?? widget.item.rate / 2,
                            onRatingChanged: (p0) {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 48),
                                    child: Column(
                                      spacing: 8,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Change Rating',
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                        Text(widget.item.movie.title),
                                        Divider(thickness: 0.1),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          spacing: 24,
                                          children: [
                                            RatingBar(
                                              alignment: Alignment.center,
                                              initialRating: widget.item.rate / 2,
                                              size: 35,
                                              onRatingChanged: (p0) async {
                                                try {
                                                  final bool success = await accountRepo.editRating(
                                                      item: widget.item, newRating: p0 * 2);

                                                  setState(() {
                                                    if (success) {
                                                      newRate = p0;
                                                    }
                                                  });

                                                  if (ctx.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        behavior: SnackBarBehavior.floating,
                                                        content: success
                                                            ? Text(
                                                                'Your rating for "${widget.item.movie.title}" updated!')
                                                            : Text(
                                                                'Updating Rate Failed! Try Again...')));

                                                    Navigator.pop(context);
                                                  }
                                                } catch (e) {
                                                  if (ctx.mounted) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Updating Rate Failed! Try Again...'),
                                                      behavior: SnackBarBehavior.floating,
                                                    ));
                                                  }
                                                }
                                              },
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                try {
                                                  final bool success = await accountRepo
                                                      .deleteRating(item: widget.item);
                                                  if (ctx.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        behavior: SnackBarBehavior.floating,
                                                        content: success
                                                            ? Text(
                                                                'Your rating for "${widget.item.movie.title}" deleted!')
                                                            : Text(
                                                                'Delete Rating Failed! Try Again...')));

                                                    Navigator.pop(context);

                                                    success
                                                        ? widget._pagingController.refresh()
                                                        : null;
                                                  }
                                                } catch (e) {
                                                  if (ctx.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        behavior: SnackBarBehavior.floating,
                                                        content: Text(
                                                            'Delete Rating Failed! Try Again...')));
                                                  }
                                                }
                                              },
                                              icon: Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.red.shade700,
                                                size: 25,
                                              ),
                                              color: Colors.redAccent,
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(Colors.red.shade100)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Hero(
                transitionOnUserGestures: true,
                tag: '${widget.item.movie.id}${widget.cat}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w185${widget.item.movie.posterPath}',
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

class ListRatedShowsItem extends StatefulWidget {
  final RatedShowModel item;
  final int index;
  final PagingController<int, RatedShowModel> _pagingController;
  final String cat;

  const ListRatedShowsItem(
      {super.key,
      required pagingController,
      required this.item,
      required this.index,
      required this.cat})
      : _pagingController = pagingController;

  @override
  State<ListRatedShowsItem> createState() => _ListRatedShowsItemState();
}

class _ListRatedShowsItemState extends State<ListRatedShowsItem> {
  double? newRate;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.index.toString()),
      background: DismissibleDeleteBackground(isSecondary: false),
      secondaryBackground: DismissibleDeleteBackground(isSecondary: true),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Delete!'),
            content: Text('Are you sure you want to delete Rating of ${widget.item.show.title}?'),
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
              final bool success =
                  shouldDelete ? await accountRepo.deleteRating(item: widget.item) : false;
              success ? widget._pagingController.itemList?.removeAt(widget.index) : null;
              (widget._pagingController.itemList!.isEmpty)
                  ? widget._pagingController.refresh()
                  : null;
              return success;
            } catch (e) {
              return false;
            }
          }
        });
      },
      child: GestureDetector(
        onTap: () => MovieDetailRouteData(
                id: widget.item.show.id, posterPath: widget.item.show.posterPath, cat: widget.cat)
            .push(context),
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
          margin: widget.index == 0
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
                        widget.item.show.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.item.show.overview,
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
                                  widget.item.show.originalLanguage,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Icon(CupertinoIcons.star, size: 18),
                              const SizedBox(width: 4),
                              Text(widget.item.show.vote.toStringAsFixed(1),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontWeight: FontWeight.normal)),
                            ],
                          ),
                          RatingBar.readOnly(
                            size: 20,
                            initialRating: newRate ?? widget.item.rate / 2,
                            onRatingChanged: (p0) {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 48),
                                    child: Column(
                                      spacing: 8,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Change Rating',
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                        Text(widget.item.show.title),
                                        Divider(thickness: 0.1),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          spacing: 24,
                                          children: [
                                            RatingBar(
                                              alignment: Alignment.center,
                                              initialRating: widget.item.rate / 2,
                                              size: 35,
                                              onRatingChanged: (p0) async {
                                                try {
                                                  final bool success = await accountRepo.editRating(
                                                      item: widget.item, newRating: p0 * 2);

                                                  setState(() {
                                                    if (success) {
                                                      newRate = p0;
                                                    }
                                                  });

                                                  if (ctx.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: success
                                                            ? Text(
                                                                'Your rating for "${widget.item.show.title}" updated!')
                                                            : Text(
                                                                'Updating Rate Failed! Try Again...')));

                                                    Navigator.pop(context);
                                                  }
                                                } catch (e) {
                                                  if (ctx.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Updating Rate Failed! Try Again...')));
                                                  }
                                                }
                                              },
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                try {
                                                  final bool success = await accountRepo
                                                      .deleteRating(item: widget.item);
                                                  if (ctx.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: success
                                                            ? Text(
                                                                'Your rating for "${widget.item.show.title}" deleted!')
                                                            : Text(
                                                                'Delete Rating Failed! Try Again...')));

                                                    Navigator.pop(context);

                                                    success
                                                        ? widget._pagingController.refresh()
                                                        : null;
                                                  }
                                                } catch (e) {
                                                  if (ctx.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Delete Rating Failed! Try Again...')));
                                                  }
                                                }
                                              },
                                              icon: Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.red.shade700,
                                                size: 25,
                                              ),
                                              color: Colors.redAccent,
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(Colors.red.shade100)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Hero(
                transitionOnUserGestures: true,
                tag: '${widget.item.show.id}${widget.cat}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w185${widget.item.show.posterPath}',
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
