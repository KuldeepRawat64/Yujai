import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/resources/users_provider.dart';
import 'package:flutter/material.dart';

class UsersListViewWidget extends StatefulWidget {
  final UsersProvider usersProvider;

  const UsersListViewWidget({
    @required this.usersProvider,
    Key key,
  }) : super(key: key);

  @override
  _UsersListViewWidgetState createState() => _UsersListViewWidgetState();
}

class _UsersListViewWidgetState extends State<UsersListViewWidget> {
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    widget.usersProvider.fetchNextUsers();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (widget.usersProvider.hasNext) {
        widget.usersProvider.fetchNextUsers();
      }
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
        controller: scrollController,
        padding: EdgeInsets.all(12),
        children: [
          ...widget.usersProvider.users
              .map((user) => ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FriendProfileScreen(
                                    uid: user.uid,
                                    name: user.displayName,
                                  )));
                    },
                    title: Text(user.displayName),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                  ))
              .toList(),
          if (widget.usersProvider.hasNext)
            Center(
              child: GestureDetector(
                onTap: widget.usersProvider.fetchNextUsers,
                child: Container(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
        ],
      );
}
