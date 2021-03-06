import 'dart:io';

import 'package:flutter/material.dart';

// Model
import 'package:great_places_app/models/place.dart';

// Helper
import 'package:great_places_app/helpers/db_helper.dart'; // DBHelper

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  //* Getter
  List<Place> get items {
    return [..._items];
  }

  //* Add Place (locally)
  void addPlace(String title, File pickedImage) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: pickedImage,
      title: title,
      location: PlaceLocation(
        // temp
        latitude: 1,
        longitude: 2,
      ),
    );

    _items.add(newPlace);
    // update locally (source file)
    notifyListeners();

    // update with Database (remote DB)
    DBHelper.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
      },
    );
  }

  //* Get all Data
  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');

    _items = dataList
        .map(
          (data) => Place(
            id: data['id'],
            title: data['title'],
            image: File(data['image']),
            location: PlaceLocation(
              latitude: 1,
              longitude: 1,
            ),
          ),
        )
        .toList();

    notifyListeners();
  }
}
