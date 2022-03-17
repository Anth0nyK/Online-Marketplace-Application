import 'package:flutter/material.dart';
import 'package:marketplace/market/market_item.dart';
import 'package:marketplace/services/firestore.dart';
import 'package:marketplace/services/models.dart';
import 'package:marketplace/shared/bottom_nav.dart';
import 'package:marketplace/shared/loading.dart';
import 'package:marketplace/shared/shared.dart';

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
    // return Scaffold(
    //   body: Center(
    //     child: Text(query),
    //   ),
    // );
    if (query == "") {
      return Scaffold(
        body: Container(),
        bottomNavigationBar: const BottomNavBar(
          theIndex: 2,
        ),
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<List<Listing>>(
        stream: FirestoreService().getSearchListingsStream(query),
        // return FutureBuilder<List<Listing>>(
        //   future: FirestoreService().getUserListings(user?.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: const LoadingScreen()),
                  ],
                ),
              ),
              bottomNavigationBar: const BottomNavBar(
                theIndex: 2,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorMessage(message: snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            var listings = snapshot.data!;
            return Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                //height: MediaQuery.of(context).size.height,
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20.0),
                  crossAxisSpacing: 10.0,
                  crossAxisCount: 2,
                  children: listings
                      .map((listing) => MarketItem(listing: listing))
                      .toList(),
                ),
              ),
              bottomNavigationBar: const BottomNavBar(
                theIndex: 2,
              ),
            );
          } else {
            return const Text('No topics found in Firestore. Check database');
          }
        },
      ),
    );

    //throw UnimplementedError();
  }

  //List<String> recentList = ["test", "test2"];
  List<String> recentList = [];
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
