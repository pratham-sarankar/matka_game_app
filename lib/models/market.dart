import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/utils/time_of_day_extension.dart';

/// A model class representing a market in the matka game.
///
/// A market has specific operating hours and days when it is open for betting.
/// It also defines the last time when bets can be placed before closing.
class Market {
  /// Unique identifier for the market.
  final String id;

  /// Name of the market.
  final String name;

  /// The time when the market opens for betting.
  final TimeOfDay openTime;

  /// The last time when bets can be placed during the open session.
  final TimeOfDay openLastBidTime;

  /// The time when the market closes for betting.
  final TimeOfDay closeTime;

  /// The last time when bets can be placed during the close session.
  final TimeOfDay closeLastBidTime;

  /// A 7-character string representing the days when the market is open.
  ///
  /// Each character represents a day of the week, starting from Monday (0) to Sunday (6).
  /// '1' indicates the market is open on that day, '0' indicates it is closed.
  /// Example: '1111100' means the market is open Monday through Friday, closed on weekends.
  final String openDays;

  /// Creates a new [Market] instance.
  ///
  /// All parameters are required and must be valid:
  /// - [id] must be a non-empty string
  /// - [name] must be a non-empty string
  /// - [openTime] must be before [closeTime]
  /// - [openLastBidTime] must be between [openTime] and [closeTime]
  /// - [closeLastBidTime] must be between [openTime] and [closeTime]
  /// - [openDays] must be a 7-character string containing only '0' and '1'
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

  /// Creates a [Market] instance from a map of data.
  ///
  /// The map must contain all required fields with correct types.
  /// This is an internal factory method used by [fromDoc].
  factory Market.fromMap(Map<String, dynamic> map) {
    return Market(
      id: map['id'] as String,
      name: map['name'] as String,
      openTime: TimeOfDayExtension.fromString(map['openTime'] as String),
      openLastBidTime:
          TimeOfDayExtension.fromString(map['openLastBidTime'] as String),
      closeTime: TimeOfDayExtension.fromString(map['closeTime'] as String),
      closeLastBidTime:
          TimeOfDayExtension.fromString(map['closeLastBidTime'] as String),
      openDays: map['openDays'] as String,
    );
  }

  /// Creates a [Market] instance from a Firestore document.
  ///
  /// The document must contain all required fields with correct types.
  /// The document ID is used as the market's ID.
  factory Market.fromDoc(QueryDocumentSnapshot doc) {
    return Market.fromMap({
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>,
    });
  }

  /// Creates an empty [Market] instance with default values.
  ///
  /// All time fields are set to midnight (00:00).
  /// The market is closed on all days (openDays = '0000000').
  Market.empty()
      : this(
          id: '',
          name: '',
          openTime: TimeOfDay(hour: 0, minute: 0),
          openLastBidTime: TimeOfDay(hour: 0, minute: 0),
          closeTime: TimeOfDay(hour: 0, minute: 0),
          closeLastBidTime: TimeOfDay(hour: 0, minute: 0),
          openDays: '0000000',
        );

  /// Converts the [Market] instance to a map for Firestore storage.
  ///
  /// All time fields are formatted as strings in 24-hour format (HH:mm).
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'openTime': openTime.format24Hour(),
      'openLastBidTime': openLastBidTime.format24Hour(),
      'closeTime': closeTime.format24Hour(),
      'closeLastBidTime': closeLastBidTime.format24Hour(),
      'openDays': openDays,
    };
  }

  /// Determines which session (open or close) the market is currently in.
  ///
  /// Returns 'open' if we're in open session, 'close' if we're in close session,
  /// or null if the market is closed.
  String? get currentSession {
    final now = TimeOfDay.now();
    return _getSessionForTime(now);
  }

  /// Helper method to determine session for a given time.
  String? _getSessionForTime(TimeOfDay time) {
    final currentMinutes = time.hour * 60 + time.minute;
    final openMinutes = openTime.hour * 60 + openTime.minute;
    final closeMinutes = closeTime.hour * 60 + closeTime.minute;

    // If close time is less than open time, it means the market spans across midnight
    if (closeMinutes < openMinutes) {
      if (currentMinutes >= openMinutes) {
        return 'open';
      } else if (currentMinutes <= closeMinutes) {
        return 'close';
      }
    } else {
      if (currentMinutes >= openMinutes && currentMinutes <= closeMinutes) {
        return 'open';
      }
    }
    return null;
  }

  /// Checks if the market is currently open for betting.
  ///
  /// A market is considered open if:
  /// 1. The current day is marked as open in [openDays]
  /// 2. The current time is within a valid session (open or close)
  /// 3. The current time is before the last bid time for that session
  bool get isOpen {
    final now = TimeOfDay.now();
    final currentDay = DateTime.now().weekday - 1; // 0-6 for Monday-Sunday
    return _isOpenForTime(now, currentDay);
  }

  /// Helper method to check if market is open for a given time and day.
  bool _isOpenForTime(TimeOfDay time, int day) {
    final isOpenDay = openDays[day] == '1';
    if (!isOpenDay) {
      return false;
    }

    final session = _getSessionForTime(time);
    if (session == null) return false;

    final currentMinutes = time.hour * 60 + time.minute;

    if (session == 'open') {
      final openLastBidMinutes =
          openLastBidTime.hour * 60 + openLastBidTime.minute;
      return currentMinutes <= openLastBidMinutes;
    } else {
      final closeLastBidMinutes =
          closeLastBidTime.hour * 60 + closeLastBidTime.minute;
      return currentMinutes <= closeLastBidMinutes;
    }
  }

  /// Checks if bets can still be placed in the market.
  ///
  /// Returns true if:
  /// 1. The market is open ([isOpen] returns true)
  /// 2. The current time is before or equal to the appropriate last bid time
  ///    based on whether we're in open or close session
  bool get canPlaceBid {
    return isOpen;
  }

  /// Creates a copy of this [Market] with the given fields replaced with new values.
  ///
  /// All fields are optional. If a field is not provided, the value from this
  /// instance will be used in the new instance.
  Market copyWith({
    String? id,
    String? name,
    TimeOfDay? openTime,
    TimeOfDay? openLastBidTime,
    TimeOfDay? closeTime,
    TimeOfDay? closeLastBidTime,
    String? openDays,
  }) {
    return Market(
      id: id ?? this.id,
      name: name ?? this.name,
      openTime: openTime ?? this.openTime,
      openLastBidTime: openLastBidTime ?? this.openLastBidTime,
      closeTime: closeTime ?? this.closeTime,
      closeLastBidTime: closeLastBidTime ?? this.closeLastBidTime,
      openDays: openDays ?? this.openDays,
    );
  }
}
