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

class MaleGroupController extends GetxController {
  final MaleGetAllGroupService _groupService = MaleGetAllGroupService();
  final TokenService _tokenService = TokenService();
  
  var isLoading = false.obs;
  var isPostsLoading = false.obs;
  var isCommentsLoading = false.obs;
  
  var groups = <GroupModel>[].obs;
  var allGroups = <GroupModel>[];

  var currentGroup = Rxn<GroupModel>();
  var groupPosts = <GroupPostModel>[
    GroupPostModel(
      id: "p1",
      groupId: "1",
      userId: "u1",
      userName: "Tariq M.",
      userImage: "",
      content: "Are we still meeting up this Friday near Regent's Park mosque?",
      attachments: [],
      likesCount: 8,
      commentsCount: 2,
      isPinned: false,
      isLiked: false,
      createdAt: "5h ago",
    ),
    GroupPostModel(
      id: "p2",
      groupId: "1",
      userId: "u2",
      userName: "Sarah J.",
      userImage: "",
      content: "Does anyone have recommendations for beginner tafsir books?",
      attachments: [],
      likesCount: 12,
      commentsCount: 5,
      isPinned: false,
      isLiked: true,
      createdAt: "1d ago",
    ),
  ].obs;

  var postComments = <GroupCommentModel>[
    GroupCommentModel(
      id: "c1",
      userId: "u3",
      userName: "Omar",
      userImage: "",
      content: "Yes, inshaAllah! I'll be there at 2 PM.",
      createdAt: "2h ago",
    ),
    GroupCommentModel(
      id: "c2",
      userId: "u4",
      userName: "Zaid",
      userImage: "",
      content: "Me too!",
      parentCommentId: "c1",
      createdAt: "1h ago",
    ),
  ].obs;

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

  void _initializeGroups() async {
    // Audit: Strictly only BROTHER groups from your real API response.
    // The previous ID "6a0e32cc3f039328ec6c127e" was actually a SISTER group,
    // which is why the API was giving the "only for sister" error.
    allGroups = [
      GroupModel(
        id: "6a0e327d3f039328ec6c122f",
        name: "Amra valo (Brothers)",
        description: "Valo chelera prem kore nah",
        userType: "BROTHER",
        category: "life lession",
        memberCount: 0,
        coverImage: "",
        isJoined: false,
        icon: Icons.favorite_outline,
      ),
    ];
    
    // REDUNDANT PRIVACY FILTER: Strictly enforce userType check at runtime
    groups.value = allGroups.where((g) => g.userType == "BROTHER").toList();
  }

  void updateInitialGroup(GroupModel initialGroup) {
    currentGroup.value = groups.firstWhereOrNull((g) => g.id == initialGroup.id) ?? initialGroup;
  }

  void fetchGroupPosts(String groupId) {
    // Already static
  }

  void fetchPostComments(String postId) {
    // Already static
  }

  Future<void> toggleJoin(String groupId) async {
    final index = groups.indexWhere((g) => g.id == groupId);
    if (index == -1) return;

    final g = groups[index];
    final wasJoined = g.isJoined;

    try {
      isLoading.value = true;
      final response = wasJoined 
          ? await _groupService.leaveGroup(groupId)
          : await _groupService.joinGroup(groupId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        groups[index] = GroupModel(
          id: g.id,
          name: g.name,
          category: g.category,
          memberCount: wasJoined ? g.memberCount - 1 : g.memberCount + 1,
          description: g.description,
          isJoined: !wasJoined,
          userType: g.userType,
          icon: g.icon,
        );
        if (currentGroup.value?.id == groupId) {
          currentGroup.value = groups[index];
        }
        Get.snackbar("Success", wasJoined ? "Left group" : "Joined group");
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar("Error", errorData['message'] ?? "Failed to update group status");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinGroup(String groupId) => toggleJoin(groupId);
  Future<void> leaveGroup(String groupId) => toggleJoin(groupId);

  void createPost(String groupId) {
    if (postContentCtrl.text.isEmpty) return;
    
    final newPost = GroupPostModel(
      id: DateTime.now().toString(),
      groupId: groupId,
      userId: "me",
      userName: "Ahmad (Me)",
      userImage: "",
      content: postContentCtrl.text,
      attachments: [],
      likesCount: 0,
      commentsCount: 0,
      isPinned: false,
      isLiked: false,
      createdAt: "Just now",
    );
    
    groupPosts.insert(0, newPost);
    postContentCtrl.clear();
    selectedImages.clear();
    Get.snackbar("Success", "Post created (Static Mode)");
  }

  void likePost(String postId) {
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
        likesCount: p.isLiked ? p.likesCount - 1 : p.likesCount + 1,
        commentsCount: p.commentsCount,
        isPinned: p.isPinned,
        isLiked: !p.isLiked,
        createdAt: p.createdAt,
      );
    }
  }

  void addComment(String postId) {
    if (commentContentCtrl.text.isEmpty) return;

    final newComment = GroupCommentModel(
      id: DateTime.now().toString(),
      userId: "me",
      userName: "Ahmad (Me)",
      userImage: "",
      content: commentContentCtrl.text,
      parentCommentId: replyingToCommentId.value.isEmpty ? null : replyingToCommentId.value,
      createdAt: "Just now",
    );

    postComments.add(newComment);
    
    // Update comment count on post
    final postIndex = groupPosts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      final p = groupPosts[postIndex];
      groupPosts[postIndex] = GroupPostModel(
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
    }

    commentContentCtrl.clear();
    cancelReply();
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

