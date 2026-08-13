// To parse this JSON data, do
//
//     final createEventsModal = createEventsModalFromJson(jsonString);

import 'dart:convert';

CreateEventsModal createEventsModalFromJson(String str) =>
    CreateEventsModal.fromJson(json.decode(str));

String createEventsModalToJson(CreateEventsModal data) =>
    json.encode(data.toJson());

class CreateEventsModal {
  final bool success;
  final String message;
  final Event event;

  CreateEventsModal({
    required this.success,
    required this.message,
    required this.event,
  });

  factory CreateEventsModal.fromJson(Map<String, dynamic> json) =>
      CreateEventsModal(
        success: json["success"],
        message: json["message"],
        event: Event.fromJson(json["event"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "event": event.toJson(),
  };
}

class Event {
  final String id;
  final String organizerId;
  final String title;
  final String description;
  final String whatToExpect;
  final String organizerNote;
  final DateTime eventDate;
  final String venueName;
  final String venueAddress;
  final String posterUrl;
  final dynamic latitude;
  final dynamic longitude;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.organizerId,
    required this.title,
    required this.description,
    required this.whatToExpect,
    required this.organizerNote,
    required this.eventDate,
    required this.venueName,
    required this.venueAddress,
    required this.posterUrl,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    organizerId: json["organizer_id"],
    title: json["title"],
    description: json["description"],
    whatToExpect: json["what_to_expect"],
    organizerNote: json["organizer_note"],
    eventDate: DateTime.parse(json["event_date"]),
    venueName: json["venue_name"],
    venueAddress: json["venue_address"],
    posterUrl: json["poster_url"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "organizer_id": organizerId,
    "title": title,
    "description": description,
    "what_to_expect": whatToExpect,
    "organizer_note": organizerNote,
    "event_date": eventDate.toIso8601String(),
    "venue_name": venueName,
    "venue_address": venueAddress,
    "poster_url": posterUrl,
    "latitude": latitude,
    "longitude": longitude,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
