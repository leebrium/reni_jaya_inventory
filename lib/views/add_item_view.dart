import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reni_jaya_inventory/models/item_model.dart';
import 'package:reni_jaya_inventory/notifiers/item_notifier.dart';
import 'package:reni_jaya_inventory/services/storage.dart';
import 'package:reni_jaya_inventory/shared/button_submit.dart';
import 'package:reni_jaya_inventory/shared/constants.dart';
import 'package:reni_jaya_inventory/shared/loading.dart';
import 'package:reni_jaya_inventory/views/image_getter/image_getter.dart';

class AddItemView extends StatefulWidget {
  final String? itemId;
  const AddItemView({Key? key, this.itemId}) : super(key: key);

  @override
  State<AddItemView> createState() => _AddItemViewState();
}

class _AddItemViewState extends State<AddItemView> {
  final _formKey = GlobalKey<FormState>();
  final _nameFieldController = TextEditingController();
  final _quantityFieldController = TextEditingController();
  String? imagePath;
  String? networkImagePath;
  bool _loading = false;

  Widget _takePictureButton() {
    return CustomButtonSubmit(
      onPressed: _openCamera,
      width: 160,
      height: 40,
      text: "Ambil Gambar",
    );
  }

  Widget _imageView(BuildContext context, Item? item) {
    return Stack(children: [
      Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: item == null
              ? imagePath == null
                  ? _takePictureButton()
                  : GestureDetector(
                      onTap: _openCamera,
                      child: Image.file(
                        File(imagePath!),
                      ),
                    )
              : GestureDetector(
                  onTap: _openCamera,
                  child: imagePath == null
                      ? Image.network(item.imagePath!)
                      : Image.file(File(imagePath!))),
        ),
      ),
      Positioned(
        left: 8,
        child: Container(
          padding: EdgeInsets.only(left: 5, right: 5),
          color: Colors.white,
          child: Text(
            'Gambar',
            style: TextStyle(fontSize: 15, color: Colors.blue),
          ),
        ),
      ),
    ]);
  }

  void _openCamera() async {
    final path = await Navigator.push(
      context,
      MaterialPageRoute(
          fullscreenDialog: true, builder: (context) => ImageGetter()),
    );
    setState(() => imagePath = path);
  }

  void _saveData(BuildContext context, Item item) async {
    final itemNotifier = Provider.of<ItemNotifier>(context, listen: false);
    if (widget.itemId == null) {
      if (imagePath == null) {
        return;
      }
      setState(() {
        _loading = true;
      });
      StorageServiceResult? resultStorage = await StorageService()
          .uploadImage(imageToUpload: File(imagePath!), title: "");

      if (resultStorage != null) {
        item.imagePath = resultStorage.imageUrl;
        await itemNotifier.insertNewItem(item);
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _loading = true;
      });
      if (imagePath != null) {
        StorageServiceResult? resultStorage = await StorageService()
            .uploadImage(imageToUpload: File(imagePath!), title: "");

        if (resultStorage != null) {
          item.imagePath = resultStorage.imageUrl;
        }
      } else {
        item.imagePath = networkImagePath;
      }

      item.itemId = widget.itemId;
      await itemNotifier.insertNewItem(item);
      Navigator.pop(this.context);
      itemNotifier.notifyListeners();
    }
  }

  Widget _scrollView(BuildContext context, Item? item) {
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
            child: Column(
              children: [
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Masukkan Nama Barang";
                    } else {
                      return null;
                    }
                  },
                  controller: _nameFieldController,
                  decoration:
                      textInputDecoration.copyWith(labelText: "Nama Barang"),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 12),
                TextFormField(
                  validator: (val) {
                    if (val == "") {
                      _quantityFieldController.text = "1";
                    }
                    return null;
                  },
                  controller: _quantityFieldController,
                  decoration: textInputDecoration.copyWith(labelText: "Stok"),
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                _imageView(context, item),
                SizedBox(height: 20),
                CustomButtonSubmit(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Item item = Item(
                          name: _nameFieldController.text,
                          quantity: int.parse(_quantityFieldController.text));
                      _saveData(context, item);
                    }
                  },
                  height: 40,
                  text: "Simpan",
                  width: 120,
                )
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            widget.itemId == null ? 'Tambah Barang' : "Edit Barang",
          ),
        ),
        body: _loading
            ? Loading()
            : widget.itemId != null
                ? FutureBuilder<Item?>(
                    future: Provider.of<ItemNotifier>(context)
                        .getItemDetails(widget.itemId!),
                    builder:
                        (BuildContext context, AsyncSnapshot<Item?> snapshot) {
                      _nameFieldController.text = snapshot.data?.name ?? "";
                      _quantityFieldController.text =
                          snapshot.data?.quantity.toString() ?? "1";
                      networkImagePath = snapshot.data?.imagePath;
                      if (snapshot.hasData) {
                        return _scrollView(context, snapshot.data);
                      } else {
                        return Center(
                          child: Text('Kosong'),
                        );
                      }
                    })
                : _scrollView(context, null));
  }
}
