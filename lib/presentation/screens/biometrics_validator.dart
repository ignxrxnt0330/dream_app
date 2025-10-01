import 'package:dream_app/infrastructure/auth/biometrics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BiometricsValidator extends StatefulWidget {
  static const name = 'BiometricsValidatorScreen';
  final String obj;
  final String redirUrl;

  const BiometricsValidator(
      {super.key, required this.redirUrl, required this.obj});

  @override
  State<BiometricsValidator> createState() => _BiometricsValidatorState();
}

class _BiometricsValidatorState extends State<BiometricsValidator> {
  @override
  void initState() {
    super.initState();
    checkBiometrics(context);
  }

  void checkBiometrics(BuildContext context) async {
    bool allowed = await Biometrics.authenticate();
    if (!context.mounted) return;
    if (allowed) {
      context.pushReplacement("/${widget.obj}/${widget.redirUrl}");
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
