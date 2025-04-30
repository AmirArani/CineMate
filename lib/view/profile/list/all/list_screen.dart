import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemate/data/repo/list_repo.dart';
import 'package:cinemate/utils/routes/route_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../../data/model/list_model.dart';
import '../../../../utils/theme_data.dart';
import '../../../common_widgets/paginated_list_widgets.dart';
import 'bloc/list_bloc.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListBloc(),
      child: _ListsView(),
    );
  }
}

class _ListsView extends StatelessWidget {
  const _ListsView();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ListBloc>();

    return BlocListener<ListBloc, ListState>(
      listener: (context, state) {
        // Handle external preference changes if needed
      },
      child: Scaffold(
        floatingActionButton: NewListBtn(bloc: bloc, ctx: context),
        appBar: AppBar(
          backgroundColor: LightThemeColors.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text("Lists"),
        ),
        body: RefreshIndicator(
          onRefresh: () => Future.sync(() => bloc.pagingController.refresh()),
          child: PagedListView<int, ListModel>(
            pagingController: bloc.pagingController,
            builderDelegate: PagedChildBuilderDelegate<ListModel>(
              itemBuilder: (context, item, index) => ListItem(
                  item: item,
                  index: index,
                  onTap: () {
                    ListDetailScreenRouteData(id: item.id).push(context);
                  }),
              firstPageErrorIndicatorBuilder: (context) =>
                  FirstPageError(pagingController: bloc.pagingController, title: 'Lists'),
              firstPageProgressIndicatorBuilder: (context) => Center(
                  child: Lottie.asset('assets/animation/Animation_wait.json',
                      animate: true, repeat: true)),
              newPageErrorIndicatorBuilder: (context) =>
                  NewPageError(pagingController: bloc.pagingController),
              newPageProgressIndicatorBuilder: (context) => const NewPageProgress(),
              noItemsFoundIndicatorBuilder: (context) =>
                  const NoItemsFound(type: 'create a', title: 'List'), //todo: change
            ),
          ),
        ),
      ),
    );
  }
}

class NewListBtn extends StatefulWidget {
  const NewListBtn({
    super.key,
    required this.bloc,
    required this.ctx,
  });

  final ListBloc bloc;
  final BuildContext ctx;

  @override
  State<NewListBtn> createState() => _NewListBtnState();
}

class _NewListBtnState extends State<NewListBtn> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'newList',
      onPressed: () {
        showModalBottomSheet(
          enableDrag: false,
          isScrollControlled: true,
          useRootNavigator: true,
          context: context,
          builder: (context) {
            return _NewListModal(bloc: widget.bloc);
          },
        );
      },
      icon: Icon(Icons.add),
      label: Text('Create New List'),
    );
  }
}

class ListItem extends StatelessWidget {
  final ListModel item;
  final int index;
  final VoidCallback onTap;

  const ListItem({super.key, required this.item, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 100,
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
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            item.backdropPath.isNotEmpty
                ? Align(
                    alignment: Alignment.centerRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: 'https://image.tmdb.org/t/p/original${item.backdropPath}',
                            fit: BoxFit.fill,
                            fadeInCurve: Curves.easeIn,
                            errorWidget: (context, url, error) => SizedBox(),
                          ),
                          Positioned.fill(
                              child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.white.withAlpha(240), Colors.white38])),
                          )),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: LightThemeColors.primary.withValues(alpha: 0.6),
                            ),
                            child: Text(
                              item.itemCount == 1
                                  ? '${item.itemCount} item'
                                  : '${item.itemCount} items',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: LightThemeColors.primary.withValues(alpha: 0.6),
                              ),
                              child: Icon(
                                item.public ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                                size: 20,
                                color: item.public ? Colors.white.withAlpha(200) : Colors.white,
                              )),
                        ],
                      ),
                    ],
                  ),
                  item.desc.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Text(
                            item.desc,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                'Last Update: ${DateFormat('yyyy-MM-dd').format(item.updatedAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewListModal extends StatefulWidget {
  final ListBloc bloc;

  const _NewListModal({required this.bloc});

  @override
  State<_NewListModal> createState() => _NewListModalState();
}

class _NewListModalState extends State<_NewListModal> {
  bool public = true;
  bool loading = false;
  final TextEditingController nameTEC = TextEditingController()..text = '';
  final TextEditingController descTEC = TextEditingController()..text = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16, // Add keyboard height padding
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
                'Create a new List',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Divider(thickness: 0.5),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
              child: Column(
                spacing: 18,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    style: TextStyle(fontSize: 15),
                    controller: nameTEC,
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
                    controller: descTEC,
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
                      Text(public ? 'Public List' : 'Private List'),
                      Switch(
                          value: public,
                          onChanged: (value) {
                            setState(() {
                              public = !public;
                            });
                          })
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Icon(Icons.info_outline_rounded),
                      Flexible(
                          child: Text(
                              'You can set list backdrop after adding some items to it, in "Edit List" page."'))
                    ],
                  ),
                  ElevatedButton(
                    onPressed: loading
                        ? null
                        : () async {
                            setState(() {
                              loading = true;
                            });
                            final bool success = await listRepo.createNewList(
                                name: nameTEC.text, desc: descTEC.text, public: public);

                            setState(() {
                              success ? widget.bloc.pagingController.refresh() : null;
                              loading = false;
                            });
                            Navigator.pop(context);
                          },
                    style: ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(Size(200, 24)),
                      backgroundColor: WidgetStatePropertyAll(LightThemeColors.primary),
                      foregroundColor: WidgetStatePropertyAll(LightThemeColors.onPrimary),
                    ),
                    child: loading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: LightThemeColors.onPrimary, strokeWidth: 1))
                        : Text('Submit'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
