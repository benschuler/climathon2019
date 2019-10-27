import 'package:flutter/material.dart';

class ShoppingListItemWidget extends StatelessWidget {
  ShoppingListItem shoppingListItem;

  ShoppingListItemWidget(String inText) {
    shoppingListItem = new ShoppingListItem(inText);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text("Dummy")),
          ),*/
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(shoppingListItem.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShoppingListItem {
  String text = "";

  ShoppingListItem(String inText) {
    this.text = inText;
  }
}