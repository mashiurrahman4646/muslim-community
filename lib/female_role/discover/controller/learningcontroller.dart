import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'package:muslim_community/female_role/discover/model/learning_content_model.dart';
import 'package:muslim_community/female_role/discover/model/learning_comment_model.dart';
import 'package:muslim_community/female_role/discover/service/learningservice.dart';
import 'package:muslim_community/female_role/home/controller/userdatacontroller.dart';
import 'package:muslim_community/services/socket_service.dart';

class FemaleLearningController extends GetxController {
  final LearningService _service = LearningService();
  final SocketService _socketService = SocketService();
  
  var isLoading = false.obs;
  var learningContents = <LearningContentModel>[].obs;

  var isCommentsLoading = false.obs;
  var comments = <LearningCommentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLearningContents();
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
        print("SOCKET_DEBUG: Discovery update received for female learning");
        fetchLearningContents(isSilent: true);
      });
      _socketService.on('NEW_LEARNING', (data) {
        print("SOCKET_DEBUG: New female learning content added");
        fetchLearningContents(isSilent: true);
      });
    } catch (e) {
      print("Error setting up socket listeners for female learning: $e");
    }
  }

  void _removeSocketListeners() {
    _socketService.off('UPDATE_DISCOVERY');
    _socketService.off('NEW_LEARNING');
  }

  Future<void> fetchLearningContents({bool isSilent = false}) async {
    if (!isSilent) isLoading.value = true;
    try {
      final response = await _service.getLearningContents();
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        
        final List<LearningContentModel> newContents = data.map((json) => LearningContentModel.fromJson(json)).toList();
        
        // Update only if there's a change
        if (learningContents.length != newContents.length) {
          learningContents.value = newContents;
        } else {
          learningContents.value = newContents;
        }
      } else {
        print("Failed to fetch female learning contents: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching female learning contents: $e");
    } finally {
      if (!isSilent) isLoading.value = false;
    }
  }

  Future<void> toggleLike(String contentId) async {
    try {
      final response = await _service.toggleLike(contentId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        int index = learningContents.indexWhere((c) => c.id == contentId);
        if (index != -1) {
          final content = learningContents[index];
          final updatedContent = LearningContentModel(
            id: content.id,
            title: content.title,
            description: content.description,
            videoUrl: content.videoUrl,
            category: content.category,
            durationInSeconds: content.durationInSeconds,
            likesCount: content.isLiked ? content.likesCount - 1 : content.likesCount + 1,
            commentsCount: content.commentsCount,
            createdAt: content.createdAt,
            isLiked: !content.isLiked,
          );
          learningContents[index] = updatedContent;
        }
      } else {
        print("Failed to toggle like: ${response.statusCode}");
      }
    } catch (e) {
      print("Error toggling like: $e");
    }
  }

  Future<void> fetchComments(String contentId) async {
    isCommentsLoading.value = true;
    comments.clear();
    try {
      final response = await _service.getComments(contentId);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        
        comments.value = data.map((json) => LearningCommentModel.fromJson(json)).toList();
      } else {
        print("Failed to fetch comments: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching comments: $e");
    } finally {
      isCommentsLoading.value = false;
    }
  }

  Future<bool> addComment(String contentId, String commentContent, {String? parentCommentId}) async {
    try {
      final response = await _service.addComment(contentId, commentContent, parentCommentId: parentCommentId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final dynamic commentJson = responseData['data'];
        
        if (commentJson != null) {
          final parsedComment = LearningCommentModel.fromJson(commentJson);
          String finalName = parsedComment.userName;
          String finalImage = parsedComment.userImage;
          
          if (finalName == 'Anonymous' || finalName.isEmpty) {
            try {
              final userCtrl = Get.find<FemaleUserDataController>();
              finalName = userCtrl.userName.value;
              finalImage = userCtrl.userProfileImage.value;
            } catch (_) {}
          }
          
          final newComment = LearningCommentModel(
            id: parsedComment.id,
            content: parsedComment.content,
            userName: finalName,
            userImage: finalImage,
            parentCommentId: parsedComment.parentCommentId,
            createdAt: parsedComment.createdAt,
            userId: parsedComment.userId.isNotEmpty ? parsedComment.userId : (Get.find<FemaleUserDataController>().userId.value),
          );
          comments.add(newComment);
        } else {
          String finalName = 'Me';
          String finalImage = '';
          String currentUid = '';
          try {
            final userCtrl = Get.find<FemaleUserDataController>();
            finalName = userCtrl.userName.value;
            finalImage = userCtrl.userProfileImage.value;
            currentUid = userCtrl.userId.value;
          } catch (_) {}

          final newComment = LearningCommentModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: commentContent,
            userName: finalName,
            userImage: finalImage,
            parentCommentId: parentCommentId,
            createdAt: DateTime.now(),
            userId: currentUid,
          );
          comments.add(newComment);
        }

        int index = learningContents.indexWhere((c) => c.id == contentId);
        if (index != -1) {
          final content = learningContents[index];
          final updatedContent = LearningContentModel(
            id: content.id,
            title: content.title,
            description: content.description,
            videoUrl: content.videoUrl,
            category: content.category,
            durationInSeconds: content.durationInSeconds,
            likesCount: content.likesCount,
            commentsCount: content.commentsCount + 1,
            createdAt: content.createdAt,
            isLiked: content.isLiked,
          );
          learningContents[index] = updatedContent;
        }
        return true;
      } else {
        print("Failed to add comment: ${response.statusCode}");
      }
    } catch (e) {
      print("Error adding comment: $e");
    }
    return false;
  }

  Future<bool> deleteComment(String commentId, String contentId) async {
    try {
      final response = await _service.deleteComment(commentId);
      if (response.statusCode == 200 || response.statusCode == 204) {
        final int toRemoveCount = comments.where((c) => c.id == commentId || c.parentCommentId == commentId).length;
        comments.removeWhere((c) => c.id == commentId || c.parentCommentId == commentId);

        int index = learningContents.indexWhere((c) => c.id == contentId);
        if (index != -1) {
          final content = learningContents[index];
          final updatedContent = LearningContentModel(
            id: content.id,
            title: content.title,
            description: content.description,
            videoUrl: content.videoUrl,
            category: content.category,
            durationInSeconds: content.durationInSeconds,
            likesCount: content.likesCount,
            commentsCount: (content.commentsCount - toRemoveCount).clamp(0, 999999),
            createdAt: content.createdAt,
            isLiked: content.isLiked,
          );
          learningContents[index] = updatedContent;
        }
        return true;
      }
    } catch (e) {
      print("Error deleting comment: $e");
    }
    return false;
  }
}
