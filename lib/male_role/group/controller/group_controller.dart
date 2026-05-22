import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muslim_community/male_role/group/model/group_model.dart';
import 'package:muslim_community/male_role/group/model/group_post_model.dart';
import 'package:muslim_community/male_role/group/model/group_comment_model.dart';
import 'package:muslim_community/male_role/group/service/getallgroupservice.dart';
import 'package:muslim_community/services/tokenservice.dart';
import 'package:muslim_community/male_role/home/controller/userdatacontroller.dart';

class MaleGroupController extends GetxController {
  final MaleGetAllGroupService _groupService = MaleGetAllGroupService();
  final TokenService _tokenService = TokenService();
  final MaleUserDataController _userDataController = Get.isRegistered<MaleUserDataController>()
      ? Get.find<MaleUserDataController>()
      : Get.put(MaleUserDataController());
  
  var isLoading = false.obs;
  var isPostsLoading = false.obs;
  var isCommentsLoading = false.obs;
  
  var groups = <GroupModel>[].obs;
  var allGroups = <GroupModel>[];

  var currentGroup = Rxn<GroupModel>();
  var groupPosts = <GroupPostModel>[].obs;
  var postComments = <GroupCommentModel>[].obs;

  final postContentCtrl = TextEditingController();
  final commentContentCtrl = TextEditingController();
  var selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  var replyingToCommentId = "".obs;
  var replyingToUserName = "".obs;

  @override
  void onInit() {
    super.onInit();
    _initializeGroups();
  }

  Future<void> _initializeGroups() async {
    await _fetchGroupsInternal(setLoading: true);
  }

  Future<void> refreshGroups() async {
    await _fetchGroupsInternal(setLoading: false);
  }

