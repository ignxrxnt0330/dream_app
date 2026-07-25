import 'package:dream_app/infrastructure/auth/biometrics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BiometricsValidator extends StatefulWidget {
  static const urlName = 'BiometricsValidatorUrl';
  static const dialogName = 'BiometricsValidatorDialog';
  final String? obj;
  final String? redirUrl;
  final Widget? dialog;

  const BiometricsValidator({super.key, this.redirUrl, this.obj, this.dialog});

  @override
  State<BiometricsValidator> createState() => _BiometricsValidatorState();
}

class _BiometricsValidatorState extends State<BiometricsValidator> {
  @override
  void initState() {
    super.initState();
    checkBiometrics().then((bool allowed) {
      if (!allowed || !mounted) return;

      if (widget.runtimeType == String &&
          widget.redirUrl.runtimeType == String) {
        redirUrl(context, widget.obj!, widget.redirUrl!);
      } else if (widget.dialog != null) {
        context.pop();
        showDialog(context: context, builder: (context) => widget.dialog!);
      }
    });
  }

  Future<bool> checkBiometrics() async {
    return await Biometrics.authenticate();
  }

  bool redirUrl(BuildContext context, String obj, String redirUrl) {
    context.pushReplacement("/$obj/$redirUrl");
    return true;
  }

  bool redirDialog(BuildContext context, Widget dialog) {
    context.push("/bio_validate_dialog", extra: dialog);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
