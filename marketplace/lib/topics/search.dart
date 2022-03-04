import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    // actions for app bar
    return <Widget>[
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // leading icon on the left of the app bar
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  //String selectedResult;

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // show some result based on the selection
    return Scaffold(
      body: Center(
        child: Text(query),
      ),
    );
    //throw UnimplementedError();
  }

  List<String> recentList = ["test", "test2"];
  List<String> suggestions = ["sug1", "sug2"];

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // show when someone searches for something
    final suggestionList = query.isEmpty
        ? recentList
        : suggestions.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: (() {
            showResults(context);
          }),
          //title: Text(suggestionList[index]),
          title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                      color: Color.fromARGB(255, 143, 9, 114),
                      fontWeight: FontWeight.bold),
                  children: [
                TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ])),
        );
      },
    );
    //throw UnimplementedError();
  }
}
