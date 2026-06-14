import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_community/shared/model/dua_model.dart';
import 'package:muslim_community/shared/service/dua_service.dart';

class DuaController extends GetxController {
  final DuaService _service = DuaService();
  final AudioPlayer audioPlayer = AudioPlayer();

  var isLoading = false.obs;
  var duas = <DuaModel>[].obs;
  var currentDua = Rxn<DuaModel>();
  
  // Audio state
  var isPlaying = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;
  var bufferedPosition = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDuas();
    
    // Listen to player state
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        audioPlayer.pause();
        audioPlayer.seek(Duration.zero);
      }
    });

    audioPlayer.durationStream.listen((d) {
      duration.value = d ?? Duration.zero;
    });

    audioPlayer.positionStream.listen((p) {
      position.value = p;
    });

    audioPlayer.bufferedPositionStream.listen((b) {
      bufferedPosition.value = b;
    });
  }

  Future<void> fetchDuas() async {
    isLoading.value = true;
    try {
      final response = await _service.getDuas();
      log("Full Dua Response: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          duas.assignAll((data['data'] as List)
              .map((json) => DuaModel.fromJson(json))
              .toList());
        }
      }
    } catch (e) {
      debugPrint("Error fetching duas: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void setDuaByWaqt(String waqt) async {
    // Try to find in existing list first
    final dua = duas.firstWhereOrNull((d) => d.waqt.toLowerCase() == waqt.toLowerCase());
    if (dua != null) {
      currentDua.value = dua;
      _initAudio(dua.audioUrl);
    } else {
      // If not found, fetch again (maybe it was added)
      await fetchDuas();
      final updatedDua = duas.firstWhereOrNull((d) => d.waqt.toLowerCase() == waqt.toLowerCase());
      currentDua.value = updatedDua;
      if (updatedDua != null) {
        _initAudio(updatedDua.audioUrl);
      }
    }
  }

  Future<void> _initAudio(String url) async {
    try {
      if (url.isNotEmpty) {
        await audioPlayer.setUrl(url);
      }
    } catch (e) {
      debugPrint("Error initializing audio: $e");
    }
  }

  void togglePlay() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  void seek(Duration pos) {
    audioPlayer.seek(pos);
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
