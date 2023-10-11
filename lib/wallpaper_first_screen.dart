// import 'package:flutter/material.dart';
// import 'package:wallpaper_app/downloadScreen.dart';
// import 'api_services/api_services.dart';
// import 'model/api_model.dart';

// class Wallpaper extends StatefulWidget {
//   const Wallpaper({Key? key}) : super(key: key);

//   @override
//   State<Wallpaper> createState() => _WallpaperState();
// }

// class _WallpaperState extends State<Wallpaper> {
//   Api api = Api();
//   bool isLoadingMore = false;
//   Future<void> debounce(Duration duration, VoidCallback action) async {
//     await Future.delayed(duration);
//     action();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: const Text('Wallpapers'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: FutureBuilder<List<Model>>(
//               future: api.fetchCuratedImages(),
//               builder: (context, snapshot) {
// print(snapshot.data!.length);
// if (snapshot.connectionState == ConnectionState.waiting) {
//   return const Center(
//     child: CircularProgressIndicator(),
//   );
// } else if (snapshot.hasError) {
//   return Center(
//     child: Text('Error: ${snapshot.error}'),
//   );
// } else {
//   return Padding(
//       padding: const EdgeInsets.only(left: 10.0, right: 10),
//       child: GridView.builder(
//         gridDelegate:
//             const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 8.0,
//           crossAxisSpacing: 8.0,
//         ),
//         itemCount: snapshot.data!.length,
//         itemBuilder: (context, index) {
//           String imageUrl = snapshot.data![index].src!.tiny!;
//           String imageUrls =
//               snapshot.data![index].src!.large2x!;
//           return InkWell(
//             onTap: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => screen(imgurl: imageUrls),
//               ));
//             },
//             child: Image.network(imageUrl),
//           );
//         },
//                       ));
//                 }
//               },
//             ),
//           ),
//           GestureDetector(
//             onTap: () async {
//               print("ontap");
//               if (!isLoadingMore) {
//                 setState(() {
//                   isLoadingMore = true;
//                 });

//                 // Debounce the action to avoid rapid taps
//                 debounce(Duration(milliseconds: 500), () async {
//                   await api.loadMoreCuratedImages();
//                   setState(() {
//                     isLoadingMore = false;
//                   });
//                 });
//               }
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   isLoadingMore ? "Loading..." : "Load More",
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Color.fromARGB(255, 179, 178, 178),
//                   ),
//                 ),
//                 Icon(Icons.add),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:wallpaper_app/downloadScreen.dart';
import 'api_services/api_services.dart';
import 'model/api_model.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({Key? key}) : super(key: key);

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  Api api = Api();
  bool isLoadingMore = false;
  String searchQuery = '';

  Future<void> debounce(Duration duration, VoidCallback action) async {
    await Future.delayed(duration);
    action();
  }

  void _performSearch() async {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });

      // Debounce the action to avoid rapid taps
      await debounce(Duration(milliseconds: 500), () async {
        await api.searchImages(searchQuery);
        setState(() {
          isLoadingMore = false;
        });
      });
    }
  }

  void _loadMoreImages() async {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });

      // Debounce the action to avoid rapid taps
      await debounce(Duration(milliseconds: 500), () async {
        if (searchQuery.isEmpty) {
          await api.loadMoreCuratedImages();
        } else {
          await api.loadMoreSearchImages(searchQuery);
        }
        setState(() {
          isLoadingMore = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Wallpapers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search wallpapers...',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    _performSearch(); // Perform search when button is clicked
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Model>>(
              future: searchQuery.isEmpty
                  ? api.fetchCuratedImages()
                  : api.searchImages(searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        String imageUrl = snapshot.data![index].src!.tiny!;
                        String imageUrls = snapshot.data![index].src!.large2x!;
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => screen(imgurl: imageUrls),
                            ));
                          },
                          child: Image.network(imageUrl),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: _loadMoreImages,
            child: Text('Load More'),
          ),
        ],
      ),
    );
  }
}
