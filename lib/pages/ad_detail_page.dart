import 'dart:async';

import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/style.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class AdDetailScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final UserModel user, currentuser;
  final Group group;

  AdDetailScreen(
      {this.documentSnapshot, this.user, this.currentuser, this.group});

  @override
  _AdDetailScreenState createState() => _AdDetailScreenState();
}

class _AdDetailScreenState extends State<AdDetailScreen> {
  // String selectedSubject;
  final List<String> images = [];
  // TextEditingController _bodyController = TextEditingController(text: '');
  final CarouselController _controller = CarouselController();
  String reason = '';
  int _current = 0;
  Completer<GoogleMapController> _gpsController = Completer();
  // inititalize _center
  Position _center;
  final Set<Marker> _markers = {};
  GeoPoint geopint;
  String selectedSubject;
  bool seeMore = false;

  @override
  void initState() {
    super.initState();
    selectedSubject = 'Spam';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.documentSnapshot['imgUrls'].forEach((urls) {
        precacheImage(NetworkImage(urls), context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: CustomScrollView(
          slivers: [
            // SliverAppBar(
            //   leading: IconButton(
            //       icon: Icon(Icons.keyboard_arrow_left,
            //           color: Colors.white, size: screenSize.height * 0.045),
            //       onPressed: () {
            //         Navigator.pop(context);
            //       }),
            //   actions: [
            //     IconButton(
            //         icon: Icon(Icons.more_horiz, color: Colors.white),
            //         onPressed: () {
            //           widget.currentuser.uid ==
            //                   widget.documentSnapshot.data['ownerUid']
            //               ? showDelete(widget.documentSnapshot)
            //               : showReport(widget.documentSnapshot);
            //         })
            //   ],
            //   backgroundColor: Color(0xFFEDF2F8),
            //   expandedHeight: screenSize.height * 0.4,
            //   flexibleSpace: FlexibleSpaceBar(
            //     background: InkWell(
            //       onTap: () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => ImageDetail(
            //                       image: widget.documentSnapshot.data['imgUrl'],
            //                     )));
            //       },
            //       child: CachedNetworkImage(
            //           fit: BoxFit.cover,
            //           imageUrl: widget.documentSnapshot.data['imgUrl']),
            //     ),
            //   ),
            // ),
            SliverList(delegate: SliverChildListDelegate([adStack()]))
          ],
        ),
      ),
    );
  }

  Future<void> send() async {
    final Email email = Email(
      body: '\n Owner ID : ${widget.documentSnapshot['ownerUid']}' +
          '\ Post ID : n${widget.documentSnapshot['postId']}' +
          '\n Sent from Yujai',
      subject: selectedSubject,
      recipients: ['animusitmanagement@gmail.com'],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;
    print('$platformResponse');
  }

  showDelete(DocumentSnapshot snapshot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text(
                  'Confirm delete',
                  style: TextStyle(
                      fontSize: textSubTitle(context),
                      fontFamily: FontNameDefault,
                      color: Colors.redAccent),
                ),
                onPressed: () {
                  deletePost(snapshot);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  deleteDialog(DocumentSnapshot snapshot) {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              //    overflow: Overflow.visible,
              children: [
                Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Delete Post',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textHeader(context),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: screenSize.height * 0.09,
                        child: Text(
                          'Are you sure you want to delete this post?',
                          style: TextStyle(color: Colors.black54),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015,
                            horizontal: screenSize.width * 0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              deletePost(snapshot);
                            },
                            child: Container(
                              height: screenSize.height * 0.055,
                              width: screenSize.width * 0.3,
                              child: Center(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.white,
                                      fontSize: textSubTitle(context)),
                                ),
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015,
                            horizontal: screenSize.width * 0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: screenSize.height * 0.055,
                              width: screenSize.width * 0.3,
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black,
                                      fontSize: textSubTitle(context)),
                                ),
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(
                                      width: 0.2, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        }));
  }

  showReport(DocumentSnapshot snapshot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text(
                  'Report this post',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.redAccent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showFormDialog(context);
                  //   Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  _showFormDialog(BuildContext context) async {
    var screenSize = MediaQuery.of(context).size;
    return await showDialog(
        context: context,
        builder: ((BuildContext context) {
          return StatefulBuilder(builder: ((BuildContext context, setState) {
            return AlertDialog(
              content: Form(
                child: Wrap(
                  //    mainAxisSize: MainAxisSize.min,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report',
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textHeader(context),
                          fontWeight: FontWeight.bold),
                    ),
                    RadioListTile(
                        title: Text(
                          'Spam',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Spam',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Pornographic',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Pornographic',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Misleading',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Misleading',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Hacked',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Hacked',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Offensive',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Offensive',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       vertical: screenSize.height * 0.01,
                    //       horizontal: screenSize.width / 30),
                    //   child: Text('Comment'),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       vertical: screenSize.height * 0.01,
                    //       horizontal: screenSize.width / 30),
                    //   child: TextFormField(
                    //     controller: _bodyController,
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.01,
                          horizontal: screenSize.width / 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold)),
                          ),
                          InkWell(
                            onTap: () {
                              send().then((value) => Navigator.pop(context));
                              // .then((value) => Navigator.pop(context));
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }));
        }));
  }

  deletePost(DocumentSnapshot snapshot) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(snapshot['ownerUid'])
        .collection('posts')
        // .document()
        // .delete();
        .doc(snapshot['postId'])
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
        //  Navigator.pop(context);

        print('post deleted');
      } else {
        return print('not owner');
      }
    });
  }

