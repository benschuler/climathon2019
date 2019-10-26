class Product {
  String name = "Apfel";
  bool okt;
}

class ProductList {
  getList() {
    var apfel = Product();
    apfel.okt = true;

    var erdbeeren = Product();
    erdbeeren.name = "Erdbeeren";
    erdbeeren.okt = false;

    var spargel = Product();
    spargel.name = "Spargel";
    spargel.okt = false;

    List<Product> list = new List(3);
    list[0] = apfel;
    list[1] = erdbeeren;
    list[2] = spargel;

    return list;
  }

  isProductInSeason(String productName){
    var inSeason = true;
    for(final Product product in getList()){
      if(product.name == productName){
        if(!product.okt) {
          inSeason = false;
        }
        break;
      }
    }
    return inSeason;

  }
}