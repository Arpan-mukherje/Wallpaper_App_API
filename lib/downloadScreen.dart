import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class screen extends StatefulWidget {
  final String imgurl;
  const screen({super.key, required this.imgurl});

  @override
  State<screen> createState() => _screenState();
}

// ignore: camel_case_types
class _screenState extends State<screen> {
  _saveImage() async {
    var response = await http.get(Uri.parse(widget.imgurl));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.bodyBytes));
    if (result['isSuccess']) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Download successful')));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to download')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          const Text(
            'Wall',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            'Paper',
            style: TextStyle(color: Colors.blue[800], fontSize: 20),
          ),
        ],
      )),
      body: Column(
        children: [
          //Container(color: Colors.white,height: 10,),
          Expanded(child: Image.network(widget.imgurl)),
          InkWell(
            onTap: () async {
              _saveImage();
            },
            child: Container(
              color: Colors.black,
              height: 60,
              width: double.infinity,
              child: const Center(
                child: Text(
                  'Download',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
