import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reni_jaya_inventory/notifiers/category_notifier.dart';
import 'package:reni_jaya_inventory/notifiers/item_notifier.dart';
import 'package:reni_jaya_inventory/shared/constants.dart';
import 'package:reni_jaya_inventory/views/add_item_view.dart';
import 'package:reni_jaya_inventory/views/item_details_view.dart';

enum HomeViewType { category, item }

class HomeView extends StatefulWidget {
  final HomeViewType type;
  final String? categoryId;
  const HomeView({Key? key, required this.type, this.categoryId})
      : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FocusNode _focus = FocusNode();
  final TextEditingController _controller = TextEditingController();

  bool get isCategory {
    return _currentType == HomeViewType.category;
  }

  IconData? _appBarIcon;
  HomeViewType? _currentType;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    _currentType = widget.type;
    _appBarIcon = isCategory ? Icons.search : Icons.arrow_back;
    if (widget.categoryId != null) {
      Provider.of<ItemNotifier>(context, listen: false).setId(widget.categoryId!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _appBarIcon = _focus.hasFocus
          ? Icons.close
          : isCategory
              ? Icons.search
              : Icons.arrow_back;
    });
  }

  void _appBarIconPressed() {
    if (isCategory) {
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
    } else {
      Navigator.pop(context);
    }
  }

  void _onTapItem(String? id) async {
    if (id != null) {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => isCategory
                ? HomeView(
                    type: HomeViewType.item,
                    categoryId: id,
                  )
                : ItemDetailsView(itemId: id),
          ));
    }
  }

  void _onTapAddItem(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddItemView(isCategory: isCategory),
        ));
  }

  Scaffold _getScaffold(dynamic data) {
    CategoryNotifier? _categoryNotifier;
    ItemNotifier? _itemNotifier;
    if (isCategory) {
      _categoryNotifier = data as CategoryNotifier;
    } else {
      _itemNotifier = data as ItemNotifier;
    }
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
                    hintText: " Cari " + (isCategory ? "Kategori" : "Varian") + "...",
                  ),
                  onSubmitted: (cal) {
                    if (isCategory) {
                      _categoryNotifier?.searchCategories(cal);
                    } else {
                      _itemNotifier?.searchItems(cal);
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: Colors.white,
                onPressed: () {
                  _onTapAddItem(context);
                }
              ),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  isCategory ? "KATEGORI" : "VARIAN",
                  style: textHeaderStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: isCategory
                        ? _categoryNotifier?.categories.length
                        : _itemNotifier?.items.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => {
                          _onTapItem(isCategory
                              ? _categoryNotifier?.categories[index].categoryId
                              : _itemNotifier?.items[index].itemId),
                        },
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
                                child: Text(
                                  isCategory
                                      ? _categoryNotifier
                                              ?.categories[index].name ??
                                          ""
                                      : _itemNotifier?.items[index].name ?? "",
                                ),
                              ),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  isCategory
                                      ? ""
                                      : "${_itemNotifier?.items[index].quantity}",
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              const Icon(Icons.arrow_right),
                            ],
                          ),
                        ),
                      );
                      // Text(model.items[index].name);
                    }),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return isCategory
        ? Consumer<CategoryNotifier>(
            builder: (context, model, child) {
              return _getScaffold(model);
            },
          )
        : Consumer<ItemNotifier>(
          builder: (context, model, child) {
            return _getScaffold(model);
          },
        );
  }
}
