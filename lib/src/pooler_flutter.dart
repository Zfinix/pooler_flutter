import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pooler_flutter/src/config/config.dart';
import 'package:pooler_flutter/src/utils/utils.dart';
import 'package:pooler_flutter/src/widgets/pooler_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PoolerCheckoutView extends StatefulWidget {
  /// Public Key from your https://docs.poolerapp.com
  final PoolerConfig config;

  /// Success callback
  final ValueChanged<dynamic>? onSuccess;

  /// Error callback
  final ValueChanged<dynamic>? onError;

  /// Thepeer popup Close callback
  final VoidCallback? onClosed;

  /// Error Widget will show if loading fails
  final Widget? errorWidget;

  /// Show [PoolerCheckoutView] Logs
  final bool showLogs;

  /// Toggle dismissible mode
  final bool isDismissible;

  const PoolerCheckoutView({
    super.key,
    required this.config,
    this.errorWidget,
    this.onSuccess,
    this.onClosed,
    this.onError,
    this.showLogs = false,
    this.isDismissible = true,
  });

  /// Show Dialog with a custom child
  Future<void> show(BuildContext context) => showModalBottomSheet<void>(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        isDismissible: isDismissible,
        enableDrag: isDismissible,
        context: context,
        isScrollControlled: true,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: context.screenHeight(.9),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Center(
                  child: PoolerCheckoutView(
                    config: config,
                    onClosed: onClosed,
                    onSuccess: onSuccess,
                    onError: onError,
                    showLogs: showLogs,
                    errorWidget: errorWidget,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  PoolerCheckoutViewState createState() => PoolerCheckoutViewState();
}

class PoolerCheckoutViewState extends State<PoolerCheckoutView> {
  final controller = WebViewController();

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    if (mounted) setState(() {});
  }

  bool _hasError = false;
  bool get hasError => _hasError;
  set hasError(bool val) {
    _hasError = val;
    if (mounted) setState(() {});
  }

  int? _loadingPercent;
  int? get loadingPercent => _loadingPercent;
  set loadingPercent(int? val) {
    _loadingPercent = val;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _handleInit();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConnectivityResult>(
      future: Connectivity().checkConnectivity(),
      builder: (context, snapshot) {
        /// Show error view
        if (hasError == true) {
          return Center(
            child: widget.errorWidget ?? const Text('An error occured'),
          );
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            if (isLoading == true) ...[
              const CupertinoActivityIndicator(),
            ],
            if (snapshot.hasData == true &&
                snapshot.data != ConnectivityResult.none) ...[
              const PoolerLoader()
            ],
            AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: isLoading == true && _loadingPercent != 100 ? 0 : 1,
              child: WebViewWidget(
                controller: controller,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Handle WebView initialization
  void _handleInit() async {
    PoolerLogger.showLogs = widget.showLogs;
    await _hideTextInput();
    controller
      ..loadHtmlString(
        PoolerFunctions.createWidgetHtml(
          config: widget.config,
        ),
      )
      ..enableZoom(false)
      ..addJavaScriptChannel(
        PoolerFunctions.eventHandler,
        onMessageReceived: (JavaScriptMessage data) {
          final rawData = data.message
              .removePrefix('"')
              .removeSuffix('"')
              .replaceAll(r'\', '');
          try {
            _handleResponse(rawData);
          } catch (e) {
            PoolerLogger.e(e);
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) async {
            isLoading = true;
          },
          onWebResourceError: (e) => PoolerLogger.e(e),
          onProgress: (v) => loadingPercent = v,
          onPageFinished: (_) async => isLoading = false,
          onNavigationRequest: (req) => NavigationDecision.navigate,
        ),
      )
      ..setUserAgent(USER_AGENT)
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  Future<void> _hideTextInput() async =>
      SystemChannels.textInput.invokeMethod<String>('TextInput.hide');

  void _handleResponse(String message) {
    try {
      PoolerLogger.log(message);
      final data = json.decode(message) as Map<String, dynamic>;
      final action = data['action'] as String? ?? '';
      switch (action) {
        case WIDGET_SUCCESS:
          if (widget.onSuccess != null) {
            widget.onSuccess!(data);
          }
          return;
        case WIDGET_CLOSE:
          if (mounted && widget.onClosed != null) widget.onClosed!();

          return;
        default:
          if (mounted && widget.onError != null) widget.onError!(data);
          return;
      }
    } catch (e) {
      PoolerLogger.e(e);
    }
  }
}
