import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/profile/service/male_privacy_terms_service.dart';

class MalePrivacyAndTermsController extends GetxController {
  final MalePrivacyAndTermsService _service = MalePrivacyAndTermsService();

  var isLoading = false.obs;
  var privacyPolicyContent = "".obs;
  var termsContent = "".obs;
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
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List pages = data['data'];
          legalPages.assignAll(List<Map<String, dynamic>>.from(pages));
          
          for (var page in pages) {
            String slug = page['slug'] ?? "";
            String pageTitle = (page['title'] ?? "").toString().toLowerCase();
            
            if (pageTitle.contains('privacy') || slug.contains('privacy')) {
              fetchLegalContent(slug, isPrivacy: true);
            } else if (pageTitle.contains('terms') || slug.contains('terms') || pageTitle.contains('condition')) {
              fetchLegalContent(slug, isTerms: true);
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching male legal pages list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLegalContent(String slug, {bool isPrivacy = false, bool isTerms = false}) async {
    try {
      final response = await _service.getLegalPageBySlug(slug);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final pageData = data['data'];
          final content = pageData['description'] ?? 
                          pageData['content'] ?? 
                          pageData['text'] ?? "";
          
          if (isPrivacy) {
            privacyPolicyContent.value = _stripHtmlIfNeeded(content);
          } else if (isTerms) {
            termsContent.value = _stripHtmlIfNeeded(content);
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching male legal content for $slug: $e");
    }
  }

  String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&nbsp;'), ' ').trim();
  }
}
