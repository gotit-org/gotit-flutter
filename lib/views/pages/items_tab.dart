import 'package:flutter/material.dart';
import 'package:gotit/views/widgets/empty_state.dart';
import 'package:gotit/views/widgets/item_card.dart';
import 'package:gotit/presenters/item_presenter.dart';
import 'package:gotit/views/widgets/progress_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;

class ItemsTab extends StatefulWidget {
  final bool isUserTab, lostItems;
  ItemsTab({this.isUserTab = false, this.lostItems = true});
  @override
  State<StatefulWidget> createState() => ItemsState();
}

class ItemsState extends State<ItemsTab> {
  ItemPresenter itemPresenter = ItemPresenter();
  int itemCount = 0;
  int pageNo = 1;
  int pageSize = 10;

  void loadItems() {
    if(context == null) return;
    ProgressDialog.show(
      context: context,
      isCircular: false,
      method: () =>  itemPresenter.getItems(pageNo, pageSize, widget.isUserTab ? 'user/items' : 'item', widget.lostItems).then((value) {
        if(!mounted) return;
        setState(() {
          if(itemPresenter.items != null) {
            itemCount = itemPresenter.items.length;
          } else {
            itemCount = 0;
          }
        });
      })
    );
  }

  @override
  void initState() {
    super.initState();
    itemCount = 0;
    Future.delayed(Duration.zero, loadItems);
  }

  @override
  Widget build(BuildContext context) {
    itemCount = itemPresenter.items.length;
    return itemCount > 0 ? ListView.builder(
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index){
        return ItemCard(
          userName: itemPresenter.items[index].user.name,
          userImage: itemPresenter.items[index].user.picture,
          content: itemPresenter.items[index].content,
          date: timeago.format(itemPresenter.items[index].creationDate),
          images: itemPresenter.items[index].images,
          id: itemPresenter.items[index].id,
          attributes: itemPresenter.items[index].attributes,
          isFirst: index == 0,
        );
      },
    ) : EmptyState(
      image: 'assets/images/no_items.png',
      message: 'There is no items',
    );
  }
}
