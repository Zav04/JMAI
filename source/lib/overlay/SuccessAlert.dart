import 'dart:async';
import 'package:flutter/material.dart';

class SuccessAlert extends StatefulWidget {
  final String message;
  final VoidCallback onClose; // Callback para fechar o overlay

  SuccessAlert({Key? key, required this.message, required this.onClose})
      : super(key: key);

  @override
  _SuccessAlertState createState() => _SuccessAlertState();

  static void show(BuildContext context, String message) {
    late OverlayEntry overlayEntry;

    void closeOverlay() {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: SuccessAlert(
            message: message,
            onClose: closeOverlay,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }
}

class _SuccessAlertState extends State<SuccessAlert> {
  bool _isVisible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startDismissTimer();
  }

  void _startDismissTimer() {
    _timer = Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: _buildAlertContent(),
    );
  }

  Widget _buildAlertContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.green.shade100, // Cor de fundo verde para sucesso
        borderRadius: BorderRadius.circular(4.0),
        border:
            Border.all(color: Colors.green.shade600), // Borda verde mais escura
      ),
      child: IntrinsicWidth(
        child: Row(
          children: [
            Icon(Icons.check_circle,
                color: Colors.green.shade800), // Ícone de sucesso
            SizedBox(width: 8.0),
            Flexible(
              child: Text(
                widget.message,
                style: TextStyle(
                    color: Colors.green.shade800), // Texto verde escuro
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.0),
            IconButton(
              icon: Icon(Icons.close,
                  color: Colors.green.shade800), // Botão fechar verde
              onPressed: widget.onClose, // Usa o callback para fechar o overlay
            ),
          ],
        ),
      ),
    );
  }
}
