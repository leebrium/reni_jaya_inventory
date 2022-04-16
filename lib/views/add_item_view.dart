import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reni_jaya_inventory/models/category_model.dart';
import 'package:reni_jaya_inventory/models/item_model.dart';
import 'package:reni_jaya_inventory/notifiers/category_notifier.dart';
import 'package:reni_jaya_inventory/notifiers/item_notifier.dart';
import 'package:reni_jaya_inventory/services/storage.dart';
import 'package:reni_jaya_inventory/shared/button_submit.dart';
import 'package:reni_jaya_inventory/shared/constants.dart';
import 'package:reni_jaya_inventory/shared/loading.dart';
import 'package:reni_jaya_inventory/views/image_getter/image_getter.dart';

class AddItemView extends StatefulWidget {
  final String? itemId;
  final bool isCategory;
  const AddItemView({Key? key, this.itemId, required this.isCategory})
      : super(key: key);

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
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
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
          child: const Text(
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

  void _saveCategory(Category cat) async {
    final catNotifier = Provider.of<CategoryNotifier>(context, listen: false);
    await catNotifier.pushCategory(cat);
    Navigator.pop(context);
  }

  void _saveItem(BuildContext context, Item item) async {
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
        await itemNotifier.pushItem(item);
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
      await itemNotifier.pushItem(item);
      Navigator.pop(this.context);
      itemNotifier.notifyListeners();
    }
  }

  Widget _nameTextField() {
    final infoString = widget.isCategory ? "Varian" : "Barang";
    return TextFormField(
      validator: (val) {
        if (val!.isEmpty) {
          return "Masukkan Nama " + infoString;
        } else {
          return null;
        }
      },
      controller: _nameFieldController,
      decoration: textInputDecoration.copyWith(labelText: "Nama " + infoString),
      style: const TextStyle(fontSize: 20),
    );
  }

  Widget _submitButton() {
    return CustomButtonSubmit(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (widget.isCategory) {
            Category cat = Category(name: _nameFieldController.text);
            _saveCategory(cat);
          } else {
            Item item = Item(
                name: _nameFieldController.text,
                quantity: int.parse(_quantityFieldController.text));
            _saveItem(context, item);
          }
        }
      },
      height: 40,
      text: "Simpan",
      width: 120,
    );
  }

  Widget _scrollView(BuildContext context, Item? item) {
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
            child: widget.isCategory
                ? Column(
                    children: [
                      _nameTextField(),
                      const SizedBox(height: 20),
                      _submitButton()
                    ],
                  )
                : Column(
                    children: [
                      _nameTextField(),
                      const SizedBox(height: 12),
                      TextFormField(
                        validator: (val) {
                          if (val == "") {
                            _quantityFieldController.text = "1";
                          }
                          return null;
                        },
                        controller: _quantityFieldController,
                        decoration:
                            textInputDecoration.copyWith(labelText: "Stok"),
                        style: const TextStyle(fontSize: 20),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _imageView(context, item),
                      const SizedBox(height: 20),
                      _submitButton()
                    ],
                  ),
          )),
    );
  }

  Widget _addItemContentView() {
    return FutureBuilder<Item?>(
        future:
            Provider.of<ItemNotifier>(context).getItemDetails(widget.itemId!),
        builder: (BuildContext context, AsyncSnapshot<Item?> snapshot) {
          _nameFieldController.text = snapshot.data?.name ?? "";
          _quantityFieldController.text =
              snapshot.data?.quantity.toString() ?? "1";
          networkImagePath = snapshot.data?.imagePath;
          if (snapshot.hasData) {
            return _scrollView(context, snapshot.data);
          } else {
            return const Center(
              child: Text('Kosong'),
            );
          }
        });
  }

  Widget _addCategoryContentView() {
    return FutureBuilder<Category?>(
        future: Provider.of<CategoryNotifier>(context)
            .getCategoryDetails(widget.itemId!),
        builder: (BuildContext context, AsyncSnapshot<Category?> snapshot) {
          _nameFieldController.text = snapshot.data?.name ?? "";
          if (snapshot.hasData) {
            return _scrollView(context, null);
          } else {
            return const Center(
              child: Text('Kosong'),
            );
          }
        });
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
            ? const Loading()
            : widget.itemId != null
                ? widget.isCategory
                    ? _addCategoryContentView()
                    : _addItemContentView()
                : _scrollView(context, null));
  }
}
