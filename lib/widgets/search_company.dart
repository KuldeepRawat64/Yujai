import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_profile.dart';

class CompanySearch extends SearchDelegate<String> {
  List<User> userList;
  CompanySearch({this.userList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final suggestionsList = query.isEmpty
        ? userList
        : userList.where((p) => p.displayName.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
            left: 8.0,
            right: 8.0,
          ),
          child: Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.grey[300])),
            ),
            child: ListTile(
              onTap: () {
                //   showResults(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => InstaFriendProfileScreen(
                            uid: suggestionsList[index].uid,
                            name: suggestionsList[index].displayName))));
              },
              leading: Container(
                decoration: ShapeDecoration(
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(screenSize.height * 0.01)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenSize.height * 0.012),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        suggestionsList[index].photoUrl),
                  ),
                ),
              ),
              title: Text(
                suggestionsList[index].displayName,
                style: TextStyle(fontSize: screenSize.height * 0.018),
              ),
              subtitle: Text(
                suggestionsList[index].location,
                style: TextStyle(fontSize: screenSize.height * 0.018),
              ),
            ),
          ))),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final suggestionsList = query.isEmpty
        ? userList
        : userList.where((p) => p.displayName.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 8.0,
              right: 8.0,
            ),
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.grey[300])),
              ),
              child: ListTile(
                onTap: () {
                  //   showResults(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => InstaFriendProfileScreen(
                              uid: suggestionsList[index].uid,
                              name: suggestionsList[index].displayName))));
                },
                leading: Container(
                  decoration: ShapeDecoration(
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.height * 0.01)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenSize.height * 0.012),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          suggestionsList[index].photoUrl),
                    ),
                  ),
                ),
                title: Text(
                  suggestionsList[index].displayName,
                  style: TextStyle(
                    fontSize: screenSize.height * 0.018,
                  ),
                ),
                subtitle: Text(
                  suggestionsList[index].location,
                  style: TextStyle(fontSize: screenSize.height * 0.018),
                ),
              ),
            ),
          )),
    );
  }
}
