import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matka_game_app/models/market.dart';
import 'package:get/get.dart';

// Test helper class to manage time-dependent tests
class TestTimeProvider {
  static TimeOfDay? _mockTime;
  static DateTime? _mockDate;

  static TimeOfDay get currentTime => _mockTime ?? TimeOfDay.now();
  static DateTime get currentDate => _mockDate ?? DateTime.now();

  static void setMockTime(TimeOfDay time) => _mockTime = time;
  static void setMockDate(DateTime date) => _mockDate = date;
  static void resetMocks() {
    _mockTime = null;
    _mockDate = null;
  }
}

// Extension to override TimeOfDay.now() for testing
extension TimeOfDayTestExtension on TimeOfDay {
  static TimeOfDay now() => TestTimeProvider.currentTime;
}

// Extension to override DateTime.now() for testing
extension DateTimeTestExtension on DateTime {
  static DateTime now() => TestTimeProvider.currentDate;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Market Model Tests', () {
    late Market validMarket;

    setUp(() {
      validMarket = Market(
        id: 'test_market',
        name: 'Test Market',
        openTime: TimeOfDay(hour: 9, minute: 0),
        openLastBidTime: TimeOfDay(hour: 11, minute: 0),
        closeTime: TimeOfDay(hour: 15, minute: 0),
        closeLastBidTime: TimeOfDay(hour: 14, minute: 0),
        openDays: '1111100', // Monday to Friday
      );
    });

    tearDown(() {
      TestTimeProvider.resetMocks();
    });

    test('Market initialization with valid data', () {
      expect(validMarket.id, equals('test_market'));
      expect(validMarket.name, equals('Test Market'));
      expect(validMarket.openTime, equals(TimeOfDay(hour: 9, minute: 0)));
      expect(
          validMarket.openLastBidTime, equals(TimeOfDay(hour: 11, minute: 0)));
      expect(validMarket.closeTime, equals(TimeOfDay(hour: 15, minute: 0)));
      expect(
          validMarket.closeLastBidTime, equals(TimeOfDay(hour: 14, minute: 0)));
      expect(validMarket.openDays, equals('1111100'));
    });

    test('Market initialization with invalid openDays length throws assertion',
        () {
      expect(
        () => Market(
          id: 'test',
          name: 'Test',
          openTime: TimeOfDay(hour: 9, minute: 0),
          openLastBidTime: TimeOfDay(hour: 11, minute: 0),
          closeTime: TimeOfDay(hour: 15, minute: 0),
          closeLastBidTime: TimeOfDay(hour: 14, minute: 0),
          openDays: '11111', // Invalid length
        ),
        throwsAssertionError,
      );
    });

    test(
        'Market initialization with invalid openDays characters throws assertion',
        () {
      expect(
        () => Market(
          id: 'test',
          name: 'Test',
          openTime: TimeOfDay(hour: 9, minute: 0),
          openLastBidTime: TimeOfDay(hour: 11, minute: 0),
          closeTime: TimeOfDay(hour: 15, minute: 0),
          closeLastBidTime: TimeOfDay(hour: 14, minute: 0),
          openDays: '1111122', // Invalid characters
        ),
        throwsAssertionError,
      );
    });

    test('Market.empty() creates market with default values', () {
      final emptyMarket = Market.empty();
      expect(emptyMarket.id, equals(''));
      expect(emptyMarket.name, equals(''));
      expect(emptyMarket.openTime, equals(TimeOfDay(hour: 0, minute: 0)));
      expect(
          emptyMarket.openLastBidTime, equals(TimeOfDay(hour: 0, minute: 0)));
      expect(emptyMarket.closeTime, equals(TimeOfDay(hour: 0, minute: 0)));
      expect(
          emptyMarket.closeLastBidTime, equals(TimeOfDay(hour: 0, minute: 0)));
      expect(emptyMarket.openDays, equals('0000000'));
    });

    test('Market.fromMap creates market from map data', () {
      final map = {
        'id': 'test_market',
        'name': 'Test Market',
        'openTime': '09:00',
        'openLastBidTime': '11:00',
        'closeTime': '15:00',
        'closeLastBidTime': '14:00',
        'openDays': '1111100',
      };

      final market = Market.fromMap(map);
      expect(market.id, equals('test_market'));
      expect(market.name, equals('Test Market'));
      expect(market.openTime, equals(TimeOfDay(hour: 9, minute: 0)));
      expect(market.openLastBidTime, equals(TimeOfDay(hour: 11, minute: 0)));
      expect(market.closeTime, equals(TimeOfDay(hour: 15, minute: 0)));
      expect(market.closeLastBidTime, equals(TimeOfDay(hour: 14, minute: 0)));
      expect(market.openDays, equals('1111100'));
    });

    test('Market.toMap converts market to map', () {
      // Create a test context
      final testContext = TestWidgetsFlutterBinding.ensureInitialized();
      Get.put(testContext);

      final map = validMarket.toMap();
      expect(map['name'], equals('Test Market'));
      expect(map['openTime'], equals('09:00'));
      expect(map['openLastBidTime'], equals('11:00'));
      expect(map['closeTime'], equals('15:00'));
      expect(map['closeLastBidTime'], equals('14:00'));
      expect(map['openDays'], equals('1111100'));
    });

