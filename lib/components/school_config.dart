// lib/models/school_config.dart
import 'package:flutter/material.dart';

class SchoolConfig {
  final String id;
  final String name;
  final String logoPath;
  final Color primaryColor;
  final List<String> authorizedDomains;

  const SchoolConfig({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.primaryColor,
    required this.authorizedDomains,
  });

  static const Map<String, SchoolConfig> schools = {
    'greenwood': SchoolConfig(
      id: 'greenwood',
      name: 'Greenwood High',
      logoPath: 'assets/logos/greenwood.png',
      primaryColor: Color(0xFF2E7D32),
      authorizedDomains: ['@greenwood.edu'],
    ),
    'riverside': SchoolConfig(
      id: 'riverside',
      name: 'Riverside Academy',
      logoPath: 'assets/logos/riverside.png',
      primaryColor: Color(0xFF1565C0),
      authorizedDomains: ['@riverside.edu'],
    ),
  };

  static String? getSchoolIdFromEmail(String email) {
    for (final school in schools.values) {
      for (final domain in school.authorizedDomains) {
        if (email.toLowerCase().endsWith(domain)) {
          return school.id;
        }
      }
    }
    return null;
  }
}