import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/shared/model/ask_question_model.dart';
import 'package:muslim_community/female_role/discover/service/asksisterservice.dart';
import 'package:muslim_community/services/socket_service.dart';

class AskSisterController extends GetxController {
  final AskSisterService _service = AskSisterService();
  final SocketService _socketService = SocketService();

  final RxList<AskQuestionModel> myQuestions = <AskQuestionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyQuestions();
    _setupSocketListeners();
  }

  @override
  void onClose() {
    _removeSocketListeners();
    super.onClose();
  }

  void _setupSocketListeners() async {
    try {
      if (!_socketService.isConnected) {
        await _socketService.connect();
      }
      _socketService.on('UPDATE_DISCOVERY', (data) {
        print("SOCKET_DEBUG: Discovery update received for female questions");
        fetchMyQuestions(isSilent: true);
      });
      _socketService.on('NEW_QUESTION', (data) {
        print("SOCKET_DEBUG: New female question/answer update");
        fetchMyQuestions(isSilent: true);
      });
    } catch (e) {
      print("Error setting up socket listeners for ask sister: $e");
    }
  }

  void _removeSocketListeners() {
    _socketService.off('UPDATE_DISCOVERY');
    _socketService.off('NEW_QUESTION');
  }

  Future<void> fetchMyQuestions({bool isSilent = false}) async {
    if (!isSilent) isLoading.value = true;
    try {
      final response = await _service.getMyQuestions();
      debugPrint("Fetch my questions status: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final rawData = decoded['data'];
          final List<AskQuestionModel> fetchedQuestions = [];
          
          if (rawData is List) {
            fetchedQuestions.addAll(rawData.map((json) => AskQuestionModel.fromJson(json)).toList());
          } else if (rawData is Map) {
            fetchedQuestions.add(AskQuestionModel.fromJson(Map<String, dynamic>.from(rawData)));
          }

          if (myQuestions.length != fetchedQuestions.length) {
            myQuestions.assignAll(fetchedQuestions);
          } else {
            myQuestions.assignAll(fetchedQuestions);
          }
        }
      } else {
        debugPrint("Error fetching my questions: ${response.body}");
      }
    } catch (e) {
      debugPrint("Exception fetching my questions: $e");
    } finally {
      if (!isSilent) isLoading.value = false;
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
