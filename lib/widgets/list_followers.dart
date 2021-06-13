import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class ListItemFollowers extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final User user, currentuser;
  final int index;

  ListItemFollowers(
      {this.user, this.index, this.currentuser, this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    return user != null && user.uid == documentSnapshot.data['ownerUid']
        ? ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  documentSnapshot.data['ownerPhotoUrl']),
            ),
            title: Text(
              documentSnapshot.data['ownerName'],
              style: TextStyle(
                  fontSize: textSubTitle(context),
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold),
            ),
          )
        : InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FriendProfileScreen(
                        name: documentSnapshot.data['ownerName'],
                        uid: documentSnapshot.data['ownerUid'],
                      )));
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    documentSnapshot.data['ownerPhotoUrl']),
              ),
              title: Text(
                documentSnapshot.data['ownerName'],
                style: TextStyle(
                    fontSize: textSubTitle(context),
                    fontFamily: FontNameDefault,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
  }
}
