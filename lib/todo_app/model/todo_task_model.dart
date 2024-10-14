import 'package:equatable/equatable.dart';

class TodoTaskModel extends Equatable {
  final String id;
  final String value;
  final String description;
  final DateTime date;
  final bool isFavourite;
  final bool isDeleting;
  final String image;

  const TodoTaskModel({
    required this.id,
    required this.value,
    required this.description,
    required this.date,
    this.isFavourite = false,
    this.isDeleting = false,
    this.image ='',
  });

  TodoTaskModel copyWith({
    String? id,
    String? value,
    String? description,
    DateTime? date,
    bool? isFavourite,
    bool? isDeleting,
    String? image,

  }) {
    return TodoTaskModel(
      id: id ?? this.id,
      value: value ?? this.value,
      description: description ?? this.description,

      date: date ?? this.date,
      isFavourite: isFavourite ?? this.isFavourite,
      isDeleting: isDeleting ?? this.isDeleting,
      image: image?? this.image,


    );
  }

  factory TodoTaskModel.fromMap(Map<String, dynamic> map) {
    return TodoTaskModel(
      id: map['id'],
      value: map['value'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      isDeleting: map['isDeleting'] == 1,
      isFavourite: map['isFavourite'] == 1,
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
      'description': description,
      'date': date.toIso8601String(),
      'isDeleting': isDeleting ? 1 : 0,
      'isFavourite': isFavourite ? 1 : 0,
      'image': image,
    };
  }

  @override
  List<Object?> get props => [id, value, description, isFavourite, isDeleting,date,image];
}