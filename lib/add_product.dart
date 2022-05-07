import 'dart:math';

import 'package:flutter/material.dart';
import 'package:product_offline_app/databsehelper.dart';
import 'package:product_offline_app/product.dart';

class AddorUpdateProduct extends StatelessWidget {
  final bool isAdded;
  Product p;
  AddorUpdateProduct(this.isAdded, {required this.p});

  TextEditingController cTitle = TextEditingController();
  TextEditingController cDesc = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (!isAdded) {
      cTitle.text = p.title;
      cDesc.text = p.description;
    }
    return Scaffold(
      appBar: AppBar(
        title: isAdded ? Text("Add Product") : Text("Update Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: cTitle,
                  decoration: InputDecoration(labelText: "Title"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  }),
              TextFormField(
                  controller: cDesc,
                  decoration: InputDecoration(labelText: "Description"),
                  maxLength: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  }),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (isAdded) {
                        DatabaseHelper.instance.addProduct(Product(
                            title: cTitle.text, description: cDesc.text));
                      } else {
                        bool result = await DatabaseHelper.instance
                            .updateProduct(Product(
                                id: p.id,
                                title: cTitle.text,
                                description: cDesc.text));
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: isAdded ? Text("Add") : Text("Update"))
            ],
          ),
        ),
      ),
    );
  }
}
