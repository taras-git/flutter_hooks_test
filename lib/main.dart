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

  Future<List<Images>?> getImages() async {
    http.Response response;

    try {
      response = await http.get(Uri.parse("https://picsum.photos/v2/list"));
    } on Exception catch (_) {
      return null;
    }

    if (response.statusCode == 200) {
      final images = (jsonDecode(response.body) as List)
          .map((img) => Images.fromJson(img))
          .toList();

      return images;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final futureImages = useMemoized(getImages);
    final snapshot = useFuture(futureImages);

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: snapshot.connectionState == ConnectionState.waiting
              ? const CircularProgressIndicator()
              : snapshot.hasError
                  ? Text('Some issue ${snapshot.error}')
                  : snapshot.hasData
                      ? Text('${snapshot.data}')
                      : const Text('No data...'),
        ),
      ),
    );
  }
}
