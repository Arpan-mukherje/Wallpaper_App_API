import 'dart:convert';
import '../model/api_model.dart';
import 'package:http/http.dart' as http;

// class Api {
//   List<Model> collections = [];
//   String apiKey = "563492ad6f917000010000010a6e9c8baa2544438552f37b9de135ee";
//   int curatedPage = 1;
//   int searchPage = 1;
//   bool isSearching = false; // Flag to track if we are searching or not

//   Future<List<Model>> fetchImages() async {
//     String apiUrl = 'https://api.pexels.com/v1/curated?per_page=40';

//     final response = await http.get(
//       Uri.parse(apiUrl),
//       headers: {
//         'Authorization': apiKey,
//       },
//     );

//     try {
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         var photos = data['photos'];
//         List<Model> fetchedImages = [];
//         for (Map<String, dynamic> i in photos) {
//           fetchedImages.add(Model.fromJson(i));
//         }
//         return fetchedImages;
//       } else {
//         return [];
//       }
//     } catch (e) {
//       throw (e.toString());
//     }
//   }

//   // Future<void> loadMoreImages() async {
//   //   if (!isSearching) {
//   //     curatedPage++;
//   //   } else {
//   //     searchPage++;
//   //   }

//   //   try {
//   //     List<Model> newImages = await fetchImages();
//   //     collections.addAll(newImages);
//   //   } catch (e) {
//   //     // Handle error, if any.
//   //   }
//   // }

//   // void toggleSearchMode(bool isSearching) {
//   //   this.isSearching = isSearching;
//   //   collections.clear(); // Clear the existing list when switching between modes
//   // }
// }
class Api {
  List<Model> collections = [];
  String apiKey = "563492ad6f917000010000010a6e9c8baa2544438552f37b9de135ee";
  int curatedPage = 1;
  int searchPage = 1;

  Future<List<Model>> fetchCuratedImages() async {
    String apiUrl = "https://api.pexels.com/v1/curated?per_page=40";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': apiKey,
      },
    );

    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var photos = data['photos'];
        for (Map<String, dynamic> i in photos) {
          collections.add(Model.fromJson(i));
        }
        return collections;
      } else {
        return [];
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<Model>> searchImages(String searchTerm) async {
    String apiUrl =
        "https://api.pexels.com/v1/search?query=$searchTerm&per_page=40&page=$searchPage";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': apiKey,
      },
    );
    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var photos = data['photos'];
        List<Model> searchResults = [];
        for (Map<String, dynamic> i in photos) {
          searchResults.add(Model.fromJson(i));
        }
        return searchResults;
      } else {
        return [];
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List> loadMoreCuratedImages() async {
    curatedPage++;
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=$curatedPage';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': apiKey,
      },
    );

    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var photos = data['photos'];
        for (Map<String, dynamic> i in photos) {
          collections.add(Model.fromJson(i));
        }
        return collections;
      } else {
        return [];
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> loadMoreSearchImages(String searchTerm) async {
    searchPage++;

    try {
      List<Model> newImages = await searchImages(searchTerm);
      collections.addAll(newImages);
    } catch (e) {
      // Handle error, if any.
    }
  }
}
