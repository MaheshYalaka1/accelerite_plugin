import 'dart:io';
import 'dart:async';
import 'package:accelerite_plugin/modal/newplace.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT)');
    },
    version: 1,
  );
  return db;
}

class UesrPlaceNotifier extends StateNotifier<List<Place>> {
  UesrPlaceNotifier() : super(const []);
  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map((row) => Place(
              id: row['id'] as String,
              title: row['title'] as String,
              image: File(row['image'] as String),
            ))
        .toList();
    state = places;
  }

  void addplace(
    String title,
    File image,
  ) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');
    final newplace = Place(
      title: title,
      image: copiedImage,
    );
    final db = await _getDatabase();

    db.insert('user_places', {
      'id': newplace.id,
      'title': newplace.title,
      'image': newplace.image.path,
    });

    state = [newplace, ...state];
  }

  void deletePlace(String id) async {
    final db = await _getDatabase();

    await db.delete(
      'user_places',
      where: 'id = ?',
      whereArgs: [id],
    );

    state = state.where((place) => place.id != id).toList();
  }

  void updatePlace(String id, String newTitle, File newImage) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(newImage.path);
    final copiedImage = await newImage.copy('${appDir.path}/$filename');

    final updatedPlace = Place(
      id: id,
      title: newTitle,
      image: copiedImage,
    );

    final db = await _getDatabase();

    await db.update(
      'user_places',
      {
        'title': updatedPlace.title,
        'image': updatedPlace.image.path,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    state = state.map((place) {
      return place.id == id ? updatedPlace : place;
    }).toList();
  }
}

final userplaceprovider = StateNotifierProvider<UesrPlaceNotifier, List<Place>>(
    (ref) => UesrPlaceNotifier());
