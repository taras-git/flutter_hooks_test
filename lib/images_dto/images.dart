import 'package:freezed_annotation/freezed_annotation.dart';

part 'images.freezed.dart';
part 'images.g.dart';

@freezed
class Images with _$Images {
  factory Images({
    String? id,
    String? author,
    int? width,
    int? height,
    String? url,
    @JsonKey(name: 'download_url') String? downloadUrl,
  }) = _Images;

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);
}
