// To parse this JSON data, do
//
//     final person = personFromJson(jsonString);

import 'dart:convert';

List<Person> personFromJson(String str) =>
    List<Person>.from(json.decode(str).map((x) => Person.fromJson(x)));

String personToJson(List<Person> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Person {
  Person({
    this.name,
    this.age,
  });

  String? name;
  String? age;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        name: json["name"],
        age: json["age"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
      };
}
