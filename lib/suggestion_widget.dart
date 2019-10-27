import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'carbonHandler.dart';

class SuggestionWidget extends StatelessWidget {
  Suggestion suggestion;

  SuggestionWidget(Suggestion inSug) {
    suggestion = inSug;
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
            child: new CircleAvatar(child: new Text(suggestion.reducedEmissions.toString())),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(suggestion.old + " --> " + suggestion.sugg),
              ),
            ],
          ),
          /*new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.add_circle_outline),
                onPressed: () => _handleAdd()),
          ),new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.remove_circle_outline),
                onPressed: () => _handleRemove()),
          ),*/
        ],
      ),
    );
  }

  _handleAdd() {
    print("Adding ");
    print(suggestion.old);
  }

  _handleRemove() {
    print("Remove ");
    print(suggestion.old);
  }
}