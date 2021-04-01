//import 'package:Yujai/pages/event_upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String postId;
  String currentUserUid;
  String imgUrl;
  String caption;
  String location;
  FieldValue time;
  String eventOwnerName;
  String eventOwnerPhotoUrl;
  String organiser;
  String website;
  String description;
  String agenda;
  String category;
  String type;
  String venue;
  String startEvent;
  String endEvent;
  String ticketWebsite;

  Event({
    this.postId,
    this.currentUserUid,
    this.caption,
    this.imgUrl,
    this.location,
    this.time,
    this.eventOwnerName,
    this.eventOwnerPhotoUrl,
    this.organiser,
    this.website,
    this.description,
    this.agenda,
    this.category,
    this.type,
    this.venue,
    this.startEvent,
    this.endEvent,
    this.ticketWebsite,
  });

  Map toMap(Event event) {
    var data = Map<String, dynamic>();
    data['postId'] = event.postId;
    data['ownerUid'] = event.currentUserUid;
    data['imgUrl'] = event.imgUrl;
    data['caption'] = event.caption;
    data['location'] = event.location;
    data['time'] = event.time;
    data['eventOwnerName'] = event.eventOwnerName;
    data['eventOwnerPhotoUrl'] = event.eventOwnerPhotoUrl;
    data['organiser'] = event.organiser;
    data['website'] = event.website;
    data['description'] = event.description;
    data['agenda'] = event.agenda;
    data['category'] = event.category;
    data['type'] = event.type;
    data['venue'] = event.venue;
    data['startEvent'] = event.startEvent;
    data['endEvent'] = event.endEvent;
    data['ticketWebsite'] = event.ticketWebsite;
    return data;
  }

  Event.fromMap(Map<String, dynamic> mapData) {
    this.postId = mapData['postId'];
    this.currentUserUid = mapData['ownerUid'];
    this.imgUrl = mapData['imgUrl'];
    this.caption = mapData['caption'];
    this.location = mapData['location'];
    this.time = mapData['time'];
    this.eventOwnerName = mapData['eventOwnerName'];
    this.eventOwnerPhotoUrl = mapData['eventOwnerPhotoUrl'];
    this.organiser = mapData['organiser'];
    this.website = mapData['website'];
    this.description = mapData['description'];
    this.agenda = mapData['agenda'];
    this.category = mapData['category'];
    this.type = mapData['type'];
    this.venue = mapData['venue'];
    this.startEvent = mapData['startEvent'];
    this.endEvent = mapData['endEvent'];
    this.ticketWebsite = mapData['ticketWebsite'];
  }
}
