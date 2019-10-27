class ProductCarbonData {
  double emissions;
  String productCategory;
  int weight;
  double weightedEmissions;

  //ProductCarbonData(double inEmissions, String inCategory, int inWeight) {
  ProductCarbonData(double inEmissions, String inCategory, int inWeight) {
    //this.product = inProduct;
    this.emissions = inEmissions;
    this.productCategory = inCategory;
    this.weight = inWeight;
    this.weightedEmissions = weight * emissions;
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

List<Suggestion> getSuggestions(List<String> inS_list, Map<String, ProductCarbonData> products, Map<String, List<String>> categories) {
  List<Suggestion> suggs = <Suggestion>[];
  for (var j = 0; j < inS_list.length; j++) {
    String inS = inS_list[j];
    List<String> relatedProducts = categories[products[inS].productCategory];
    List<Suggestion> p_suggs = <Suggestion>[];
    for (var i = 0; i < relatedProducts.length; i++) {
      String p = relatedProducts[i];
      if (products[inS].emissions > products[p].emissions) {
        double redEm = products[inS].weightedEmissions - products[p].emissions * products[inS].weight;
        Suggestion s = new Suggestion(inS, p, redEm);
        p_suggs.add(s);
      }
    }
    p_suggs.sort((a, b) => b.reducedEmissions.compareTo(a.reducedEmissions));
    suggs.addAll(p_suggs.getRange(0, 3));
  }
  suggs.sort((a, b) => b.reducedEmissions.compareTo(a.reducedEmissions));
  return suggs;
}