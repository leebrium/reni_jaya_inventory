import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reni_jaya_inventory/models/item_model.dart';
import 'package:reni_jaya_inventory/notifiers/item_notifier.dart';
import 'package:reni_jaya_inventory/shared/constants.dart';
import 'package:reni_jaya_inventory/views/add_item_view.dart';

class ItemDetailsView extends StatefulWidget {
  final String itemId;

  const ItemDetailsView({Key? key, required this.itemId}) : super(key: key);

  @override
  State<ItemDetailsView> createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends State<ItemDetailsView> {
  void _onEdit() async {
    final path = await Navigator.push(
      context,
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => AddItemView(
                itemId: widget.itemId,
                isCategory: false,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemNotifier = Provider.of<ItemNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Detail Barang"),
      ),
      body: FutureBuilder<Item?>(
          future: itemNotifier.getItemDetails(widget.itemId),
          builder: (BuildContext context, AsyncSnapshot<Item?> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Image.network(
                    snapshot.data!.imagePath!,
                    height: 360,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Nama',
                    style: textHeaderStyle,
                  ),
                  Text(snapshot.data!.name),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Stok',
                    style: textHeaderStyle,
                  ),
                  Text(snapshot.data!.quantity.toString()),
                ],
              );
            } else {
              return Center(child: Text('Kosong'));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _onEdit,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
