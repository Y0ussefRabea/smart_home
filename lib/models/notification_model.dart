class NotificationModel {
  final String title;
  final String type; // 'gas' , 'door' , 'temp'
  final DateTime time;

  NotificationModel({
    required this.title,
    required this.type,
    required this.time,
  });
}