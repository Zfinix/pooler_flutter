// ignore_for_file: constant_identifier_names

import 'package:pooler_flutter/src/config/config.dart';

const WIDGET_SUCCESS = 'widget.success';
const WIDGET_ERROR = 'widget.server_error';
const WIDGET_CLOSE = 'closeIframe';
const USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36';

class PoolerFunctions {
  static const eventHandler = 'JuicePaymentEventJSChannel';
  static String script =
      '<script src="https://js.poolerapp.com/v1/inline.js"></script>';

  static const WIDGET_FUNCTION = 'startPoolerPopup';

  /// `[JS]` Create EventListener config for message client
  static String get messageHandler => '''
      
      // Add EventListener for onMessage Event
      window.addEventListener('message', (event) => {
        sendMessage(event.data)
      });
      
      // Override default JS Console function
      console._log_old = console.log
      console.log = function(msg) {
          sendMessageRaw(msg);
          console._log_old(msg);
      }

      console._error_old = console.error
      console.error = function(msg) {
          sendMessageRaw(msg);
          console._error_old(msg);
      }
      
      // Send callback to dart JSMessageClient
      function sendMessage(message) {
          if (window.$eventHandler && window.$eventHandler.postMessage) {
              $eventHandler.postMessage(JSON.stringify(message));
          }
      } 

      // Send raw callback to dart JSMessageClient
      function sendMessageRaw(message) {
          if (window.$eventHandler && window.$eventHandler.postMessage) {
              $eventHandler.postMessage(message);
          }
      } 
''';

  /// `[JS]` Create EventListener config for message client
  static String createWidgetHtml({
    required PoolerConfig config,
  }) =>
      '''<!DOCTYPE html>
<html>

<head>
    <base href="/">

    <meta charset="UTF-8">
    <meta content="IE=Edge" http-equiv="X-UA-Compatible">
    <meta name="description" content="A Very Good new Flutter project.">

    <title>Juice</title>
    $script
</head>

  <body onload="$WIDGET_FUNCTION()">
  <script type="text/javascript">
  $messageHandler
  ${injectWidgetFunction(config: config)}
  </script>
  
  </body>

</html>''';

  /// `[JS]` Create EventListener config for message client
  static String injectWidgetFunction({
    required PoolerConfig config,
  }) =>
      '''
  window.onload = $WIDGET_FUNCTION;
  function $WIDGET_FUNCTION() {
      const developerConfig = {
         email: "${config.email}",
         amount: ${config.amount},
         pub_key: "${config.publicKey}",
         redirect_link: "${config.redirectLink}",
         transaction_reference: "${config.transactionReference}"
       };
       Pooler.Popup({ ...developerConfig });
  };
  ''';
}
