import 'package:supabase_flutter/supabase_flutter.dart';
import '../../shared/models/music_model.dart';

class SupabaseService {
  // Using a getter to ensure we access the client after initialization
  SupabaseClient get _supabase => Supabase.instance.client;

  Future<List<MusicModel>> fetchSongs() async {
    try {
      final response = await _supabase.from('songs').select();
      return (response as List).map((json) => MusicModel.fromJson(json)).toList();
    } catch (e) {
      print('Supabase Fetch Error: $e');
      return [];
    }
  }
}
