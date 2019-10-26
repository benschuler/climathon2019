class ProductCarbonData {
  double emissions;
  String productCategory;
  //int weight;

  //ProductCarbonData(double inEmissions, String inCategory, int inWeight) {
  ProductCarbonData(double inEmissions, String inCategory) {
    //this.product = inProduct;
    this.emissions = inEmissions;
    this.productCategory = inCategory;
  }
}

class Suggestion {
  String old;
  String sugg;
  double reducedEmissions;

  Suggestion(String inOld, String inSugg, double r) {
    this.old = inOld;
    this.sugg = inSugg;
    this.reducedEmissions = r;
  }

}

List<Suggestion> getSuggestions(String inS, Map<String, ProductCarbonData> products, List<String> relatedProducts) {
  List<Suggestion> suggs = <Suggestion>[];
  for (var i = 0; i < relatedProducts.length; i++) {
    String p = relatedProducts[i];
    if (products[inS].emissions > products[p].emissions) {
      Suggestion s = new Suggestion(inS, p, products[inS].emissions - products[p].emissions);
      suggs.add(s);
    }
  }
  return suggs;
}