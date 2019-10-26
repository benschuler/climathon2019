import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SuggestionWidget extends StatelessWidget {
  SuggestionEntry suggestionEntry;

  SuggestionWidget(String inText) {
    suggestionEntry = new SuggestionEntry(inText, 80);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text(suggestionEntry.savings.toString())),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(suggestionEntry.text),
              ),
            ],
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.add_circle_outline),
                onPressed: () => _handleAdd()),
          ),new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.remove_circle_outline),
                onPressed: () => _handleRemove()),
          ),
        ],
      ),
    );
  }

  _handleAdd() {
    print("Adding ");
    print(suggestionEntry.text);
  }

  _handleRemove() {
    print("Remove ");
    print(suggestionEntry.text);
  }
}

class SuggestionEntry {
  String text = "";
  double savings;

  SuggestionEntry(String inText, double inSavings) {
    this.text = inText;
    savings = inSavings;
  }
}