    test('Market.copyWith creates new instance with updated fields', () {
      final updatedMarket = validMarket.copyWith(
        name: 'Updated Market',
        openTime: TimeOfDay(hour: 10, minute: 0),
      );

      expect(updatedMarket.id, equals(validMarket.id));
      expect(updatedMarket.name, equals('Updated Market'));
      expect(updatedMarket.openTime, equals(TimeOfDay(hour: 10, minute: 0)));
      expect(
          updatedMarket.openLastBidTime, equals(validMarket.openLastBidTime));
      expect(updatedMarket.closeTime, equals(validMarket.closeTime));
      expect(
          updatedMarket.closeLastBidTime, equals(validMarket.closeLastBidTime));
      expect(updatedMarket.openDays, equals(validMarket.openDays));
    });

    group('Market Time-based Operations', () {
      test('currentSession returns correct session during open hours', () {
        final now = TimeOfDay(hour: 10, minute: 0);
        final market = validMarket.copyWith(
          openTime: TimeOfDay(hour: 9, minute: 0),
          closeTime: TimeOfDay(hour: 15, minute: 0),
        );

        final currentMinutes = now.hour * 60 + now.minute;
        final openMinutes = market.openTime.hour * 60 + market.openTime.minute;
        final closeMinutes =
            market.closeTime.hour * 60 + market.closeTime.minute;

        expect(currentMinutes >= openMinutes && currentMinutes <= closeMinutes,
            isTrue);
      });

      test('currentSession returns correct session during close hours', () {
        final now = TimeOfDay(hour: 13, minute: 0);
        final market = validMarket.copyWith(
          openTime: TimeOfDay(hour: 9, minute: 0),
          closeTime: TimeOfDay(hour: 15, minute: 0),
        );

        final currentMinutes = now.hour * 60 + now.minute;
        final openMinutes = market.openTime.hour * 60 + market.openTime.minute;
        final closeMinutes =
            market.closeTime.hour * 60 + market.closeTime.minute;

        expect(currentMinutes >= openMinutes && currentMinutes <= closeMinutes,
            isTrue);
      });

      test('currentSession returns null outside market hours', () {
        final now = TimeOfDay(hour: 8, minute: 0);
        final market = validMarket.copyWith(
          openTime: TimeOfDay(hour: 9, minute: 0),
          closeTime: TimeOfDay(hour: 15, minute: 0),
        );

        final currentMinutes = now.hour * 60 + now.minute;
        final openMinutes = market.openTime.hour * 60 + market.openTime.minute;
        final closeMinutes =
            market.closeTime.hour * 60 + market.closeTime.minute;

        expect(currentMinutes < openMinutes || currentMinutes > closeMinutes,
            isTrue);
      });

      test('isOpen returns true during valid open session', () {
        final market = validMarket.copyWith(
          openTime: TimeOfDay(hour: 9, minute: 0),
          openLastBidTime: TimeOfDay(hour: 11, minute: 0),
          closeTime: TimeOfDay(hour: 15, minute: 0),
          closeLastBidTime: TimeOfDay(hour: 14, minute: 0),
          openDays: '1111100',
        );

        final now = TimeOfDay(hour: 10, minute: 0);
        final currentMinutes = now.hour * 60 + now.minute;
        final openMinutes = market.openTime.hour * 60 + market.openTime.minute;
        final openLastBidMinutes =
            market.openLastBidTime.hour * 60 + market.openLastBidTime.minute;

        expect(
            currentMinutes >= openMinutes &&
                currentMinutes <= openLastBidMinutes,
            isTrue);
      });

      test('isOpen returns false on closed day', () {
        final market = validMarket.copyWith(
          openDays: '0000001', // Only open on Sunday
        );

        final now = TimeOfDay(hour: 10, minute: 0);
        final currentDay = DateTime(2024, 1, 1).weekday - 1; // Monday

        expect(market.openDays[currentDay] == '0', isTrue);
      });

      test('isOpen returns false after last bid time', () {
        final market = validMarket.copyWith(
          openTime: TimeOfDay(hour: 9, minute: 0),
          openLastBidTime: TimeOfDay(hour: 11, minute: 0),
        );

        final now = TimeOfDay(hour: 11, minute: 30);
        final currentMinutes = now.hour * 60 + now.minute;
        final openLastBidMinutes =
            market.openLastBidTime.hour * 60 + market.openLastBidTime.minute;

        expect(currentMinutes > openLastBidMinutes, isTrue);
      });

      test('canPlaceBid returns true when market is open', () {
        final market = validMarket.copyWith(
          openTime: TimeOfDay(hour: 9, minute: 0),
          openLastBidTime: TimeOfDay(hour: 11, minute: 0),
          openDays: '1111100',
        );

        final now = TimeOfDay(hour: 10, minute: 0);
        final currentMinutes = now.hour * 60 + now.minute;
        final openMinutes = market.openTime.hour * 60 + market.openTime.minute;
        final openLastBidMinutes =
            market.openLastBidTime.hour * 60 + market.openLastBidTime.minute;

        expect(
            currentMinutes >= openMinutes &&
                currentMinutes <= openLastBidMinutes,
            isTrue);
      });

      test('canPlaceBid returns false when market is closed', () {
        final market = validMarket.copyWith(
          openTime: TimeOfDay(hour: 9, minute: 0),
          openLastBidTime: TimeOfDay(hour: 11, minute: 0),
        );

        final now = TimeOfDay(hour: 8, minute: 0);
        final currentMinutes = now.hour * 60 + now.minute;
        final openMinutes = market.openTime.hour * 60 + market.openTime.minute;

        expect(currentMinutes < openMinutes, isTrue);
      });
    });
  });
}
