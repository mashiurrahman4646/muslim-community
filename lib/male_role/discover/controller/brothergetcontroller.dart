import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:muslim_community/male_role/discover/model/brother_model.dart';
import 'package:muslim_community/male_role/discover/service/brothergetservice.dart';
import 'package:muslim_community/male_role/home/controller/userdatacontroller.dart';
import 'package:muslim_community/services/socket_service.dart';

class BrotherGetController extends GetxController {
  final BrotherGetService _service = BrotherGetService();
  final MaleUserDataController _userCtrl = Get.find<MaleUserDataController>();
  final SocketService _socketService = SocketService();
  
  var isLoading = false.obs;
  var brothers = <BrotherModel>[].obs;
  var searchTerm = "".obs;
  var filter = "nearby-me".obs;
  var page = 1.obs;
  var hasMore = true.obs;
  var isFetchingMore = false.obs;

  // Pre-fetch location to have it ready
  double? _cachedLat;
  double? _cachedLng;

  Future<void> _preFetchLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 3),
      );
      _cachedLat = position.latitude;
      _cachedLng = position.longitude;
    } catch (e) {
      print("Pre-fetch location failed: $e");
    }
  }

  Future<void> fetchBrothers({bool isRefresh = false, bool isSilent = false}) async {
    if (isRefresh) {
      page.value = 1;
      hasMore.value = true;
      if (!isSilent) isLoading.value = true;
    } else {
      if (!hasMore.value || isFetchingMore.value) return;
      isFetchingMore.value = true;
    }
    
    try {
      double latitude = _cachedLat ?? 23.779999;
      double longitude = _cachedLng ?? 90.406693;
      
      // Only fetch if we don't have cached data or it's a refresh
      if (_cachedLat == null || isRefresh) {
        try {
          print("Fetching current position...");
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low, // Lower accuracy for faster results
            timeLimit: const Duration(seconds: 3), // Reduced timeout
          );
          latitude = position.latitude;
          longitude = position.longitude;
          _cachedLat = latitude;
          _cachedLng = longitude;
          print("Position fetched: $latitude, $longitude");
        } catch (e) {
          print("Geolocator failed in discover, using fallback/cached coordinates: $e");
        }
      }

      final response = await _service.getProfiles(
        latitude: latitude,
        longitude: longitude,
        searchTerm: searchTerm.value,
        filter: filter.value == 'nearby-me' ? '' : filter.value, // Empty filter for all users
        page: page.value,
        limit: 10,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> profilesData = responseData['data'] ?? [];
        
        if (profilesData.isEmpty) {
          hasMore.value = false;
          if (isRefresh) {
            brothers.clear();
          }
        } else {
          final fetchedBrothers = profilesData.map((json) {
            final int age = json['age'] ?? 30;
            String joinedAgo = 'New Revert';
            if (json['revertDate'] != null) {
              try {
                final DateTime revertDate = DateTime.parse(json['revertDate']);
                final int differenceInDays = DateTime.now().difference(revertDate).inDays;
                if (differenceInDays > 365) {
                  joinedAgo = '${(differenceInDays / 365).floor()} years ago';
                } else if (differenceInDays > 30) {
                  joinedAgo = '${(differenceInDays / 30).floor()} months ago';
                } else {
                  joinedAgo = '$differenceInDays days ago';
                }
              } catch (e) {
                joinedAgo = 'New Revert';
              }
            }
            
            String mappedStatus = 'Connect';
            
            final connection = json['connection'] ?? json['connectionData'];
            final String rawStatus = (json['connectionStatus'] ??
                    json['status'] ??
                    (connection is Map ? (connection['status'] ?? connection['connectionStatus']) : null) ??
                    '')
                .toString()
                .toLowerCase();
            final String rawDirection =
                (connection is Map ? connection['direction'] : null)?.toString().toLowerCase() ?? '';
            
            // SENDER ID extraction
            final senderId = connection != null 
                ? (connection['sender'] is Map ? connection['sender']['_id'] ?? connection['sender']['id'] : connection['sender']) ??
                  (connection['requester'] is Map ? connection['requester']['_id'] ?? connection['requester']['id'] : connection['requester'])
                : null;

            final currentUserId = _userCtrl.userId.value;

            if (rawStatus == 'received' || rawStatus == 'incoming') {
              mappedStatus = 'Received';
            } else if (rawStatus == 'pending' || rawStatus == 'requested' || rawStatus == 'sent') {
              if (rawDirection == 'incoming') {
                mappedStatus = 'Received';
              } else if (rawDirection == 'outgoing') {
                mappedStatus = 'Requested';
              } else if (senderId != null &&
                  currentUserId.isNotEmpty &&
                  senderId.toString() != currentUserId.toString()) {
                mappedStatus = 'Received';
              } else {
                mappedStatus = 'Requested';
              }
            } else if (rawStatus == 'accepted' || rawStatus == 'connected' || rawStatus == 'friends') {
              mappedStatus = 'Connected';
            } else if (rawStatus == 'rejected' || rawStatus == 'rejected_by_receiver' || rawStatus == 'rejected_by_sender') {
              mappedStatus = 'Connect';
            }

            return BrotherModel(
              id: (json['_id'] ?? json['id'] ?? '').toString(),
              connectionId: (connection != null ? (connection['_id'] ?? connection['id']) : json['connectionId'])?.toString(),
              name: json['name'] ?? 'Unknown',
              age: age,
              joinedAgo: joinedAgo,
              distance: json['distanceInKm'] != null 
                  ? double.parse((json['distanceInKm'] as double).toStringAsFixed(1)) 
                  : 0.0,
              status: mappedStatus,
              isVerified: json['isVerified'] ?? false,
              isOnline: false,
              isNewRevert: filter.value == 'new-reverts',
              imageUrl: json['profileImage'] ?? '',
              about: json['about'] ?? 'No information provided yet.',
              revertHistory: json['revertHistory'] ?? 'No revert history provided yet.',
              interests: json['interests'] != null ? List<String>.from(json['interests']) : [],
            );
          }).toList();

          if (isRefresh) {
            // Check for changes before assigning to avoid UI flicker
            if (brothers.length != fetchedBrothers.length) {
              brothers.assignAll(fetchedBrothers);
            } else {
               brothers.assignAll(fetchedBrothers);
            }
          } else {
            // Prevent duplicates when loading more
            for (var newBrother in fetchedBrothers) {
              if (!brothers.any((b) => b.id == newBrother.id)) {
                brothers.add(newBrother);
              }
            }
          }
          page.value++;
        }
      } else {
        print("Failed to fetch brothers. Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching brothers in controller: $e");
    } finally {
      if (!isSilent) isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _preFetchLocation();
    fetchBrothers(isRefresh: true);
    _setupSocketListeners();
  }

  @override
  void onClose() {
    _removeSocketListeners();
    super.onClose();
  }

  void _setupSocketListeners() async {
    // Background update via Sockets (Real-time & Battery efficient)
    try {
      if (!_socketService.isConnected) {
        await _socketService.connect();
      }
      
      // Listen for global data updates
      _socketService.on('UPDATE_DISCOVERY', (data) {
        print("SOCKET_DEBUG: Discovery update received for brothers");
        if (!isLoading.value && !isFetchingMore.value && searchTerm.value.isEmpty) {
          fetchBrothers(isRefresh: true, isSilent: true);
        }
      });
      
      _socketService.on('NEW_BROTHER', (data) {
        print("SOCKET_DEBUG: New brother added, refreshing list");
        if (!isLoading.value && !isFetchingMore.value && searchTerm.value.isEmpty) {
          fetchBrothers(isRefresh: true, isSilent: true);
        }
      });
    } catch (e) {
      print("Error setting up socket listeners for brothers: $e");
    }
  }

  void _removeSocketListeners() {
    _socketService.off('UPDATE_DISCOVERY');
    _socketService.off('NEW_BROTHER');
  }

  void searchBrothers(String query) {
    searchTerm.value = query;
  }

  void changeFilter(String newFilter) {
    filter.value = newFilter;
    fetchBrothers(isRefresh: true);
  }

  void updateStatus(String id, String newStatus, {String? connectionId}) {
    int index = brothers.indexWhere((b) => b.id == id);
    if (index != -1) {
      brothers[index] = brothers[index].copyWith(
        status: newStatus,
        connectionId: connectionId ?? brothers[index].connectionId,
      );
      brothers.refresh(); // Force UI update
    }
  }
}
