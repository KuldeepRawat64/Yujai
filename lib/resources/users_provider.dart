import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/firebase_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersProvider extends ChangeNotifier {
  final _usersSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 15;
  bool _hasNext = true;
  bool _isFetchingUsers = false;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<UserModel> get users => _usersSnapshot.map((snap) {
        final user = snap.data;

        return UserModel(displayName: 'displayName', photoUrl: 'photoUrl');
      }).toList();

  Future fetchNextUsers() async {
    if (_isFetchingUsers) return;

    _errorMessage = '';
    _isFetchingUsers = true;

    try {
      final snap = await FirebaseProvider.getUsers(
        documentLimit,
        startAfter: _usersSnapshot.isNotEmpty ? _usersSnapshot.last : null,
      );
      _usersSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
    _isFetchingUsers = false;
  }
}
