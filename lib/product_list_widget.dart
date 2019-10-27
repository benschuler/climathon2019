import 'package:flutter/material.dart';

class ProductListWidget extends StatelessWidget {
  ProductListItem productListItem;

  ProductListWidget(String inText, String category, double co2, bool inSeason) {
    productListItem = new ProductListItem(inText, category, co2, inSeason);
    /*if (!inSeason) {
      productListItem = new ProductListItem(inText + ", außer Saison", category, co2);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    if(this.productListItem.inSeason) {
      return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                child: new Text(productListItem.co2.toString()),
                backgroundColor: _determineColor(productListItem.co2),
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(productListItem.text),
                ),
                new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(productListItem.category,
                        style: TextStyle(color: Colors.black54))),
              ],
            ),
          ],
        ),
      );
    }

    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(
              child: new Text(productListItem.co2.toString()),
              backgroundColor: _determineColor(productListItem.co2),
            ),
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.warning),
                color: Colors.green,
                ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(productListItem.text),
              ),
              new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(productListItem.category,
                      style: TextStyle(color: Colors.black54))),
            ],
          ),
        ],
      ),
    );
  }

  _determineColor(double co2) {
    if (co2 < 0.20) {
      return Colors.green;
    } else if (co2 < 0.40) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}

class ProductListItem {
  String text = "";
  String category = "";
  double co2 = 0;
  bool inSeason = true;

  ProductListItem(String inText, String inCategory, double inco2, bool inInSeason) {
    this.text = inText;
    this.category = inCategory;
    this.co2 = inco2;
    this.inSeason = inInSeason;
  }
}
