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
  final List<ShoppingListItemWidget> _items = <ShoppingListItemWidget>[];
  Map<String, List<String>> _categories = new HashMap();
  int _selectedIndex = 0;

  //List<ProductCarbonData> _products = <ProductCarbonData>[];
  Map<String, ProductCarbonData> _products = new HashMap();
  List<ProductListWidget> _productWidgets = <ProductListWidget>[];

  Future<String> loadAsset(String path) async {
    //here comes the list which we read in
    return await rootBundle.loadString(path);
  }

  @override
  void initState() {
    rootBundle.loadString('data/products.csv').then((dynamic output) {
      List<List<dynamic>> _csv = const CsvToListConverter(fieldDelimiter: ',').convert(output);
      for(List<dynamic> x in _csv) {
        print(x);
      }
      setState(() {
        for (var i = 0; i < _csv.length; i++) {

          ProductCarbonData p = new ProductCarbonData(_csv[i][2], _csv[i][1]);
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

  void _createProductWidgets(){
    ProductListWidget myWidget;

    for(String p in _products.keys) {
      myWidget = new ProductListWidget(p);
      _productWidgets.add(myWidget);
    }
  }

  void _handleSubmitted(String text) {
    //get list of suggestions like this
    List<String> inputProducts = <String>[];

    inputProducts.add("Butter");
    inputProducts.add("Mango");
    List<Suggestion> suggs = getSuggestions(inputProducts, _products, _categories);

    _textController.clear();
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
          decoration: new BoxDecoration(
              color: Theme.of(context).cardColor),
          child: new Text("Vorschläge"),
        ),

      ],
    );

    var page2 =new ListView.builder(
        padding: new EdgeInsets.all(8.0),
        itemBuilder: (_, int index) => _productWidgets[index],
        itemCount: _productWidgets.length,
      );

    List<Widget> _pages = new List();
    _pages.add(page1);
    _pages.add(page2);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Foodabdruck"),
        actions: <Widget>[
          // Add 3 lines from here...
          IconButton(
              icon: Icon(Icons.playlist_add_check), onPressed: _pushSaved)
        ], // ... to here.
      ),
      body: _pages.elementAt(_selectedIndex),
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
    });
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(   // Add 20 lines from here...
//        builder: (BuildContext context) {
//          final Iterable<ListTile> tiles = _saved.map(
//                (WordPair pair) {
//              return ListTile(
//                title: Text(
//                  pair.asPascalCase,
//                  style: _biggerFont,
//                ),
//              );
//            },
//          );
//          final List<Widget> divided = ListTile
//              .divideTiles(
//            context: context,
//            tiles: tiles,
//          )
//              .toList();
//        },
      ),                       // ... to here.
    );
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
              decoration: new InputDecoration.collapsed(
                  hintText: "Produkt hinzufügen"),
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
}