  // CameraPosition _currentPosition = CameraPosition(
  //   target: LatLng(13.0827, 80.2707),
  //   zoom: 12,
  // );

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      reason = changeReason.toString();
    });
  }

  Widget adStack() {
    return Stack(
        fit: StackFit.loose,
        alignment: Alignment.topCenter,
        children: [
          Positioned(child: adHeader(context)),
          Positioned(
            child: adBody(context),
          )
        ]);
  }

  Widget adHeader(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.35,
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                child: CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: widget.documentSnapshot['imgUrls'].length,
                    itemBuilder: (context, index, realIdx) {
                      return Container(
                        child: Center(
                          child: Image.network(
                            widget.documentSnapshot['imgUrls'][index],
                            height: screenSize.height * 0.34,
                            width: screenSize.width,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;

                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                        enableInfiniteScroll: false,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          if (widget.documentSnapshot['imgUrls'].length > 1) {
                            setState(() {
                              _current = index;
                            });
                          }
                        })),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.documentSnapshot['imgUrls'].map<Widget>((url) {
                  int index = widget.documentSnapshot['imgUrls'].indexOf(url);
                  return Container(
                    width: 26.0,
                    height: 4.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: _current == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // CachedNetworkImage(
          //   imageUrl: documentSnapshot.data['imgUrls'][0],
          //   fit: BoxFit.cover,
          //   height: screenSize.height * 0.4,
          //   width: screenSize.width,
          // ),
          Positioned(
            top: 20,
            left: 20,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.keyboard_arrow_left_outlined)),
            ),
          ),
          Positioned(
            top: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                widget.currentuser.uid == widget.documentSnapshot['ownerUid'] ||
                        widget.group != null &&
                            widget.group.currentUserUid ==
                                widget.currentuser.uid
                    ? deleteDialog(widget.documentSnapshot)
                    : showReport(widget.documentSnapshot);
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.more_vert_outlined),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget adBody(BuildContext context) {
    geopint = widget.documentSnapshot['geopoint'];
    _markers.add(
      Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_center.toString()),
        position: LatLng(geopint.latitude, geopint.longitude),

        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    var screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        top: screenSize.height * 0.35,
      ),
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 12.0,
                spreadRadius: 4.0,
                color: Colors.grey[100],
                offset: Offset(10, -10))
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
              contentPadding: EdgeInsets.zero,
              trailing: Icon(Icons.person_outline),
              subtitle: Text(
                  widget.documentSnapshot['time'] != null
                      ? timeago.format(widget.documentSnapshot['time'].toDate())
                      : '',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textbody2(context),
                      color: Colors.grey)),
              title: Text(widget.documentSnapshot['postOwnerName'],
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    //  color: Theme.of(context).primaryColor,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold,
                  )),
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      widget.documentSnapshot['postOwnerPhotoUrl']))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\u{20B9}',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Theme.of(context).primaryColor,
                        fontSize: textHeader(context),
                        fontWeight: FontWeight.bold,
                      )),
                  Text(widget.documentSnapshot['price'],
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        // color: Theme.of(context).primaryColor,
                        fontSize: textHeader(context),
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                widget.documentSnapshot['caption'],
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textHeader(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              widget.documentSnapshot['description'].toString().length < 350
                  ? Text(
                      widget.documentSnapshot['description'],
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: textSubTitle(context)),
                    )
                  : seeMore
                      ? Wrap(
                          children: [
                            Text(
                              widget.documentSnapshot['description'],
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: textSubTitle(context)),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  seeMore = false;
                                });
                              },
                              child: Text(
                                'See less',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Theme.of(context).primaryColorLight),
                              ),
                            )
                          ],
                        )
                      : Wrap(
                          children: [
                            Text(
                              widget.documentSnapshot['description'],
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  seeMore = true;
                                });
                              },
                              child: Text(
                                'See more',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Theme.of(context).primaryColorLight),
                              ),
                            )
                          ],
                        ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.2,
                  vertical: screenSize.height * 0.005,
                ),
                child: Text(
                  widget.documentSnapshot['location'],
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                    //  fontSize: textBody1(context),
                  ),
                ),
              ),
              Container(
                height: screenSize.height * 0.13,
                width: screenSize.width,
                margin:
                    EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
                child: GoogleMap(
                  markers: _markers,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(geopint.latitude, geopint.longitude),
                      zoom: 12),
                  onMapCreated: (GoogleMapController controller) {
                    _gpsController.complete();
                  },
                ),
              ),
              Row(
                children: [
                  Container(
                    width: screenSize.width * 0.45,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: IconButton(
                        icon: Icon(Icons.production_quantity_limits,
                            color: Theme.of(context).primaryColorLight),
                        onPressed: null,
                      ),
                      title: Text(
                        'Condition',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context)),
                      ),
                      subtitle: Text(
                        widget.documentSnapshot['condition'] != ''
                            ? widget.documentSnapshot['condition']
                            : 'Used',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context)),
                      ),
                    ),
                  ),
                  Container(
                    width: screenSize.width * 0.45,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: IconButton(
                        icon: Icon(
                          Icons.category_outlined,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        onPressed: null,
                      ),
                      title: Text(
                        'Category',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context)),
                      ),
                      subtitle: Text(
                        widget.documentSnapshot['category'] != ''
                            ? widget.documentSnapshot['category']
                            : 'Other',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Padding(
          //   padding: EdgeInsets.only(bottom: screenSize.height * 0.012),
          //   child: Container(
          //     width: screenSize.width,
          //     child: Padding(
          //       padding: EdgeInsets.only(
          //         left: screenSize.width / 30,
          //         top: screenSize.height * 0.012,
          //       ),
          //       child: Text(
          //         'Uploader',
          //         style: TextStyle(
          //           fontFamily: FontNameDefault,
          //           fontSize: textSubTitle(context),
          //           color: Colors.black45,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // InkWell(
          //     onTap: () {
          //       Navigator.of(context).push(MaterialPageRoute(
          //           builder: (context) => InstaFriendProfileScreen(
          //               uid: widget.documentSnapshot.data['ownerUid'],
          //               name: widget.documentSnapshot.data['postOwnerName'])));
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          //       child: Container(
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(12.0),
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.grey[300],
          //                 offset: const Offset(1.0, 1.0),
          //                 blurRadius: 1.0,
          //                 spreadRadius: 1.0,
          //               ),
          //             ]),
          //         child: ListTile(
          //           subtitle: Text(''),
          //           leading: CircleAvatar(
          //             backgroundImage: CachedNetworkImageProvider(
          //                 widget.documentSnapshot.data['postOwnerPhotoUrl']),
          //           ),
          //           title: Text(
          //             widget.documentSnapshot.data['postOwnerName'],
          //             style: TextStyle(
          //               fontFamily: FontNameDefault,
          //               color: Colors.black,
          //               fontSize: textSubTitle(context),
          //             ),
          //           ),
          //         ),
          //       ),
          //     )),
          Padding(
            padding: EdgeInsets.only(top: screenSize.height * 0.012),
            child: Container(
              height: screenSize.height * 0.04,
              width: screenSize.width,
            ),
          ),
        ],
      ),
    );
  }
}
