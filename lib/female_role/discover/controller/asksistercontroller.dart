import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/discover/model/ask_question_model.dart';
import 'package:muslim_community/female_role/discover/service/asksisterservice.dart';

class AskSisterController extends GetxController {
  final AskSisterService _service = AskSisterService();

  final RxList<AskQuestionModel> myQuestions = <AskQuestionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyQuestions();
  }

  Future<void> fetchMyQuestions() async {
    isLoading.value = true;
    try {
      final response = await _service.getMyQuestions();
      debugPrint("Fetch my questions status: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final rawData = decoded['data'];
          if (rawData is List) {
            myQuestions.assignAll(rawData.map((json) => AskQuestionModel.fromJson(json)).toList());
          } else if (rawData is Map) {
            myQuestions.assignAll([AskQuestionModel.fromJson(Map<String, dynamic>.from(rawData))]);
          }
        }
      } else {
        debugPrint("Error fetching my questions: ${response.body}");
      }
    } catch (e) {
      debugPrint("Exception fetching my questions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submitQuestion(String question) async {
    if (question.trim().isEmpty) {
      Get.snackbar(
        "Required",
        "Please enter your question.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }

    isSubmitting.value = true;
    try {
      final response = await _service.submitQuestion(question.trim());
      debugPrint("Submit question status: ${response.statusCode}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          Get.snackbar(
            "Success",
            "Question submitted successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Refresh list of questions
          fetchMyQuestions();
          return true;
        }
      }
      
      Get.snackbar(
        "Failed",
        "Failed to submit question. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      debugPrint("Exception submitting question: $e");
      Get.snackbar(
        "Error",
        "An unexpected error occurred. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
