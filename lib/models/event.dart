//import 'package:Yujai/pages/event_upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String postId;
  String currentUserUid;
  String imgUrl;
  String caption;
  String location;
  String venue;
  String city;
  FieldValue time;
  String eventOwnerName;
  String eventOwnerPhotoUrl;
  String host;
  String website;
  String description;
  String category;
  GeoPoint geopoint;
  int startDate;
  int endDate;
  int startTime;
  int endTime;
  String ticketWebsite;

  Event({
    this.postId,
    this.currentUserUid,
    this.caption,
    this.imgUrl,
    this.location,
    this.city,
    this.venue,
    this.time,
    this.eventOwnerName,
    this.eventOwnerPhotoUrl,
    this.website,
    this.description,
    this.host,
    this.category,
    this.geopoint,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.ticketWebsite,
  });

  Map toMap(Event event) {
    var data = Map<String, dynamic>();
    data['postId'] = event.postId;
    data['ownerUid'] = event.currentUserUid;
    data['imgUrl'] = event.imgUrl;
    data['caption'] = event.caption;
    data['location'] = event.location;
    data['venue'] = event.venue;
    data['time'] = event.time;
    data['city'] = event.city;
    data['eventOwnerName'] = event.eventOwnerName;
    data['eventOwnerPhotoUrl'] = event.eventOwnerPhotoUrl;
    data['host'] = event.host;
    data['website'] = event.website;
    data['description'] = event.description;
    data['geopoint'] = event.geopoint;
    data['category'] = event.category;
    data['startDate'] = event.startDate;
    data['endDate'] = event.endDate;
    data['startTime'] = event.startTime;
    data['endTime'] = event.endTime;
    data['ticketWebsite'] = event.ticketWebsite;
    return data;
  }

  Event.fromMap(Map<String, dynamic> mapData) {
    this.postId = mapData['postId'];
    this.currentUserUid = mapData['ownerUid'];
    this.imgUrl = mapData['imgUrl'];
    this.caption = mapData['caption'];
    this.location = mapData['location'];
    this.venue = mapData['venue'];
    this.time = mapData['time'];
    this.city = mapData['city'];
    this.eventOwnerName = mapData['eventOwnerName'];
    this.eventOwnerPhotoUrl = mapData['eventOwnerPhotoUrl'];
    this.geopoint = mapData['geopoint'];
    this.website = mapData['website'];
    this.description = mapData['description'];
    this.host = mapData['host'];
    this.category = mapData['category'];
    this.startDate = mapData['startDate'];
    this.endDate = mapData['endDate'];
    this.startTime = mapData['startTime'];
    this.endTime = mapData['endTime'];
    this.ticketWebsite = mapData['ticketWebsite'];
  }
}
