import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/female_role/profile/service/privacyandtreamservice.dart';

class PrivacyAndTermsController extends GetxController {
  final PrivacyAndTermsService _service = PrivacyAndTermsService();

  var isLoading = false.obs;
  var privacyPolicyContent = "".obs;
  var termsContent = "".obs;
  var title = "".obs;
  var legalPages = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllLegalPages();
  }

  Future<void> fetchAllLegalPages() async {
    isLoading.value = true;
    try {
      final response = await _service.getLegalPages();
      debugPrint("Legal Pages Response: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final pages = data['data'];
          if (pages is List) {
            legalPages.assignAll(List<Map<String, dynamic>>.from(pages));
            
            for (var page in pages) {
              String slug = page['slug'] ?? "";
              String pageTitle = (page['title'] ?? "").toString().toLowerCase();
              
              debugPrint("Checking page: Title=$pageTitle, Slug=$slug");

              if (pageTitle.contains('privacy') || slug.contains('privacy')) {
                debugPrint("Found Privacy Page, fetching content for slug: $slug");
                fetchLegalContent(slug, isPrivacy: true);
              } else if (pageTitle.contains('terms') || slug.contains('terms') || pageTitle.contains('condition')) {
                debugPrint("Found Terms Page, fetching content for slug: $slug");
                fetchLegalContent(slug, isTerms: true);
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching legal pages list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLegalContent(String slug, {bool isPrivacy = false, bool isTerms = false}) async {
    try {
      final response = await _service.getLegalPageBySlug(slug);
      debugPrint("Content Response for $slug: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          var pageData = data['data'];
          
          // If the API returns an array instead of a single object, take the first element
          if (pageData is List && pageData.isNotEmpty) {
            pageData = pageData[0];
          }
          
          if (pageData is Map) {
            final content = pageData['description'] ?? 
                            pageData['content'] ?? 
                            pageData['text'] ?? "";
            
            if (isPrivacy) {
              privacyPolicyContent.value = _stripHtmlIfNeeded(content.toString());
              debugPrint("Privacy Content Updated: ${privacyPolicyContent.value.length} chars");
            } else if (isTerms) {
              termsContent.value = _stripHtmlIfNeeded(content.toString());
              debugPrint("Terms Content Updated: ${termsContent.value.length} chars");
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching legal content for $slug: $e");
    }
  }

  // Simple helper to remove HTML tags if backend sends HTML
  String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&nbsp;'), ' ').trim();
  }
}
