import 'package:flutter/material.dart';

class ProductListWidget extends StatelessWidget {
  ProductListItem productListItem;

  ProductListWidget(String inText) {
    productListItem = new ProductListItem(inText);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text("Dummy")),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(productListItem.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductListItem {
  String text = "";

  ProductListItem(String inText) {
    this.text = inText;
  }
}