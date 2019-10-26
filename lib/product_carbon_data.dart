import 'product_category.dart';

class ProductCarbonData {
  String product;
  int carbonPer100G;
  ProductCategory productCategory;

  ProductCarbonData(String inProduct, int inCarbon, ProductCategory inCategory) {
    this.product = inProduct;
    this.carbonPer100G = inCarbon;
    this.productCategory = inCategory;
  }

}