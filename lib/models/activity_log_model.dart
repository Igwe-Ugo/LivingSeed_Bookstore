import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';

class AdminActivity {
  final String id;
  final String action; // e.g., 'Book Uploaded', 'Book Edited', 'Chapter Deleted'
  final String details; // e.g., 'Title: The New Book', 'ID: 12345'
  final DateTime timestamp;
  final IconData icon;

  AdminActivity({
    required this.id,
    required this.action,
    required this.details,
    required this.timestamp,
    required this.icon,
  });

  // Factory constructor for creating an instance from JSON
  factory AdminActivity.fromJson(Map<String, dynamic> json) {
    return AdminActivity(
      id: json['id'],
      action: json['action'],
      details: json['details'],
      timestamp: DateTime.parse(json['timestamp']),
      // Iconsax icons are standard and safe to map by name or default to a safe icon
      icon: (json['iconName'] == 'arrow_up_1')
          ? Iconsax.arrow_up_1
          : (json['iconName'] == 'edit')
              ? Iconsax.edit
              : Iconsax.activity,
    );
  }

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    String iconName;
    if (icon == Iconsax.arrow_up_1) {
      iconName = 'arrow_up_1';
    } else if (icon == Iconsax.edit) {
      iconName = 'edit';
    } else {
      iconName = 'activity';
    }

    return {
      'id': id,
      'action': action,
      'details': details,
      'timestamp': timestamp.toIso8601String(),
      'iconName': iconName,
    };
  }
}
