import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_test/images_dto/images.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: omit_local_variable_types
    final ValueNotifier<List<Images>> imagesList = useState([]);

    Future<List<Images>> getImages() async {
      final response =
          await http.get(Uri.parse("https://picsum.photos/v2/list"));

      if (response.statusCode == 200) {
        final images = (jsonDecode(response.body) as List)
            .map((img) => Images.fromJson(img))
            .toList();

        imagesList.value = images;

        return imagesList.value;
      } else {
        return [];
      }
    }

    useEffect(() {
      final result = getImages();
      return () {
        // ignore: unnecessary_statements
        result;
      };
    }, []);

    return MaterialApp(
      home: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: imagesList.value.map((image) {
            return ListTile(
              title: Text(image.author!),
              subtitle: Text(image.url!),
            );
          }).toList(),
        ),
      ),
    );
  }
}
