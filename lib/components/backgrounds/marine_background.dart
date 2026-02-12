import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';

// --- Simulation Classes ---

class WaveLayer {
  final double amplitude;
  final double frequency;
  final double speed;
  final double phaseShift;
  final Color color;
  final double heightOffset;

  WaveLayer({
    required this.amplitude,
    required this.frequency,
    required this.speed,
    required this.phaseShift,
    required this.color,
    this.heightOffset = 0,
  });
}

class Particle {
  Offset position;
  Offset velocity;
  double life; // 0.0 to 1.0
  double size;

  Particle({
    required this.position,
    required this.velocity,
    this.life = 1.0,
    this.size = 2.0,
  });
}

class MarineBackground extends ConsumerStatefulWidget {
  const MarineBackground({super.key});

  @override
  ConsumerState<MarineBackground> createState() => _MarineBackgroundState();
}

class _MarineBackgroundState extends ConsumerState<MarineBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final math.Random _random = math.Random();

  // Simulation time accumulator
  double _time = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Tick driver
    );
    final enabled = ref.read(settingsControllerProvider).isWaveAnimationEnabled;
    if (enabled) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSimulation(double dt, bool isEnabled) {
    if (!isEnabled) return;

    // Update time
    _time += dt;

    // Update particles
    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.life -= dt * 0.5; // 2 seconds life
      p.position += p.velocity * (dt * 60); // Scale velocity
      p.velocity += const Offset(0, 0.05); // Gravity

      if (p.life <= 0 || p.position.dy > 1000) {
        // Cleanup
        _particles.removeAt(i);
      }
    }

    // Limit particle count
    if (_particles.length > 50) {
      _particles.removeRange(0, _particles.length - 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWaveAnimationEnabled = ref
        .watch(settingsControllerProvider)
        .isWaveAnimationEnabled;

    ref.listen<SettingsState>(settingsControllerProvider, (prev, next) {
      if (next.isWaveAnimationEnabled) {
        if (!_controller.isAnimating) {
          _controller.repeat();
        }
      } else {
        if (_controller.isAnimating) {
          _controller.stop();
        }
      }
    });

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Use controller value change to drive simulation step
        // In a real game loop we'd use Ticker directly, but this is fine for UI
        _updateSimulation(0.016, isWaveAnimationEnabled);

        return CustomPaint(
          painter: WavePainter(
            time: _time,
            particles: _particles,
            random: _random,
            onSpawnParticle: (pos) {
              if (isWaveAnimationEnabled && _particles.length < 50) {
                _particles.add(
                  Particle(
                    position: pos,
                    velocity: Offset(
                      (_random.nextDouble() - 0.5) * 1.5,
                      -(_random.nextDouble() * 2 + 1),
                    ),
                    size: _random.nextDouble() * 3 + 1,
                  ),
                );
              }
            },
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double time;
  final List<Particle> particles;
  final math.Random random;
  final Function(Offset) onSpawnParticle;

  WavePainter({
    required this.time,
    required this.particles,
    required this.random,
    required this.onSpawnParticle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Deep Ocean Gradient Background
    final Rect rect = Offset.zero & size;
    final Paint bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue[900]!, Colors.blue[800]!, Colors.blue[600]!],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // 2. Define Wave Layers (Back to Front)
    // Using a simplified superposition model
    final layers = [
      // Deep/Back Layer
      WaveLayer(
        amplitude: 25,
        frequency: 0.008,
        speed: 1.0,
        phaseShift: 0,
        color: Colors.white.withValues(alpha: 0.1),
        heightOffset: 120,
      ),
      // Mid Layer
      WaveLayer(
        amplitude: 20,
        frequency: 0.012,
        speed: 1.5,
        phaseShift: 2.0,
        color: Colors.white.withValues(alpha: 0.15),
        heightOffset: 90,
      ),
      // Front Layer
      WaveLayer(
        amplitude: 15,
        frequency: 0.015,
        speed: 2.0,
        phaseShift: 4.0,
        color: Colors.white.withValues(alpha: 0.2),
        heightOffset: 60,
      ),
    ];

    // 3. Draw Waves
    // LOD: Step size in pixels
    const double step = 4.0;

    for (int i = 0; i < layers.length; i++) {
      _drawWaveLayer(canvas, size, layers[i], step, i == layers.length - 1);
    }

    // 4. Draw Particles (Foam/Splash)
    // final particlePaint = Paint()..color = Colors.white.withValues(alpha: 0.6);
    // for (var p in particles) {
    //   particlePaint.color = Colors.white.withValues(alpha: 0.6 * p.life);
    //   canvas.drawCircle(p.position, p.size, particlePaint);
    // }
  }

  void _drawWaveLayer(
    Canvas canvas,
    Size size,
    WaveLayer layer,
    double step,
    bool isFrontLayer,
  ) {
    final path = Path();
    final paint = Paint()
      ..color = layer.color
      ..style = PaintingStyle.fill;

    // Base height for this layer (from bottom)
    final baseHeight = size.height - layer.heightOffset;

    path.moveTo(0, size.height);
    path.lineTo(0, baseHeight);

    double? lastY;

    for (double x = 0; x <= size.width; x += step) {
      // Calculate complex wave height
      // y = A * sin(kx + wt + phi)
      // Add randomness/modulation:
      // Modulate Amplitude: A' = A * (1 + 0.2*sin(t*0.5 + x*0.001))

      double modulation = 1.0 + 0.2 * math.sin(time * 0.5 + x * 0.005);

      // Main Wave
      double y =
          layer.amplitude *
          modulation *
          math.sin(x * layer.frequency + time * layer.speed + layer.phaseShift);

      // Secondary Detail Wave (Noise-like)
      y +=
          (layer.amplitude * 0.3) *
          math.sin(x * layer.frequency * 3 + time * layer.speed * 1.5);

      final currentY = baseHeight + y;
      path.lineTo(x, currentY);

      // Particle Spawning Logic (Only for front layer)
      if (isFrontLayer && lastY != null) {
        // Detect peak: slope changes from negative (going up visually - y decreases) to positive
        // Coordinate system: y increases downwards.
        // Peak means y is minimal (highest on screen).
        // Slope = dy/dx.
        // Peak: y(x) < y(x-1) and y(x) < y(x+1) approximately.
        // Or simple steepness check for splashing

        // Random splash on rising edges or peaks
        if (currentY < baseHeight - layer.amplitude * 0.8) {
          // High wave
          if (random.nextDouble() < 0.005) {
            // Rare chance
            onSpawnParticle(Offset(x, currentY));
          }
        }
      }

      lastY = currentY;
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return true; // Always repaint for animation
  }
}
