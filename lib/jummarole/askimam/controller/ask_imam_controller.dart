import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/shared/model/ask_question_model.dart';
import 'package:muslim_community/jummarole/askimam/service/ask_imam_service.dart';
import 'package:muslim_community/services/socket_service.dart';

class AskImamController extends GetxController {
  final AskImamService _service = AskImamService();
  final SocketService _socketService = SocketService();

  final questionController = TextEditingController();
  final RxList<AskQuestionModel> myQuestions = <AskQuestionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    fetchMyQuestions();
    _setupSocketListeners();
    _startPolling();
  }

  @override
  void onClose() {
    _removeSocketListeners();
    _stopPolling();
    questionController.dispose();
    super.onClose();
  }

  void _startPolling() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      print("POLLING_DEBUG: Auto-refreshing Ask Imam questions");
      fetchMyQuestions(isSilent: true);
    });
  }

  void _stopPolling() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  void _setupSocketListeners() async {
    try {
      if (!_socketService.isConnected) {
        await _socketService.connect();
      }
      _socketService.on('UPDATE_DISCOVERY', (data) {
        print("SOCKET_DEBUG: Discovery update received for questions");
        fetchMyQuestions(isSilent: true);
      });
      _socketService.on('NEW_QUESTION', (data) {
        print("SOCKET_DEBUG: New question/answer update");
        fetchMyQuestions(isSilent: true);
      });
    } catch (e) {
      print("Error setting up socket listeners for ask imam: $e");
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
          myQuestions.assignAll(fetchedQuestions);
        }
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
      final response = await _service.submitQuestion(question);
      final decoded = jsonDecode(response.body);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchMyQuestions(isSilent: true);
        return true;
      } else {
        Get.snackbar(
          "Error",
          decoded['message'] ?? decoded['error'] ?? "Failed to submit question",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. $e");
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
