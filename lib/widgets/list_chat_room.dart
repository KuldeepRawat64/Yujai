import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/chat_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ListItemChatRoom extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final UserModel user, currentuser;
  final int index;

  ListItemChatRoom(
      {this.user, this.index, this.currentuser, this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
                  photoUrl: documentSnapshot['ownerPhotoUrl'],
                  name: documentSnapshot['ownerName'],
                  receiverUid: documentSnapshot['ownerUid'],
                )));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Colors.grey[300])),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(documentSnapshot['ownerPhotoUrl']),
            ),
            title: Text(
              documentSnapshot['ownerName'],
              style: TextStyle(fontSize: screenSize.height * 0.018),
            ),
            subtitle: Text(
              'Message',
              style: TextStyle(fontSize: screenSize.height * 0.018),
            ),
            trailing: Icon(
              MdiIcons.circleMedium,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ),
      ),
    );
  }
}
