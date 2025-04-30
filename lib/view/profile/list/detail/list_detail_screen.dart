import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/model/list_model.dart';
import '../../../../utils/routes/route_data.dart';
import '../../../../utils/theme_data.dart';
import '../../../common_widgets/paginated_list_widgets.dart';
import '../../../common_widgets/rating_bar.dart';
import '../all/bloc/list_bloc.dart';
import 'bloc/list_detail_bloc.dart';
import 'edit_bloc/list_edit_bloc.dart';
import 'listItemWidgets.dart';

class ListDetailScreen extends StatelessWidget {
  final int listId;

  const ListDetailScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListDetailBloc, ListDetailState>(
      builder: (context, state) {
        final bloc = context.read<ListDetailBloc>();

        return Scaffold(
          body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 200,
                    actions: [
                      (state is ListDetailLoadSuccess && state.listData.public)
                          ? IconButton.filled(
                              onPressed: () async {
                                try {
                                  await Share.share(
                                      'Hey CineMate... 💚\nLook at my list named ${state.listData.name}: https://www.themoviedb.org/list/${state.listData.id}\nDownload CineMate app now for free: ...'); //todo: add stores link
                                } catch (e) {
                                  throw Exception('Share Link Failed');
                                }
                              },
                              icon: Icon(CupertinoIcons.link))
                          : SizedBox(),
                      SizedBox(width: 8),
                      (state is ListDetailLoadSuccess)
                          ? IconButton.filled(
                              onPressed: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  useRootNavigator: true,
                                  context: context,
                                  builder: (context) {
                                    BlocProvider.of<ListEditBloc>(context).add(OpenListEditEvent(
                                        public: state.listData.public,
                                        name: state.listData.name,
                                        desc: state.listData.desc,
                                        listData: state.listData));
                                    return BlocProvider(
                                      create: (context) => ListEditBloc()
                                        ..add(OpenListEditEvent(
                                          public: state.listData.public,
                                          name: state.listData.name,
                                          desc: state.listData.desc,
                                          listData: state.listData,
                                        )),
                                      child: _EditListModal(),
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.edit))
                          : SizedBox(),
                      SizedBox(width: 16)
                    ],
                    floating: false,
                    pinned: true,
                    stretch: true,
                    backgroundColor: LightThemeColors.primary,
                    foregroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: Stack(
                        children: [
                          (state is ListDetailLoadSuccess && state.listData.backdropPath.isNotEmpty)
                              ? CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/original${state.listData.backdropPath}',
                                  fit: BoxFit.cover,
                                  height: 350,
                                  width: MediaQuery.of(context).size.width,
                                  fadeInCurve: Curves.easeIn,
                                  errorWidget: (context, url, error) => SizedBox(),
                                )
                              : SizedBox(),
                          Positioned.fill(
                            child: Container(
                              padding: EdgeInsets.all(24),
                              decoration: (state is ListDetailLoadSuccess &&
                                      state.listData.backdropPath.isNotEmpty)
                                  ? null
                                  : BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                          colors: [
                                            LightThemeColors.secondary,
                                            LightThemeColors.tertiary
                                          ]),
                                    ),
                              child: (state is ListDetailLoadSuccess)
                                  ? Center(
                                      child: Column(
                                      spacing: 12,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: (state.listData.backdropPath.isNotEmpty)
                                              ? BoxDecoration(boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black87,
                                                      blurStyle: BlurStyle.normal,
                                                      blurRadius: 24)
                                                ])
                                              : null,
                                          child: Text(
                                            'Created by ${state.createdBy}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: LightThemeColors.onPrimary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          decoration: (state.listData.backdropPath.isNotEmpty)
                                              ? BoxDecoration(boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black87,
                                                      blurStyle: BlurStyle.normal,
                                                      blurRadius: 24)
                                                ])
                                              : null,
                                          child: Text(
                                            state.listData.desc,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: LightThemeColors.onPrimary),
                                          ),
                                        ),
                                        RatingBar.readOnly(
                                          alignment: Alignment.bottomCenter,
                                          initialRating: state.listData.averageRating / 2,
                                        )
                                      ],
                                    ))
                                  : SizedBox(),
                            ),
                          ),
                        ],
                      ),
                      collapseMode: CollapseMode.parallax,
                      title: (state is ListDetailLoadSuccess)
                          ? Text(state.listData.name,
                              style: TextStyle(
                                color: LightThemeColors.onPrimary,
                                fontSize: 16.0,
                              ))
                          : SizedBox(),
                    ),
                  ),
                ];
              },
              body: RefreshIndicator(
                onRefresh: () => Future.sync(() => bloc.pagingController.refresh()),
                child: PagedListView<int, ListDetailIemModel>(
                  shrinkWrap: false,
                  pagingController: bloc.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<ListDetailIemModel>(
                    itemBuilder: (context, item, index) =>
                        ListDetailItem(listItem: item, index: index),
                    firstPageErrorIndicatorBuilder: (context) => FirstPageError(
                        pagingController: bloc.pagingController, title: 'List items'),
                    firstPageProgressIndicatorBuilder: (context) => const FirstPageProgress(),
                    newPageErrorIndicatorBuilder: (context) =>
                        NewPageError(pagingController: bloc.pagingController),
                    newPageProgressIndicatorBuilder: (context) => const NewPageProgress(),
                    noItemsFoundIndicatorBuilder: (context) =>
                        const NoItemsFound(type: 'add', title: 'Items'),
                    noMoreItemsIndicatorBuilder: (context) => NoMoreItems(
                      itemsCount: bloc.pagingController.itemList!.length,
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }
}

class _EditListModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListEditBloc, ListEditState>(
      listener: (context, state) async {
        if (state is ListEditLoaded) {
          if (state.closeSuccess) {
            await Future.delayed(Duration(seconds: 1));

            BlocProvider.of<ListBloc>(context).add(ListRefreshRequested());

            await Future.delayed(Duration(seconds: 1));

            context.mounted ? ListsScreenRouteData().go(context) : null;

            if (state.deleteLoading) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('"${state.listData.name}" deleted!'),
                behavior: SnackBarBehavior.floating,
              ));
            } else if (state.editLoading) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('"${state.listData.name}" Edited!'),
                behavior: SnackBarBehavior.floating,
              ));

              ListDetailScreenRouteData(id: state.listData.id).go(context);
            }
          } else if (state.closeFailed) {
            state.editLoading
                ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Edit List Failed!'),
                    behavior: SnackBarBehavior.floating,
                  ))
                : (state.deleteLoading)
                    ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Delete List Failed!'),
                        behavior: SnackBarBehavior.floating,
                      ))
                    : null;
          }
        }
      },
      builder: (context, state) {
        return (state is ListEditLoaded)
            ? SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom + 16, // Add keyboard height padding
                ),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.4, // Ensure minimum height
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
                        child: Text(
                          'Edit List',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Divider(thickness: 0.5),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 12, 32, 32),
                        child: Column(
                          spacing: 18,
                          children: [
                            TextField(
                              style: TextStyle(fontSize: 15),
                              controller: state.nameTEC,
                              decoration: InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(fontSize: 15),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(50))),
                              maxLines: 1,
                            ),
                            TextField(
                              style: TextStyle(fontSize: 15),
                              controller: state.descTEC,
                              decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle: TextStyle(fontSize: 15),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(50))),
                              maxLines: 2,
                              minLines: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(state.public ? 'Public List' : 'Private List'),
                                Switch(
                                    value: state.public,
                                    onChanged: (value) {
                                      BlocProvider.of<ListEditBloc>(context).add(
                                          ListEditChangePublicEvent(value: value, state: state));
                                    })
                              ],
                            ),
                            OutlinedButton(
                                onPressed: () async {
                                  if (state.listData.itemCount == 0) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            'To add Image for your list, First you need to ad some items to it...')));
                                  } else {
                                    await launchUrl(
                                      Uri.parse(
                                          "https://www.themoviedb.org/list/${state.listData.id}/edit?active_nav_item=step_3"),
                                      mode: LaunchMode.inAppBrowserView,
                                    );
                                  }
                                },
                                child: Text('Change List Image')),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 24,
                              children: [
                                ElevatedButton(
                                  onPressed: state.editLoading
                                      ? null
                                      : () async {
                                          BlocProvider.of<ListEditBloc>(context)
                                              .add(ListEditSubmitEvent(state: state));
                                        },
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
                                          content: Text(
                                              'Are you sure you want to delete ${state.listData.name} form your lists?'),
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
                                            BlocProvider.of<ListEditBloc>(context)
                                                .add(ListDeleteSubmitEvent(state: state));
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content:
                                                      Text('Delete List Failed! Try Again...')));
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
