import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import '../models/delivery_schedule.dart';
import '../services/delivery_schedule_service.dart';
import '../services/schedule_conflict_service.dart';
import '../services/notification_service.dart';

class DeliveryScheduleProvider extends ChangeNotifier {
  final DeliveryScheduleService _scheduleService;
  final ScheduleConflictService _conflictService;
  final NotificationService _notificationService;
  final Logger _logger;

  bool _isLoading = false;
  String? _error;
  List<DeliverySchedule> _schedules = [];
  DeliverySchedule? _currentSchedule;
  List<DeliverySchedule> _conflicts = [];

  DeliveryScheduleProvider(
    this._scheduleService,
    this._conflictService,
    this._notificationService, [
    Logger? logger,
  ]) : _logger = logger ?? Logger('DeliveryScheduleProvider');

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<DeliverySchedule> get schedules => _schedules;
  DeliverySchedule? get currentSchedule => _currentSchedule;
  List<DeliverySchedule> get conflicts => _conflicts;

  Future<bool> checkForConflicts({
    required String driverId,
    required DateTime scheduledTime,
    required Duration estimatedDuration,
    String? excludeScheduleId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final conflicts = await _conflictService.checkConflicts(
        driverId: driverId,
        scheduledTime: scheduledTime,
      );

      _conflicts = conflicts;
      return conflicts.isNotEmpty;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createSchedule({
    required String deliveryId,
    required String driverId,
    required DateTime scheduledTime,
    String? notes,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _logger.info('Creating schedule for delivery: $deliveryId');

      // Check for conflicts
      final conflicts = await _conflictService.checkConflicts(
        driverId: driverId,
        scheduledTime: scheduledTime,
      );

      if (conflicts.isNotEmpty) {
        _conflicts = conflicts;
        _error = 'Schedule conflicts detected';
        notifyListeners();
        return;
      }

      // Create schedule
      final schedule = await _scheduleService.createSchedule(
        deliveryId: deliveryId,
        driverId: driverId,
        scheduledTime: scheduledTime,
        notes: notes,
      );

      // Schedule notification
      await _notificationService.scheduleNotification(
        id: schedule.id,
        title: 'Upcoming Delivery',
        body: 'You have a delivery scheduled in 30 minutes',
        scheduledTime: scheduledTime.subtract(const Duration(minutes: 30)),
        payload: {
          'type': 'schedule',
          'scheduleId': schedule.id,
          'deliveryId': deliveryId,
        },
      );

      _schedules.add(schedule);
      _logger.info('Schedule created successfully');
    } catch (e) {
      _error = 'Failed to create schedule: $e';
      _logger.severe('Error creating schedule: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateScheduleStatus({
    required String scheduleId,
    required String status,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _logger.info('Updating schedule status: $scheduleId');

      final updatedSchedule = await _scheduleService.updateScheduleStatus(
        scheduleId: scheduleId,
        status: status,
      );

      // Update notification if status changes
      if (status == 'cancelled') {
        await _notificationService.cancelNotification(scheduleId);
      } else if (status == 'completed') {
        await _notificationService.sendNotification(
          title: 'Delivery Completed',
          body: 'Your scheduled delivery has been completed',
          payload: {
            'type': 'schedule',
            'scheduleId': scheduleId,
            'status': status,
          },
        );
      }

      final index = _schedules.indexWhere((s) => s.id == scheduleId);
      if (index != -1) {
        _schedules[index] = updatedSchedule;
      }

      _logger.info('Schedule status updated successfully');
    } catch (e) {
      _error = 'Failed to update schedule status: $e';
      _logger.severe('Error updating schedule status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDriverSchedules(String driverId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _logger.info('Loading schedules for driver: $driverId');

      _scheduleService.getDriverSchedules(driverId).listen(
        (schedules) {
          _schedules = schedules;
          notifyListeners();
        },
        onError: (e) {
          _error = 'Failed to load schedules: $e';
          _logger.severe('Error loading schedules: $e');
          notifyListeners();
        },
      );
    } catch (e) {
      _error = 'Failed to load schedules: $e';
      _logger.severe('Error loading schedules: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSchedule(String scheduleId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentSchedule = await _scheduleService.getSchedule(scheduleId);
    } catch (e) {
      _error = 'Failed to load schedule: $e';
      _logger.severe('Error loading schedule: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSchedulesByDateRange({
    required String driverId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final schedules = await _scheduleService.getSchedulesByDateRange(
        driverId: driverId,
        startDate: startDate,
        endDate: endDate,
      );

      _schedules = schedules;
    } catch (e) {
      _error = 'Failed to load schedules: $e';
      _logger.severe('Error loading schedules: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelSchedule(String scheduleId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _scheduleService.cancelSchedule(scheduleId);
      await _notificationService.cancelNotification(scheduleId);

      final index = _schedules.indexWhere((s) => s.id == scheduleId);
      if (index != -1) {
        _schedules.removeAt(index);
      }
    } catch (e) {
      _error = 'Failed to cancel schedule: $e';
      _logger.severe('Error cancelling schedule: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearConflicts() {
    _conflicts = [];
    notifyListeners();
  }
}
