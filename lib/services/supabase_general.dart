import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for interaction with Supabase.
class SupaBaseService {
  static final supabase = Supabase.instance.client;

  static Future<void> setup() async {
    // await Supabase.initialize(
    //   url: 'https://wmguavwdykudbvpuqigz.supabase.co',
    //   anonKey:
    //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtZ3VhdndkeWt1ZGJ2cHVxaWd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjM2ODQ1ODcsImV4cCI6MTk3OTI2MDU4N30.2Nv1-PoHB59o5gpdKEzS81FX9RyioD68Lsm7PlfBmBI',
    // );
    await Supabase.initialize(
      url: 'https://nejidlqgrybsoasntktn.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5lamlkbHFncnlic29hc250a3RuIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjU0NzY1MTksImV4cCI6MTk4MTA1MjUxOX0.MQITEEJffdhTrpoXQOVqp3eODnC308VymEg9MedA9QQ',
    );
  }
}
