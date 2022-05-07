import 'dart:math';

import 'package:flutter/material.dart';
import 'package:product_offline_app/add_product.dart';
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
                  refreshProduct();
                },
                icon: Icon(Icons.refresh))
          ],
          title: Text("PMS"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddorUpdateProduct(true,
                        p: Product(id: 1, description: "", title: ""))));

            refreshProduct();
          },
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 20.0,
                                color: Colors.brown[900],
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddorUpdateProduct(
                                              false,
                                              p: products[i],
                                            )));

                                refreshProduct();
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 20.0,
                                color: Colors.brown[900],
                              ),
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Do you want to  delete?"),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                bool result =
                                                    await DatabaseHelper
                                                        .instance
                                                        .deleteProduct(
                                                            products[i].id!);
                                                if (result) {
                                                  refreshProduct();
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Text("Confirm Delete")),
                                          OutlinedButton(
                                              onPressed: () {
                                                // Go Back
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel"))
                                        ],
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      );
                    }));
  }
}
