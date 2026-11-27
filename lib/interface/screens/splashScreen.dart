import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

/// Launcher / splash screen shown while the app boots (checking session,
/// warming up providers, etc). Purely presentational — call your real
/// bootstrap logic inside [_bootstrap] and navigate on completion.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;

  // Brand gradient stops, dark teal -> bright aqua.
  static const _gradientColors = [
    Color(0xFF06A187),
    Color(0xFF19918E),
    Color(0xFF0FDED7),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // TODO: replace with real startup work — restoring session,
    // hydrating providers, checking auth token validity, etc.
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Diagonal brand gradient backdrop.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _gradientColors,
              ),
            ),
          ),

          // Soft decorative circles for depth, kept subtle and off to the
          // edges so they never compete with the logo.
          Positioned(
            top: -size.width * 0.28,
            right: -size.width * 0.22,
            child: _softCircle(size.width * 0.65),
          ),
          Positioned(
            bottom: -size.width * 0.35,
            left: -size.width * 0.3,
            child: _softCircle(size.width * 0.75),
          ),

          // Logo + brand name + tagline.
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoFade.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      Assets.brandLogoEnhanced,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.bolt_rounded,
                        size: 48,
                        color: Color(0xFF06A187),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _textFade,
                    child: Column(
                      children: const [
                        Text(
                          'MSys Mobilizer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Fast. Secure. Simple.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading indicator pinned near the bottom.
          Positioned(
            left: 0,
            right: 0,
            bottom: size.height * 0.08,
            child: FadeTransition(
              opacity: _textFade,
              child: const Center(
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.6,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _softCircle(double diameter) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.07),
      ),
    );
  }
}