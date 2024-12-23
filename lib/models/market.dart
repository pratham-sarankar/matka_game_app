import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/utils/time_of_day_extension.dart';

class Market {
  final String id;
  String name;
  TimeOfDay openTime;
  TimeOfDay openLastBidTime;
  TimeOfDay closeTime;
  TimeOfDay closeLastBidTime;

  /// A 7 character string representing with 0 and 1.
  ///
  /// 0 means closed and 1 means open.
  /// The first character represents Monday and the last one represents Sunday.
  String openDays;

  Market({
    required this.id,
    required this.name,
    required this.openTime,
    required this.openLastBidTime,
    required this.closeTime,
    required this.closeLastBidTime,
    required this.openDays,
  })  : assert(openDays.length == 7, "openDays must be a 7 character string."),
        assert(openDays.contains(RegExp(r'^[01]+$')),
            "openDays must contain only 0 and 1.");

  factory Market._fromMap(Map<String, dynamic> map) {
    return Market(
      id: map['id'],
      name: map['name'],
      openTime: TimeOfDayExtension.fromString(map['openTime']),
      openLastBidTime: TimeOfDayExtension.fromString(map['openLastBidTime']),
      closeTime: TimeOfDayExtension.fromString(map['closeTime']),
      closeLastBidTime: TimeOfDayExtension.fromString(map['closeLastBidTime']),
      openDays: map['openDays'],
    );
  }

  /// Creates a [Market] from a [QueryDocumentSnapshot].
  factory Market.fromDoc(QueryDocumentSnapshot doc) {
    final Map<String, dynamic> map = {
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>,
    };
    return Market._fromMap(map);
  }

  Market.empty()
      : this(
          id: '',
          name: '',
          openTime: const TimeOfDay(hour: 0, minute: 0),
          openLastBidTime: const TimeOfDay(hour: 0, minute: 0),
          closeTime: const TimeOfDay(hour: 0, minute: 0),
          closeLastBidTime: const TimeOfDay(hour: 0, minute: 0),
          openDays: '0000000',
        );

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'openTime': openTime.format(Get.context!),
      'openLastBidTime': openLastBidTime.format(Get.context!),
      'closeTime': closeTime.format(Get.context!),
      'closeLastBidTime': closeLastBidTime.format(Get.context!),
      'openDays': openDays,
    };
  }

  bool get isOpen {
    final now = TimeOfDay.now();
    return now.isAfter(openTime) && now.isBefore(closeTime);
  }
}
