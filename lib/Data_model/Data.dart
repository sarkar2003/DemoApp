// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Data {
  String id;
  String userId;
  String description;
  String title;
  String image_path;
  String eventCategory;
  String eventDescription;
  List comments;
  Data({
    required this.id,
    required this.userId,
    required this.description,
    required this.title,
    required this.image_path,
    required this.eventCategory,
    required this.eventDescription,
    required this.comments,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'description': description,
      'title': title,
      'image_path': image_path,
      'eventCategory': eventCategory,
      'eventDescription': eventDescription,
      'comments': comments,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
        id: map['id'] as String,
        userId: map['userId'] as String,
        description: map['description'] as String,
        title: map['title'] as String,
        image_path: map['image_path'] as String,
        eventCategory: map['eventCategory'] as String,
        eventDescription: map['eventDescription'] as String,
        comments: List.from(
          (map['comments'] as List),
        ));
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);
}
