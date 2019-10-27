import 'dart:collection';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:zero2app/carbonHandler.dart';

import 'product_list_widget.dart';
import 'shopping_list_item.dart';

import 'package:csv/csv.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

import 'suggestion_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zero2 Shopping app',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Zero2 Shopping app Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Some controllers to control UI elements
  final TextEditingController _textController = new TextEditingController();
  final TextEditingController _textControllerTotalCart = new TextEditingController();
  List<ShoppingListItemWidget> _items = <ShoppingListItemWidget>[];
  List<ShoppingListItemWidget> _itemsTemp = <ShoppingListItemWidget>[];
  Map<String, List<String>> _categories = new HashMap();
  int _selectedIndex = 0;
  int _pageIndex = 0;
  double _originalCartCo2 = 0.0;

  double savedEmissions = 0;

  List<String> shoppingList = <String>[];

  //List<ProductCarbonData> _products = <ProductCarbonData>[];
  Map<String, ProductCarbonData> _products = new HashMap();
  List<ProductListWidget> _productWidgets = <ProductListWidget>[];

  List<SuggestionWidget> _suggestionWidgets = <SuggestionWidget>[];

  Future<String> loadAsset(String path) async {
    //here comes the list which we read in
    return await rootBundle.loadString(path);
  }

  @override
  void initState() {
    rootBundle.loadString('data/products.csv').then((dynamic output) {
      List<List<dynamic>> _csv =
          const CsvToListConverter(fieldDelimiter: ',', eol: "\n")
              .convert(output);
      for (List<dynamic> x in _csv) {
        print(x);
      }
      setState(() {
        for (var i = 0; i < _csv.length; i++) {
          ProductCarbonData p =
              new ProductCarbonData(_csv[i][2], _csv[i][1], _csv[i][4], _csv[i][5]);
          _products[_csv[i][0]] = p;
          if (!_categories.containsKey(_csv[i][1])) {
            _categories[_csv[i][1]] = new List<String>();
          }
          _categories[_csv[i][1]].add(_csv[i][0]);
        }
      });
      _createProductWidgets();
    });
  }

  void _createProductWidgets() {
    ProductListWidget myWidget;

    /*for(String p in _products.keys) {
      ProductCarbonData product = _products[p];
      myWidget = new ProductListWidget(p, product.productCategory, product.emissions);
      _productWidgets.add(myWidget);
    }*/
    for (String category in _categories.keys) {
      String first = _categories[category][0];
      List<ProductListWidget> listForCategory = new List();
      for (String productKey in _categories[category]) {
        ProductCarbonData product = _products[productKey];
        myWidget = new ProductListWidget(
            productKey, product.productCategory, product.emissions, product.inSeason);
        listForCategory.add(myWidget);
      }
      listForCategory.sort(
          (a, b) => b.productListItem.co2.compareTo(a.productListItem.co2));
      for (ProductListWidget widget in listForCategory) {
        _productWidgets.add(widget);
      }
    }
  }

  void _createSuggestionWidgets(List<Suggestion> inSuggs) {
    SuggestionWidget myWidget;
    _suggestionWidgets.clear();

    for(Suggestion sug in inSuggs) {
      myWidget = new SuggestionWidget(sug, this.sugCallback);
      _suggestionWidgets.add(myWidget);
    }
  }

  void sugCallback(Suggestion inSug) {
    setState(() {
      _itemsTemp = new List<ShoppingListItemWidget>();
      ShoppingListItemWidget suggestedItem;

      for(ShoppingListItemWidget item in _items) {
        if(item.shoppingListItem.text == inSug.old) {
          suggestedItem = new ShoppingListItemWidget(inSug.sugg);
          savedEmissions += inSug.reducedEmissions / 100;
        } else {
          suggestedItem = new ShoppingListItemWidget(item.shoppingListItem.text);
        }
        _itemsTemp.add(suggestedItem);
      }
      _textControllerTotalCart.text = _updateCartEmissions();
      _items = _itemsTemp;
    });
  }

  void _handleSubmitted(String text) {
    //get list of suggestions like this
    //List<String> inputProducts = <String>[];

    shoppingList.add(text);
    _originalCartCo2 =
        _originalCartCo2 + getCo2PerPackageForProduct(text, _products);

    List<Suggestion> suggs =
        getSuggestions(shoppingList, _products, _categories);
    print(suggs[0].reducedEmissions);

    _createSuggestionWidgets(suggs);

    _textController.clear();
    _textControllerTotalCart.text = _updateCartEmissions();

    if (_products.containsKey(text)) {
      ShoppingListItemWidget item = new ShoppingListItemWidget(text);
      setState(() {
        int pos = _items.length;
        _items.insert(pos, item);
      });
    } else {
      _textController.text = 'nicht gefunden';
    }
  }

  String _updateCartEmissions() {
    String output = savedEmissions.toStringAsFixed(2) + " Kg Co2";

    return output;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    if (_products == null) {
      return new Container();
    }

    var page1 = Column(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTotalCartEmissions(),
        ),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
        new Divider(height: 1.0),
        new Flexible(
          child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            itemBuilder: (_, int index) => _items[index],
            itemCount: _items.length,
          ),
        ),
        new Divider(height: 10.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: new Text("Vorschläge"),
        ),
        new Flexible(
          child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            itemBuilder: (_, int index) => _suggestionWidgets[index],
            itemCount: _suggestionWidgets.length,
          ),
        ),
      ],
    );

    var page2 = new ListView.builder(
      padding: new EdgeInsets.all(8.0),
      itemBuilder: (_, int index) => _productWidgets[index],
      itemCount: _productWidgets.length,
    );

    var _percentageSaved = savedEmissions / _originalCartCo2 * 100;
    var _perYearCo2Kg = 1710 * _percentageSaved / 100;

    var page3 = Column(
      children: <Widget>[
        new Text(
          "Alter Einkauf: " + _originalCartCo2.toStringAsFixed(2) + "kg Co2",
          style: TextStyle(height: 2, fontSize: 18),
        ),
        new Divider(height: 1.0),
        new Text(
          "Gespart durch Tipps: " + savedEmissions.toStringAsFixed(2) + "kg Co2",
          style: TextStyle(height: 2, fontSize: 18),
        ),
        new Divider(height: 1.0),
        new Text(
          "entspricht " + _percentageSaved.toStringAsFixed(1) + " %",
          style: TextStyle(height: 2, fontSize: 18),
        ),
        new Divider(height: 1.0),
        new Text("Pro Jahr ca. " + _perYearCo2Kg.toStringAsFixed(0) + "kg Co2",
          style: TextStyle(height: 2, fontSize: 18),),
      ],
    );

    List<Widget> _pages = new List();
    _pages.add(page1);
    _pages.add(page2);
    _pages.add(page3);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Foodabdruck"),
        actions: <Widget>[
          // Add 3 lines from here...
          IconButton(
              icon: Icon(Icons.playlist_add_check), onPressed: _pushSaved)
        ], // ... to here.
      ),
      body: _pages.elementAt(_pageIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Einkaufsliste'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Produkte'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageIndex = index;
    });
  }

  void _pushSaved() {
    setState(() {
      _pageIndex = 2;
    });
  }

  // Widget for text input
  Widget _buildTextComposer() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          new Flexible(
            child: new TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration:
                  new InputDecoration.collapsed(hintText: "Produkt hinzufügen"),
            ),
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.add),
                onPressed: () => _handleSubmitted(_textController.text)),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCartEmissions() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          new Flexible(
            child: new TextField(
              enabled: false,
              decoration: new InputDecoration.collapsed(
                  hintText: "Co2 Summe eingespart"),
            ),
          ),
          new Flexible(
            //margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new TextField(
              controller: _textControllerTotalCart,
              enabled: false,
            ),
          ),
        ],
      ),
    );
  }
}
