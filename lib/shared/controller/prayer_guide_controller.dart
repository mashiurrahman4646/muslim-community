import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_community/shared/model/prayer_guide_model.dart';
import 'package:muslim_community/shared/service/prayer_guide_service.dart';

import '../../app_config.dart';

class PrayerGuideController extends GetxController {
  final PrayerGuideService _prayerGuideService = PrayerGuideService();
  final AudioPlayer audioPlayer = AudioPlayer();
  
  var isLoading = true.obs;
  var prayerGuideSteps = <PrayerGuideStep>[].obs;
  var errorMessage = ''.obs;
  var currentlyPlayingUrl = ''.obs;
  var isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to player state once to update playing status
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        audioPlayer.pause();
        audioPlayer.seek(Duration.zero);
      }
    });
  }
  
  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  Future<void> playAudio(String url) async {
    try {
      if (currentlyPlayingUrl.value == url) {
        if (audioPlayer.playing) {
          await audioPlayer.pause();
          isPlaying.value = false;
        } else {
          await audioPlayer.play();
          isPlaying.value = true;
        }
        return;
      }
      
      currentlyPlayingUrl.value = url;
      isPlaying.value = true;
      
      // Stop and reset the player before setting a new URL to ensure clean transitions
      if (audioPlayer.playing) {
        await audioPlayer.stop();
      }
      
      await audioPlayer.setUrl(
        url,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
        },
      );
      await audioPlayer.play();
      isPlaying.value = true;
    } catch (e) {
      print("Error playing audio: $e");
      currentlyPlayingUrl.value = '';
      isPlaying.value = false;
    }
  }

  void fetchPrayerGuide(String salahType) async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await _prayerGuideService.getPrayerGuide(salahType);
      
      print('=== API REQUEST: ${AppConfig.getNamazGuideEndpoint(salahType)} ===');
      print('=== API RESPONSE STATUS CODE: ${response.statusCode} ===');
      log('=== API RESPONSE BODY: ${response.body} ===');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final model = PrayerGuideResponse.fromJson(data);
          if (model.data != null) {
            prayerGuideSteps.value = model.data!;
          } else {
            errorMessage('No data available');
          }
        } else {
          errorMessage(data['message'] ?? 'Failed to load prayer guide');
        }
      } else {
        errorMessage('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('=== API EXCEPTION: $e ===');
      errorMessage('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
