import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../shared/models/music_model.dart';
import '../exceptions/app_exceptions.dart';
import 'logger_service.dart';

class SupabaseService {
  SupabaseClient get _supabase => Supabase.instance.client;
  final Connectivity _connectivity = Connectivity();

  Future<List<MusicModel>> fetchSongs() async {
    try {
      // 1. Check Connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        throw const NetworkException('No internet connection. Please check your network.');
      }

      // 2. Fetch Data
      final response = await _supabase
          .from('songs')
          .select()
          .timeout(const Duration(seconds: 15));

      return (response as List).map((json) => MusicModel.fromJson(json)).toList();
    } on PostgrestException catch (e, stack) {
      LoggerService.error('Supabase DB Error', e, stack);
      throw ServerException('Failed to fetch songs from server: ${e.message}', e.code);
    } on NetworkException {
      rethrow;
    } catch (e, stack) {
      LoggerService.error('Unexpected error in fetchSongs', e, stack);
      if (e.toString().contains('TimeoutException')) {
        throw const ServerException('Server request timed out. Please try again.');
      }
      throw UnknownException('An unexpected error occurred: $e');
    }
  }
}
