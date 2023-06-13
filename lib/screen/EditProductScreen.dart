import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_application_1/Provider/Products.dart";
import "package:provider/provider.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

import "../Models/Product.dart";

class EditProductScreen extends StatefulWidget {
  static const routeName = 'editScreen';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var _imageController = TextEditingController();
  var _imageUrlFocusNode = FocusNode();
  var _form = GlobalKey<FormState>();

  var _editedProduct = Product(id: "", title: "", image: "", price: 0);

  var _initValues = {
    'title': '',
    'price': '',
    'imageUrl': '',
  };

  var _isinit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final productId = ModalRoute.of(context)!.settings.arguments;

      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId.toString());
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageController.text = _editedProduct.image;
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _imageUrlFocusNode.addListener(updateImageUrl);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageUrlFocusNode.dispose();
    _imageController.dispose();
    _imageUrlFocusNode.removeListener(updateImageUrl);
  }

  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageController.text.isEmpty ||
          (!_imageController.text.startsWith("http"))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() async {
    final validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != "") {
      await Provider.of<Products>(context, listen: false)
          .updatedProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct,context);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('An error occur'),
                  content: const Text("Something went wrong"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Okay"))
                  ],
                ));
      }
      //  finally {
      //   setState(() {
      //     Navigator.of(context).pop();
      //     _isLoading = false;
      //   });
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitFadingCircle(
                color: Colors.blueAccent,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(
                          label: Text("Title"),
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: newValue as String,
                              image: _editedProduct.image,
                              price: _editedProduct.price,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please provide a title";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(label: Text("Price")),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            image: _editedProduct.image,
                            price: double.parse(newValue!),
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please provide a price";
                          }
                          if (double.tryParse(value) == null) {
                            return "please enter a valid number";
                          }
                          if (double.parse(value) <= 0) {
                            return "please enter a  number greater than 0";
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                  width: 1,
                                )),
                            child: _imageController.text.isEmpty
                                ? Center(
                                    child: Text(
                                    "Enter a URl",
                                    textAlign: TextAlign.center,
                                  ))
                                : FittedBox(
                                    child: Image.network(
                                      _imageController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Image Url"),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  image: newValue as String,
                                  price: _editedProduct.price,
                                  isFavorite: _editedProduct.isFavorite,
                                );
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please provide a image";
                                } else if (!value.startsWith('http')) {
                                  return "The value should start with http";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
