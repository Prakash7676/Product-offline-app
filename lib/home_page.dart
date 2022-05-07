import 'dart:math';

import 'package:flutter/material.dart';
import 'package:product_offline_app/databsehelper.dart';
import 'package:product_offline_app/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Product> products;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshProduct();
  }

  void refreshProduct() async {
    setState(() {
      loading = true;
    });
    products = await DatabaseHelper.instance.listAllProduct();
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    DatabaseHelper.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  DatabaseHelper.instance.addProduct(Product(
                      title: "Iphone" + Random().nextInt(500).toString(),
                      description: "This is Description"));
                  refreshProduct();
                },
                icon: Icon(Icons.add))
          ],
          title: Text("PMS"),
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : products.isEmpty
                ? Text("No Product Found")
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (ctx, i) {
                      return ListTile(
                        title: Text(products[i].title),
                        subtitle: Text(products[i].description),
                      );
                    }));
  }
}
