import 'dart:async';
import 'package:flutter/material.dart';

/// HOW TO USE (since the blue FAB is removed):
/// -------------------------------------------
/// Place any icon/button in your UI and call:
///   GlobalVoiceAssistant.show(context);
/// To close programmatically:
///   GlobalVoiceAssistant.hide();
///
/// Example:
///   IconButton(
///     icon: const Icon(Icons.mic),
///     onPressed: () => GlobalVoiceAssistant.show(context),
///   );
class GlobalVoiceAssistant {
  static OverlayEntry? _entry;

  static void show(BuildContext context) {
    if (_entry != null) return;
    _entry = OverlayEntry(
      builder: (ctx) => _wrapInAppContext(
        context,
        _VoiceOverlay(onClose: hide),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

/// Ensure there’s always Directionality/Theme/Material for the overlay.
Widget _wrapInAppContext(BuildContext context, Widget child) {
  // Ensure we always provide Directionality + Theme + Material for the overlay.
  // Use `maybeOf` and fall back to sensible defaults when the caller context
  // does not provide them.
  final dir = Directionality.maybeOf(context) ?? TextDirection.ltr;
  final theme = Theme.of(context);

  return Directionality(
    textDirection: dir,
    child: Theme(
      data: theme,
      child: const Material(
        type: MaterialType.transparency,
        child: SizedBox.shrink(),
      ),
    ),
  ).wrapWith(child);
}

// Small helper extension to make it explicit we want to wrap the provided
// child with the built widgets. This keeps the builder code clear and avoids
// accidental mistakes with the local `ctx` that OverlayEntry gives.
extension on Widget {
  Widget wrapWith(Widget child) {
    return Builder(builder: (context) {
      // The previous Directionality/Theme/Material are already in the tree
      // above this Builder, so return the actual overlay content here.
      return child;
    });
  }
}

class _VoiceOverlay extends StatefulWidget {
  const _VoiceOverlay({required this.onClose});
  final VoidCallback onClose;

  @override
  State<_VoiceOverlay> createState() => _VoiceOverlayState();
}

class _VoiceOverlayState extends State<_VoiceOverlay> {
  bool _recording = false;
  String _status = "Tap Speak to start";
  String _transcript = "";
  Timer? _fakeTimer;

  @override
  void dispose() {
    _fakeTimer?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() {
      _recording = true;
      _status = "Listening…";
      _transcript = "";
    });
    // DEMO fake live transcript; replace with real mic + /transcribe.
    _fakeTimer?.cancel();
    _fakeTimer = Timer.periodic(const Duration(milliseconds: 700), (t) {
      if (!_recording) {
        t.cancel();
        return;
      }
      setState(() => _transcript += (_transcript.isEmpty ? "hello" : " world"));
    });
  }

  void _stop() {
    setState(() {
      _recording = false;
      _status = "Thinking…";
    });
    _fakeTimer?.cancel();
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _status = "Ask about courses or cricket scores!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dismissal background
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            child: Container(color: Colors.black54),
          ),
        ),

        // Bottom sheet
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            top: false,
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(blurRadius: 18, color: Colors.black26)
                ],
              ),
              constraints: const BoxConstraints(maxHeight: 460),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      const Icon(Icons.graphic_eq),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "Voice Assistant",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(Icons.close),
                        tooltip: "Close",
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Status
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _status,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Transcript (scrollable)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _transcript.isEmpty
                          ? const Center(
                              child: Text(
                                "Say something…",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Text(_transcript,
                                  style: const TextStyle(fontSize: 16)),
                            ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tips_and_updates, size: 18),
                          SizedBox(width: 6),
                          Text('Try: "What\'s my next class?"'),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _recording ? _stop : _start,
                        icon: Icon(_recording ? Icons.stop : Icons.mic),
                        label: Text(_recording ? "Stop" : "Speak"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
