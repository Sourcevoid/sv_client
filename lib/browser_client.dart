library browser;

import 'dart:html';
import 'dart:async';

import 'package:http/http.dart';
import 'package:usage/usage.dart';
import 'package:http/browser_client.dart';

import 'src/sv_client/sv_client.dart';

class SvBrowserClient extends SvClient {
  // Setup correct http client implementation and user agent
  BrowserClient client = new BrowserClient();

  // Use localstorage to set and get token
  Storage localStorage = window.localStorage;

  // Google Analytics object
  Analytics ga;

  // API client version
  String api_client = 'sourcevoid-browser-client/v1';

  // User agent
  String user_agent = '';

  SvBrowserClient(String user_agent, {String rootUrl: "https://api.sourcevoid.com", String servicePath: "v1", this.ga}) {
    // Setup root url and service base path
    this.rootUrl = rootUrl;
    this.servicePath = servicePath;
    this.user_agent = user_agent;
  }

  Future<StreamedResponse> send(BaseRequest request) {
    // Setup headers
    request.headers['sv-api-client']    = api_client;
    request.headers['sv-session-token'] = getSessionToken();
    request.headers['sv-user-agent']    = user_agent;

    return client.send(request);
  }

  // Get account id from localstorage
  String getAccountId() {
    if(localStorage.containsKey('account_id')) {
      return localStorage['account_id'];
    } else {
      return 'no-account-id';
    }
  }

  // Get session id from localstorage
  String getSessionId() {
    // ####################################################################################
    // TODO: Remove later, kept for backwards compatibility, added 2017-02-11
    if(localStorage.keys.contains("dv-session-id") == true && localStorage.keys.contains("sv-session-id") == false) {
      localStorage["sv-session-id"] = localStorage["dv-session-id"];
    }
    // ####################################################################################

    if(localStorage.containsKey('sv-session-id')) {
      return localStorage['sv-session-id'];
    } else {
      return 'no-session';
    }
  }

  // Get session token from localstorage
  String getSessionToken() {
    // ####################################################################################
    // TODO: Remove later, kept for backwards compatibility, added 2017-02-11
    if(localStorage.keys.contains("dv-session-token") == true && localStorage.keys.contains("sv-session-token") == false) {
      localStorage["sv-session-token"] = localStorage["dv-session-token"];
    }
    // ####################################################################################

    if(localStorage.containsKey('sv-session-token')) {
      return localStorage['sv-session-token'];
    } else {
      return 'no-session';
    }
  }

  // Save token to localstorage
  void saveSession(String session_id, String session_token) {
    localStorage['sv-session-id'] = session_id;
    localStorage['sv-session-token'] = session_token;
  }

  // Clear session data from localstorage and redirect to login page
  void deleteSession() {
    localStorage.clear();
    window.location.href = "?#signin";
  }
}

