import 'package:flutter/material.dart';

import 'shopping_list_item.dart';
import 'carbon_csv_loader.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    doSomethingFirst();
    return MaterialApp(
      title: 'Zero2 Shopping app',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Zero2 Shopping app Home Page'),
    );
  }
}

doSomethingFirst() {
  // Print CSV content to console
  new CarbonCSVLoader().loadCSV();
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

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text == ' ') {
      _textController.text = 'Kaputt';
    }
    else {
      ShoppingListItemWidget item = new ShoppingListItemWidget(text);
    setState(() {
      int pos = _items.length;
      _items.insert(pos, item);
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return new Scaffold(
      appBar: new AppBar(title: new Text("Friendlychat")),
      body: new Column(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
                color: Theme.of(context).cardColor),
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
        ],
      ),
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

