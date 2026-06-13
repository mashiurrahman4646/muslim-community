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
  
  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  Future<void> playAudio(String url) async {
    try {
      if (currentlyPlayingUrl.value == url && audioPlayer.playing) {
        await audioPlayer.pause();
        currentlyPlayingUrl.value = '';
        return;
      }
      
      currentlyPlayingUrl.value = url;
      await audioPlayer.setUrl(url);
      await audioPlayer.play();
      
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          currentlyPlayingUrl.value = '';
        }
      });
    } catch (e) {
      print("Error playing audio: $e");
      currentlyPlayingUrl.value = '';
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
