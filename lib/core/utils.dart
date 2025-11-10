import 'package:supabase_flutter/supabase_flutter.dart';

String formatError(Object error) {
  if (error is PostgrestException) return error.message ?? 'DataBase Error';
  if (error is AuthException) return error.message ?? 'Authintication Error';
  if (error.toString().startsWith('Exception: ')) {
    return error.toString().replaceFirst('Exception: ', '');
  }
  return error.toString();
}

String formatTime(DateTime time) {
  return time.toLocal().toIso8601String().substring(0, 10);
}