  Future<void> _fetchGroupsInternal({required bool setLoading}) async {
    if (setLoading) isLoading.value = true;
    try {
      final token = await _tokenService.getToken();
      if (token == null) return;

      final role = _tokenService.getRoleFromToken(token);
      if (role == 'male') {
        final response = await _groupService.getAllGroups();
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final List<dynamic> data = responseData['data'] ?? [];

          final currentUserId = _userDataController.userId.value;

          allGroups = data
              .map((json) => GroupModel.fromJson(json, currentUserId: currentUserId))
              .where((g) => g.userType == "BROTHER")
              .toList();

          groups.value = allGroups;

          final currentId = currentGroup.value?.id;
          if (currentId != null && currentId.isNotEmpty) {
            currentGroup.value = groups.firstWhereOrNull((g) => g.id == currentId) ?? currentGroup.value;
          }
        }
      } else {
        print("Access Denied: Token role is $role, but trying to access Male Group Controller");
        groups.clear();
      }
    } catch (e) {
      print("Error initializing groups: $e");
    } finally {
      if (setLoading) isLoading.value = false;
    }
  }

  void updateInitialGroup(GroupModel initialGroup) {
    currentGroup.value = groups.firstWhereOrNull((g) => g.id == initialGroup.id) ?? initialGroup;
    fetchGroupPosts(initialGroup.id);
  }

  Future<void> fetchGroupPosts(String groupId) async {
    try {
      isPostsLoading.value = true;
      final response = await _groupService.getGroupPosts(groupId);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> postsData = responseData['data'] ?? [];
        
        groupPosts.value = postsData.map((json) => GroupPostModel.fromJson(json)).toList();
      } else {
        print("Failed to fetch posts: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching posts: $e");
    } finally {
      isPostsLoading.value = false;
    }
  }

  Future<void> fetchPostComments(String postId) async {
    try {
      isCommentsLoading.value = true;
      final response = await _groupService.getPostComments(postId);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> commentsData = responseData['data'] ?? [];
        postComments.value = commentsData.map((json) => GroupCommentModel.fromJson(json)).toList();
      }
    } catch (e) {
      print("Error fetching comments: $e");
    } finally {
      isCommentsLoading.value = false;
    }
  }

  Future<void> toggleJoin(String groupId) async {
    final index = groups.indexWhere((g) => g.id == groupId);
    if (index == -1) return;

    final g = groups[index];
    final wasJoined = g.isJoined;
    final desiredAfter = !wasJoined;

    try {
      isLoading.value = true;
      final response = wasJoined 
          ? await _groupService.leaveGroup(groupId)
          : await _groupService.joinGroup(groupId);

      final responseData = jsonDecode(response.body);
      final message = (responseData['message'] ?? "").toString().toLowerCase();

      bool success = response.statusCode == 200 || response.statusCode == 201;

      bool? serverIsMember;
      final dataVal = responseData['data'];
      if (dataVal is Map) {
        final v = dataVal['isMember'] ?? dataVal['isJoined'] ?? dataVal['joined'] ?? dataVal['is_member'] ?? dataVal['is_joined'];
        if (v != null) {
          serverIsMember = v == true || v.toString().toLowerCase() == 'true';
        }
      }

      bool isMemberAfter = serverIsMember ?? desiredAfter;

      if (message.contains('already') && message.contains('member')) {
        isMemberAfter = true;
        success = true;
      }
      if (message.contains('not') && message.contains('member')) {
        isMemberAfter = false;
        success = true;
      }

      if (success) {
        final memberCountAfter = isMemberAfter == wasJoined
            ? g.memberCount
            : isMemberAfter
                ? g.memberCount + 1
                : (g.memberCount - 1).clamp(0, 1 << 30).toInt();

        groups[index] = GroupModel(
          id: g.id,
          name: g.name,
          category: g.category,
          memberCount: memberCountAfter,
          description: g.description,
          isJoined: isMemberAfter,
          userType: g.userType,
          coverImage: g.coverImage,
          icon: g.icon,
        );
        if (currentGroup.value?.id == groupId) {
          currentGroup.value = groups[index];
        }
        
        String snackMsg;
        if (!wasJoined && isMemberAfter) {
          snackMsg = message.contains("already") ? "You are already a member" : "Joined group";
        } else if (wasJoined && !isMemberAfter) {
          snackMsg = message.contains("not") ? "You were not a member" : "Left group";
        } else if (wasJoined && isMemberAfter) {
          snackMsg = "Still a member";
        } else {
          snackMsg = "Not joined";
        }
        Get.snackbar("Success", snackMsg);

        await refreshGroups();
      } else {
        Get.snackbar("Error", responseData['message'] ?? "Failed to update group status");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinGroup(String groupId) => toggleJoin(groupId);
  Future<void> leaveGroup(String groupId) => toggleJoin(groupId);

  Future<void> createPost(String groupId) async {
    if (postContentCtrl.text.isEmpty) return;
    
    try {
      isLoading.value = true;
      final response = await _groupService.createGroupPost(
        groupId, 
        postContentCtrl.text,
        imagePaths: selectedImages.map((f) => f.path).toList(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        postContentCtrl.clear();
        selectedImages.clear();
        fetchGroupPosts(groupId);
        Get.snackbar("Success", "Post created successfully");
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar("Error", errorData['message'] ?? "Failed to create post");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> likePost(String postId) async {
    final index = groupPosts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final p = groupPosts[index];
    final wasLiked = p.isLiked;

    try {
      // Optimistic UI update
      groupPosts[index] = GroupPostModel(
        id: p.id,
        groupId: p.groupId,
        userId: p.userId,
        userName: p.userName,
        userImage: p.userImage,
        content: p.content,
        attachments: p.attachments,
        likesCount: wasLiked ? p.likesCount - 1 : p.likesCount + 1,
        commentsCount: p.commentsCount,
        isPinned: p.isPinned,
        isLiked: !wasLiked,
        createdAt: p.createdAt,
      );

      final response = await _groupService.likePost(postId);
      if (response.statusCode != 200 && response.statusCode != 201) {
        // Rollback on error
        groupPosts[index] = p;
        final errorData = jsonDecode(response.body);
        Get.snackbar("Error", errorData['message'] ?? "Failed to like post");
      }
    } catch (e) {
      groupPosts[index] = p;
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  Future<void> addComment(String postId) async {
    if (commentContentCtrl.text.isEmpty) return;

    try {
      final response = await _groupService.addPostComment(
        postId,
        commentContentCtrl.text,
        parentCommentId: replyingToCommentId.value.isEmpty ? null : replyingToCommentId.value,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        commentContentCtrl.clear();
        replyingToCommentId.value = "";
        replyingToUserName.value = "";
        
        // Refresh comments list
        await fetchPostComments(postId);
        
        // Manually update the comment count in the local list for immediate UI feedback
        final index = groupPosts.indexWhere((p) => p.id == postId);
        if (index != -1) {
          final p = groupPosts[index];
          groupPosts[index] = GroupPostModel(
            id: p.id,
            groupId: p.groupId,
            userId: p.userId,
            userName: p.userName,
            userImage: p.userImage,
            content: p.content,
            attachments: p.attachments,
            likesCount: p.likesCount,
            commentsCount: p.commentsCount + 1,
            isPinned: p.isPinned,
            isLiked: p.isLiked,
            createdAt: p.createdAt,
          );
          groupPosts.refresh();
        }
        
        Get.snackbar("Success", "Comment added successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      final response = await _groupService.deleteComment(commentId);
      if (response.statusCode == 200) {
        fetchPostComments(postId);
        // Update the comment count in the local list
        final index = groupPosts.indexWhere((p) => p.id == postId);
        if (index != -1) {
          final p = groupPosts[index];
          groupPosts[index] = GroupPostModel(
            id: p.id,
            groupId: p.groupId,
            userId: p.userId,
            userName: p.userName,
            userImage: p.userImage,
            content: p.content,
            attachments: p.attachments,
            likesCount: p.likesCount,
            commentsCount: (p.commentsCount - 1).clamp(0, 999999),
            isPinned: p.isPinned,
            isLiked: p.isLiked,
            createdAt: p.createdAt,
          );
          groupPosts.refresh();
        }
        Get.snackbar("Success", "Comment deleted successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  Future<void> deletePost(String groupId, String postId) async {
    try {
      isLoading.value = true;
      final response = await _groupService.deletePost(postId);
      if (response.statusCode == 200 || response.statusCode == 204) {
        groupPosts.removeWhere((p) => p.id == postId);
        Get.snackbar("Success", "Post deleted successfully");
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar("Error", errorData['message'] ?? "Failed to delete post");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void setReply(String commentId, String userName) {
    replyingToCommentId.value = commentId;
    replyingToUserName.value = userName;
  }

  void cancelReply() {
    replyingToCommentId.value = "";
    replyingToUserName.value = "";
  }

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.addAll(images.map((x) => File(x.path)));
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }
}
