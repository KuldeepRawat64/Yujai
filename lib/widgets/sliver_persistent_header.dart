import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';

class ProfileHeader implements SliverPersistentHeaderDelegate {
  ProfileHeader({
    this.minExtent,
    this.name,
    this.photo,
    this.designation,
    this.location,
    @required this.maxExtent,
  });

  final double minExtent;
  final double maxExtent;
  final String name;
  final String photo;
  final String designation;
  final String location;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Color(0xffffffff),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 35.0, bottom: 20.0),
              child: Row(children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(photo),
                ),
                Column(children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      name,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      designation ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        //fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ]),
              ])),
          Positioned(top: 10, left: 10, child: Icon(Icons.keyboard_arrow_left)),
          Positioned(top: 10, right: 10, child: Icon(Icons.more_horiz)),
        ],
      ),
    );
  }

  double titleOpacity(double shrinkOffset) {
    // simple formula: fade out text as soon as shrinkOffset > 0
    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
    // more complex formula: starts fading out text when shrinkOffset > minExtent
    //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate onDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  // TODO: implement showOnScreenConfiguration
  PersistentHeaderShowOnScreenConfiguration get showOnScreenConfiguration =>
      null;

  @override
  // TODO: implement stretchConfiguration
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  // TODO: implement vsync
  TickerProvider get vsync => null;
}
