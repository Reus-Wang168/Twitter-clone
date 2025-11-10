import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitte_clone/features/auth/domain/services/user_session_service.dart';

class SplashPage extends StatefulWidget {
  final UserSessionService userSessionService;
  const SplashPage({super.key, required this.userSessionService});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: Implementar lógica de navegação
    _checkSession();
    super.initState();
  }

  Future<void> _checkSession() async {
    final isLoggedIn = await widget.userSessionService.isLoggedIn();
    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
