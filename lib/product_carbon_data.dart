import 'package:flutter/material.dart';

class ProductCarbonData {
  String product;
  double emissions;
  String productCategory;

  ProductCarbonData(String inProduct, double inEmissions, String inCategory) {
    this.product = inProduct;
    this.emissions = inEmissions;
    this.productCategory = inCategory;
  }

}

class ProductWidget extends StatelessWidget {
  ProductCarbonData productCarbonData;

  ProductWidget(ProductCarbonData productData) {
    this.productCarbonData = productData;
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
                child: new Text(productCarbonData.product),
              ),
            ],
          ),
        ],
      ),
    );
  }
}