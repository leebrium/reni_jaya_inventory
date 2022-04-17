import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reni_jaya_inventory/models/item_model.dart';
import 'package:reni_jaya_inventory/notifiers/item_notifier.dart';
import 'package:reni_jaya_inventory/shared/constants.dart';
import 'package:reni_jaya_inventory/shared/utils.dart';
import 'package:reni_jaya_inventory/views/add_item_view.dart';

class ItemDetailsView extends StatefulWidget {
  final String itemId;

  const ItemDetailsView({Key? key, required this.itemId}) : super(key: key);

  @override
  State<ItemDetailsView> createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends State<ItemDetailsView> {
  void _onEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => AddItemView(
                itemId: widget.itemId,
                isCategory: false,
              )),
    );
  }

  Widget _divider() {
    return Column(children: const [
      SizedBox(height: 8),
      Divider(height: 1),
      SizedBox(height: 8),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final itemNotifier = Provider.of<ItemNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Expanded(child: Text("Detail Barang")),
            IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.white,
                onPressed: () {
                  _onEdit();
                }),
          ],
        ),
      ),
      body: FutureBuilder<Item?>(
          future: itemNotifier.getItemDetails(widget.itemId),
          builder: (BuildContext context, AsyncSnapshot<Item?> snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      snapshot.data!.imagePath!,
                      height: 360,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getTitleAndContent("Nama", snapshot.data!.name),
                          _divider(),
                          getTitleAndContent(
                              "Stok", snapshot.data!.quantity.toString()),
                          _divider(),
                          getTitleAndContent("Deskripsi",
                              snapshot.data!.description.toString())
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Kosong'));
            }
          }),
    );
  }
}
