import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/app_export.dart';

class TermsPrivacyLinks extends StatelessWidget {
  final Function(String) onVoiceFeedback;

  const TermsPrivacyLinks({
    super.key,
    required this.onVoiceFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          'By creating an account, you agree to our ',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
        GestureDetector(
          onTap: () => _openWebView(
              context, 'Terms of Service', 'https://voicelearn.ai/terms'),
          child: Text(
            'Terms of Service',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Text(
          ' and ',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
        ),
        GestureDetector(
          onTap: () => _openWebView(
              context, 'Privacy Policy', 'https://voicelearn.ai/privacy'),
          child: Text(
            'Privacy Policy',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Text(
          '.',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  void _openWebView(BuildContext context, String title, String url) {
    onVoiceFeedback('Opening $title');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _WebViewScreen(
          title: title,
          url: url,
          onVoiceFeedback: onVoiceFeedback,
        ),
      ),
    );
  }
}

class _WebViewScreen extends StatefulWidget {
  final String title;
  final String url;
  final Function(String) onVoiceFeedback;

  const _WebViewScreen({
    required this.title,
    required this.url,
    required this.onVoiceFeedback,
  });

  @override
  State<_WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<_WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            widget.onVoiceFeedback('${widget.title} loaded successfully');
          },
          onWebResourceError: (WebResourceError error) {
            widget.onVoiceFeedback('Failed to load ${widget.title}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            widget.onVoiceFeedback('Going back to registration');
            Navigator.pop(context);
          },
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Loading ${widget.title}...',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
