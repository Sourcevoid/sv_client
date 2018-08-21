library server;

import 'dart:io';
import 'dart:async';

import 'package:http/http.dart';
import 'package:path/path.dart' as path;
//import 'package:yaml/yaml.dart';

import 'src/sv_client/sv_client.dart';

class SvServerClient extends SvClient {
  // Setup correct http client implementation and user agent
  Client client = new Client();

  // API client version
  String api_client = 'sourcevoid-server-client/v1';

  // User agent
  String user_agent = '';

  // Cache variables
  var _configDirCache = '';

  SvServerClient({String rootUrl: "https://api.sourcevoid.com", String servicePath: "v1"}) {
    // Setup root url and service base path
    this.rootUrl = rootUrl;
    this.servicePath = servicePath;
    this.user_agent = 'Dart ${Platform.version}, ${Platform.localHostname}';
  }

  Future<StreamedResponse> send(BaseRequest request) {
    // Get token value
    var token = getSessionToken();

    // Set dummy value if empty to get passed check for present headers
    if(token == '') {
      token = 'no-token';
    }

    // Setup headers
    request.headers['sv-api-client']    = api_client;
    request.headers['sv-session-token'] = token;
    request.headers['sv-user-agent']    = user_agent;

    return client.send(request);
  }

  // Check if session exists
  bool get hasSession {
    if(getSessionId() == '') {
      return false;
    } else {
      return true;
    }
  }

  // Get account id with dart:io
  String getAccountId() => getConfig('account_id');

  // Get session id with dart:io
  String getSessionId() => getConfig('sv_session_id');

  // Get session token
  String getSessionToken() => getConfig('sv_session_token');

  // Save token token with dart:io
  void saveSession(String session_id, String session_token) {
    print("In saveSession: ${session_id} ${session_token}");

    setConfig('sv_session_id', session_id);
    setConfig('sv_session_token', session_token);
  }

  // Delete session id and token with dart:io
  void deleteSession() {
    // Delete files, ignore error if they don't exists
    try {
      new File('${_configDir}/sv_session_id').deleteSync();
      new File('${_configDir}/sv_session_token').deleteSync();
    } catch (e) {
      // Ignore error if files have already been deleted or don't exists
    }
  }

  // Set config value
  void setConfig(String filename, String value) {
    var file = new File(_keyValueDir + Platform.pathSeparator + filename);

    // Write to file
    file.writeAsStringSync(value, mode: FileMode.write, flush: true);
  }

  // Unset config value
  void unsetConfig(String filename) {
    var file = new File(_keyValueDir + Platform.pathSeparator + filename);

    // Extra security measure to avoid deleting any other files
    if(file.path.contains(Platform.pathSeparator + "key_value")) {
      // Remove file
      file.delete();
    }
  }

  // Check if value exists
  bool configValueExists(String filename) {
    var value = '';

    try {
      value = new File(_keyValueDir + Platform.pathSeparator + filename).readAsStringSync();
    } catch (e) {
      // Do nothing, it's not an error that the file don't exists
    }

    if(value == '') {
      return false;
    } else {
      return true;
    }
  }

  // Get config value
  String getConfig(String filename) {
    var value = '';

    try {
      value = new File(_keyValueDir + Platform.pathSeparator + filename).readAsStringSync().trim();
    } catch (e) {
      // Do nothing, it's not an error that the file don't exists
    }

    return value;
  }

  // List config values
  Map<String, String> listConfig() {
    var map = new Map<String, String>();

    try {
      var files = new Directory(_keyValueDir).listSync();

      for (var file in files) {
        if(file.statSync().type == FileSystemEntityType.file) {
          var key = path.basename(file.path);
          map[key] = getConfig(key);
        }
      }

    } catch (e) {
      // Do nothing, it's not an error that the file don't exists
    }

    return map;
  }

  // Clear config values
  void clearConfig() {
    try {
      var files = new Directory(_keyValueDir).listSync();

      for (var file in files) {
        if(file.statSync().type == FileSystemEntityType.file) {
          // Extra security measure to avoid deleting any other files
          if(file.path.contains(Platform.pathSeparator + "key_value")) {
            file.delete();
          }
        }
      }
    } catch (e) {
      // Do nothing, it's not an error that the file don't exists
    }
  }

  String get _configDir {
    if (_configDirCache != '') {
      return _configDirCache;
    }

    // Add base dir and .sv dir
    var svDirPath = _baseConfigDir + Platform.pathSeparator + ".sv";

    // Create sv directory if needed
    if(FileSystemEntity.isDirectorySync(svDirPath) == false) {
      new Directory(svDirPath).createSync(recursive: true);
      new Directory(svDirPath + Platform.pathSeparator + "key_value").createSync(recursive: true);

      // Add simple README.txt file
      new File(svDirPath + Platform.pathSeparator + "README.txt").writeAsStringSync("""
# About Sourcevoid .sv directory

This directory is used by Sourcevoid's CLI app "sv". Don't edit the files
inside this directory manually unless debugging the sv app.

""");
    }

    // Cache path
    _configDirCache = svDirPath;

    return svDirPath;
  }

  String get _keyValueDir => _configDir + Platform.pathSeparator + "key_value";

  String get _baseConfigDir {
    var base = '';

    // Use SV_HOME environmental variable if set
    if(Platform.environment.containsKey('SV_HOME')) {
      base = Platform.environment['SV_HOME'];
      return base;
    }

    // First prefer the HOME environmental variable
    if(Platform.environment.containsKey('HOME')) {
      base = Platform.environment['HOME'];
      return base;
    }

    // Detect windows home path if HOME is not set
    var drive = Platform.environment['HOMEDRIVE'];
    var path = Platform.environment['HOMEPATH'];

    // Try to build base from Windows env vars
    base = drive + path;

    // If drive or path is not set, use 'USERPROFILE' variable
    if (drive == "" || path == "") {
      base = Platform.environment['USERPROFILE'];
    }

    // Throw error if no value
    if (base == "") {
      throw('Error: Could not find home directory. Neither SV_HOME, HOME, HOMEDRIVE, HOMEPATH, and USERPROFILE are set.');
    }

    return base;
  }
}

