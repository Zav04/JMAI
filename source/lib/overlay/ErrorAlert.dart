import 'dart:async';
import 'package:flutter/material.dart';

class ErrorAlert extends StatefulWidget {
  final String message;
  final VoidCallback onClose;

  ErrorAlert({Key? key, required this.message, required this.onClose})
      : super(key: key);

  @override
  _ErrorAlertState createState() => _ErrorAlertState();

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
          child: ErrorAlert(
            message: message,
            onClose: closeOverlay,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }
}

class _ErrorAlertState extends State<ErrorAlert> {
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
        color: Colors.pink.shade100,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: IntrinsicWidth(
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8.0),
            Flexible(
              child: Text(
                widget.message,
                style: TextStyle(color: Colors.red.shade900),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.0),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red.shade900),
              onPressed: widget.onClose,
            ),
          ],
        ),
      ),
    );
  }
}
