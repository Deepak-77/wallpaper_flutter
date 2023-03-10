import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app_flutter_pexelsapi/models/photos.dart';
import '../models/category.dart';

class ApiOperations {
  static List<Photos> trendingWallpapers = [];
  static List<Photos> searchWallpapersList = [];
  static List<CategoryModel> cateogryModelList = [];

  static String _apiKey =
      "FwkmLvqoRxkr7oPoniX6ZR8mLvMYt083SjBg5wd996v0LV94cRfYdwVn";
  static Future<List<Photos>> getTrendingWallpapers() async {
    await http.get(Uri.parse("https://api.pexels.com/v1/curated"),
        headers: {"Authorization": "$_apiKey"}).then((value) {
      print("RESPONSE REPORT");
      print(value.body);
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['photos'];
      photos.forEach((element) {
        trendingWallpapers.add(Photos.fromAPI2APP(element));
      });
    });

    return trendingWallpapers;
  }

  static Future<List<Photos>> searchWallpapers(String query) async {
    await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=30&page=1"),
        headers: {"Authorization": "$_apiKey"}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['photos'];
      searchWallpapersList.clear();
      photos.forEach((element) {
        searchWallpapersList.add(Photos.fromAPI2APP(element));
      });
    });

    return searchWallpapersList;
  }

  static List<CategoryModel> getCategoriesList() {
    List cateogryName = [
      "Cars",
      "Nature",
      "Bikes",
      "Street",
      "City",
      "Flowers"
    ];
    cateogryModelList.clear();
    cateogryName.forEach((catName) async {
      final _random = new Random();

      Photos photoModel =
      (await searchWallpapers(catName))[0 + _random.nextInt(11 - 0)];
      print("IMG SRC IS HERE");
      print(photoModel.imgSrc);
      cateogryModelList
          .add(CategoryModel(catImgUrl: photoModel.imgSrc, catName: catName));
    });

    return cateogryModelList;
  }
}