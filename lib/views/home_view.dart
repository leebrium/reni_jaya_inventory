import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reni_jaya_inventory/models/item_model.dart';
import 'package:reni_jaya_inventory/notifiers/item_notifier.dart';
import 'package:reni_jaya_inventory/shared/loading.dart';
import 'package:reni_jaya_inventory/views/add_item_view.dart';
import 'package:reni_jaya_inventory/views/item_details_view.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FocusNode _focus = FocusNode();
  TextEditingController _controller = TextEditingController();

  IconData _appBarIcon = Icons.search;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _appBarIcon = _focus.hasFocus ? Icons.close : Icons.search;
    });
  }

  void _appBarIconPressed() {
    if (_appBarIcon == Icons.search) {
      setState(() {
        _appBarIcon = Icons.close;
      });
      _focus.requestFocus();
    } else {
      setState(() {
        _appBarIcon = Icons.search;
      });
      _controller.clear();
      _focus.unfocus();
    }
  }

  void _onTapItem(String? id) async {
    if (id != null) {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsView(itemId: id),
          ));
    }
  }

  void _onTapAddItem() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddItemView(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemNotifier>(
      builder: (context, model, child) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(_appBarIcon),
                color: Colors.white,
                onPressed: _appBarIconPressed,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.white,
                      controller: _controller,
                      focusNode: _focus,
                      decoration: InputDecoration(
                        hintText: ' Cari...',
                      ),
                      onSubmitted: (cal) {
                        model.searchItems(cal);
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    color: Colors.white,
                    onPressed: _onTapAddItem,
                  ),
                ],
              ),
            ),
            body: Scrollbar(
                child: NotificationListener<ScrollEndNotification>(
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: ListView.builder(
                    itemCount: model.items.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => {_onTapItem(model.items[index].itemId)},
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 4, left: 8, right: 8, bottom: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text("${model.items[index].name}"),
                              ),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  "${model.items[index].quantity}",
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Icon(Icons.arrow_right),
                            ],
                          ),
                        ),
                      );
                      // Text(model.items[index].name);
                    }),
              ),
              onNotification: (notification) {
                // For pagination
                // model.fetchItems();
                return true;
              },
            )));
      },
    );
  }
}
