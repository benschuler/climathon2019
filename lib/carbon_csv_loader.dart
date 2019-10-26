import 'package:csv/csv.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class CarbonCSVLoader {
  Future<String> loadAsset(String path) async {
    //here comes the list which we read in
    return await rootBundle.loadString(path);
  }

  void loadCSV() {
    loadAsset('data/test.csv').then((dynamic output) {
      String csvRaw = output;
      //print(csvRaw);
      CsvToListConverter myConverter = new CsvToListConverter(
          eol: "/n");
      List<List<dynamic>> rowsAsListOfValues = myConverter.convert(csvRaw);
      print(rowsAsListOfValues);
    });
  }
}