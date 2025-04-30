import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/list_model.dart';
import '../../../../data/model/media_model.dart';
import '../../../../data/repo/list_repo.dart';
import '../../../../utils/routes/route_data.dart';
import '../../../../utils/theme_data.dart';
import '../../../common_widgets/paginated_list_widgets.dart';
import '../../../common_widgets/shimmers.dart';
import 'bloc/list_detail_bloc.dart';

class ListDetailItem extends StatelessWidget {
  final ListDetailIemModel listItem;
  final int index;
  final String cat = 'List';

  const ListDetailItem({super.key, required this.listItem, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListDetailBloc, ListDetailState>(
      builder: (blocContext, state) {
        final bloc = context.read<ListDetailBloc>();

        return (state is ListDetailLoadSuccess)
            ? Dismissible(
                key: Key(index.toString()),
                background: DismissibleDeleteBackground(isSecondary: false),
                secondaryBackground: DismissibleDeleteBackground(isSecondary: true),
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Delete!'),
                      content: Text(listItem.media.mediaType == MediaType.movie
                          ? 'Are you sure you want to delete "${listItem.media.movie!.title}" form "${state.listData.name}" list?'
                          : listItem.media.mediaType == MediaType.tv
                              ? 'Are you sure you want to delete "${listItem.media.show!.title}" form "${state.listData.name}" list?'
                              : ''),
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
                        final bool success = shouldDelete
                            ? await listRepo.deleteItemFromList(
                                media: listItem.media, listId: state.listData.id)
                            : false;

                        success ? bloc.pagingController.itemList?.removeAt(index) : null;
                        (bloc.pagingController.itemList!.isEmpty)
                            ? bloc.pagingController.refresh()
                            : null;
                        return success;
                      } catch (e) {
                        return false;
                      }
                    }
                  });
                },
                child: GestureDetector(
                  onTap: () => listItem.media.mediaType == MediaType.movie
                      ? MovieDetailRouteData(
                              id: listItem.media.movie!.id,
                              posterPath: listItem.media.movie!.posterPath,
                              cat: cat)
                          .push(context)
                      : listItem.media.mediaType == MediaType.tv
                          ? TvShowDetailRouteData(
                                  id: listItem.media.show!.id,
                                  posterPath: listItem.media.show!.posterPath,
                                  cat: cat)
                              .push(context)
                          : null,
                  child: Column(
                    children: [
                      Container(
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
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listItem.media.mediaType == MediaType.movie
                                          ? listItem.media.movie!.title
                                          : listItem.media.mediaType == MediaType.tv
                                              ? listItem.media.show!.title
                                              : '',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      listItem.media.mediaType == MediaType.movie
                                          ? listItem.media.movie!.overview
                                          : listItem.media.mediaType == MediaType.tv
                                              ? listItem.media.show!.overview
                                              : '',
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
                                                color:
                                                    LightThemeColors.primary.withValues(alpha: 0.8),
                                              ),
                                              child: Text(
                                                listItem.media.mediaType == MediaType.movie
                                                    ? listItem.media.movie!.originalLanguage
                                                    : listItem.media.mediaType == MediaType.tv
                                                        ? listItem.media.show!.originalLanguage
                                                        : '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.normal),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            const Icon(CupertinoIcons.star, size: 18),
                                            const SizedBox(width: 4),
                                            Text(
                                                listItem.media.mediaType == MediaType.movie
                                                    ? listItem.media.movie!.vote.toStringAsFixed(1)
                                                    : listItem.media.mediaType == MediaType.tv
                                                        ? listItem.media.show!.vote
                                                            .toStringAsFixed(1)
                                                        : '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(fontWeight: FontWeight.normal)),
                                          ],
                                        ),
                                        Text(
                                          listItem.media.mediaType == MediaType.movie
                                              ? listItem.media.movie!.releaseDate
                                              : listItem.media.mediaType == MediaType.tv
                                                  ? listItem.media.show!.releaseDate
                                                  : '',
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
                              tag: '${getMediaId(listItem.media)}$cat',
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(14),
                                  bottomRight: Radius.circular(14),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: listItem.media.mediaType == MediaType.movie
                                      ? 'https://image.tmdb.org/t/p/w185${listItem.media.movie!.posterPath}'
                                      : listItem.media.mediaType == MediaType.tv
                                          ? 'https://image.tmdb.org/t/p/w185${listItem.media.show!.posterPath}'
                                          : '',
                                  width: 110,
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(36, 0, 36, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                listItem.comment ?? '',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  BlocProvider.of<ListDetailBloc>(blocContext)
                                      .add(OpenCommentModalEvent(state: state, item: listItem));

                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: blocContext,
                                    builder: (modalContext) {
                                      return BlocProvider.value(
                                        value: bloc,
                                        child: _EditCommentModal(
                                            itemToEdit: listItem, listId: state.listData.id),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.edit_note_outlined))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox();
      },
    );
  }
}

class _EditCommentModal extends StatelessWidget {
  final ListDetailIemModel itemToEdit;
  final int listId;

  const _EditCommentModal({required this.itemToEdit, required this.listId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListDetailBloc, ListDetailState>(
      listener: (context, state) async {
        if (state is ListDetailLoadSuccess) {
          if (state.closeSuccess) {
            Navigator.of(context).pop();

            if (state.deleteLoading) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Comment deleted!')));
            } else if (state.editLoading) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Comment Edited!')));
            }

            context.read<ListDetailBloc>().pagingController.refresh();
          } else if (state.closeFailed) {
            state.editLoading
                ? ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Edit Comment Failed!')))
                : (state.deleteLoading)
                    ? ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Delete Comment Failed!')))
                    : null;
          }
        }
      },
      builder: (context, state) {
        return (state is ListDetailLoadSuccess)
            ? SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom + 16, // Add keyboard height padding
                ),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0, // Ensure minimum height
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
                        child: Text(
                          'Edit Comment',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Divider(thickness: 0.5),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
                        child: Column(
                          spacing: 18,
                          children: [
                            TextField(
                              style: TextStyle(fontSize: 15),
                              controller: state.commentTEC,
                              decoration: InputDecoration(
                                  filled: true,
                                  hintText: itemToEdit.media.mediaType == MediaType.movie
                                      ? 'Write your comment for "${itemToEdit.media.movie!.title}" here'
                                      : itemToEdit.media.mediaType == MediaType.tv
                                          ? 'Write your comment for "${itemToEdit.media.show!.title}" here'
                                          : '',
                                  border:
                                      OutlineInputBorder(borderRadius: BorderRadius.circular(28))),
                              maxLines: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 24,
                              children: [
                                ElevatedButton(
                                  onPressed: state.editLoading
                                      ? null
                                      : () async => BlocProvider.of<ListDetailBloc>(context).add(
                                          SubmitCommentEvent(
                                              itemToEdit: itemToEdit,
                                              state: state,
                                              listId: listId)),
                                  style: ButtonStyle(
                                    fixedSize: WidgetStatePropertyAll(Size(200, 24)),
                                    backgroundColor:
                                        WidgetStatePropertyAll(LightThemeColors.primary),
                                    foregroundColor:
                                        WidgetStatePropertyAll(LightThemeColors.onPrimary),
                                  ),
                                  child: state.editLoading
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: LightThemeColors.onPrimary,
                                            strokeWidth: 1,
                                          ))
                                      : Text('Submit'),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    return await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Delete!'),
                                          content:
                                              Text('Are you sure you want to delete your comment?'),
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
                                        );
                                      },
                                    ).then(
                                      (shouldDelete) async {
                                        if (shouldDelete == true) {
                                          try {
                                            BlocProvider.of<ListDetailBloc>(context).add(
                                                DeleteCommentEvent(
                                                    itemToEdit: itemToEdit,
                                                    state: state,
                                                    listId: listId));
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content:
                                                      Text('Delete Comment Failed! Try Again...')));
                                            }
                                          }
                                        }
                                      },
                                    );
                                  },
                                  icon: state.deleteLoading
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: LightThemeColors.onPrimary,
                                            strokeWidth: 1,
                                          ))
                                      : Icon(
                                          Icons.delete_outline_rounded,
                                          color: Colors.red.shade700,
                                          size: 25,
                                        ),
                                  color: Colors.redAccent,
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(Colors.red.shade100)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox();
      },
    );
  }
}
