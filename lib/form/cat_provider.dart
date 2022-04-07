import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:olx/services/firebase_services.dart';
import 'package:provider/provider.dart';

class CategoryProvider extends ChangeNotifier {
  FirebaseService _service = FirebaseService();

  late DocumentSnapshot doc;
  late DocumentSnapshot userDetails;
  late String SelectedCategory;
  List<String> urlList = [];
  Map<String, dynamic> dataToFirestore = {};

  getCategory(selectedCat) {
    this.SelectedCategory = selectedCat;
    notifyListeners();
  }

  getSnapshot(snapshot) {
    this.doc = snapshot;
    notifyListeners();
  }

  getImages(url) {
    this.urlList.add(url);
    notifyListeners();
  }

  getData(data) {
    this.dataToFirestore = data;
    notifyListeners();
  }

  getuserDetails() {
    _service.getUserData().then((value) {
      this.userDetails = value;
      notifyListeners();
    });
  }

  clearData() {
    this.urlList = [];
    dataToFirestore = {};
    notifyListeners();
  }
}
