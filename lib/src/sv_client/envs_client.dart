library envs;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class EnvsClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  EnvsClient(this._client, this._backend, this.deleteSession);

  Future<String> insert(String org_id,
      String pool_id,
      String app_id,
      NewEnv env) async {
    // Create new instance of args
    var args = new EnvsInsertArgs(org_id, pool_id, app_id, env);

    // Log event
    _client.ga?.sendEvent('envs', 'insert', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs',
        headers: {"Content-type": "application/json"},
        body: json.encode(args));

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    // Decode insert reply
    var reply = new EnvsInsertReply.fromJson(json.decode(response.body));

    return reply.insert_id;
  }

  Future<List<Env>> list(String org_id, String pool_id, String app_id) async {
    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs');

    // Log event
    _client.ga?.sendEvent('envs', 'list', label: org_id);
    
    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    // Decode list reply
    var listReply = new EnvsListReply.fromJson(json.decode(response.body));

    return listReply.envs;
  }

  Future<Env> retrieve(String org_id, String pool_id, String app_id, String env_id) async {
    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs/$env_id');

    // Log event
    _client.ga?.sendEvent('envs', 'retrieve', label: org_id);

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    // Decode list reply
    var retrieveReply = new EnvsRetrieveReply.fromJson(json.decode(response.body));

    return retrieveReply.env;
  }

  Future update(String org_id, String pool_id, String app_id, String env_id, Env env, {bool validate: true}) async {
    // Validate
    if(validate) {
      env.validate();
    }

    // Log event
    _client.ga?.sendEvent('envs', 'update', label: org_id);

    var response = await _client.put('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs/$env_id',
        headers: {"Content-type": "application/json"},
        body: json.encode(env));

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    return response.body;
  }

  Future delete(String org_id, String pool_id, String app_id, String env_id) async {
    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs/$env_id');

    // Log event
    _client.ga?.sendEvent('envs', 'delete', label: org_id);

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    return response.body;
  }

  Future enable(String org_id, String pool_id, String app_id, String env_id) async {
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs/$env_id/enable');

    // Log event
    _client.ga?.sendEvent('envs', 'enable', label: org_id);

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    return response.body;
  }

  Future disable(String org_id, String pool_id, String app_id, String env_id) async {
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs/$env_id/disable');

    // Log event
    _client.ga?.sendEvent('envs', 'disable', label: org_id);

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    return response.body;
  }

  Future primary(String org_id, String pool_id, String app_id, String env_id) async {
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs/$env_id/primary');

    // Log event
    _client.ga?.sendEvent('envs', 'primary', label: org_id);

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    return response.body;
  }

  Future console(String org_id, String pool_id, String app_id, String env_id, {int history = 120}) async {
    // NOTE: This function is a special case since Dart's built in websockets libraries is not cross platform. We
    // return the uri here and then create the dart:html specific websocket connect in the app. For CLI we can later
    // use the uri to create a dart:io websocket object.

    // Encode auth data into basic auth password value
//    var password = BASE64.encode(json.encode(authData).codeUnits);

    // Create websocket uri including basic auth password
//    var websocketUri = '$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs/$env_id/console'.replaceFirst('https://', 'wss://user:${password}@');
    var websocketUri = '$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs/$env_id/console'.replaceFirst('https://', 'wss://');

    // Create auth object
    var authData = new ConsoleConnectionData(this._client.api_client, this._client.getSessionToken(), this._client.user_agent, websocketUri, history: history);

    // Log event
    _client.ga?.sendEvent('envs', 'console', label: org_id);

    return authData;
  }

  Future attachMongodbDatabase(String org_id, String pool_id, String app_id, String env_id, String database_name) async {
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs/$env_id/mongodb/$database_name');

    // Log event
    _client.ga?.sendEvent('envs', 'attachMongodbDatabase', label: org_id);

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }
    return response.body;
  }

  Future detachMongodbDatabase(String org_id, String pool_id, String app_id, String env_id, String database_name) async {
    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs/$env_id/mongodb/$database_name');

    // Log event
    _client.ga?.sendEvent('envs', 'detachMongodbDatabase', label: org_id);

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    return response.body;
  }

  Future deployScm(String org_id, String pool_id, String app_id, String env_id) async {
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs/$env_id/deploy/scm');

    // Log event
    _client.ga?.sendEvent('envs', 'deployScm', label: org_id);

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    return response.body;
  }

  // NOTE: formData is only supported by HTML clients. It is a "FormData"
  // object only available in the browser. Other clients should use the
  // archive argument instead.
  Future deployArchive(String org_id, String pool_id, String app_id, String env_id, String scm_subtype, {Uint8List archive, browserRequest, browserFormData}) async {
    var response;
    var c = new Completer();

    // Log event
    _client.ga?.sendEvent('envs', 'deployArchive', label: org_id);

    if(archive != null) {
      // Encode archive binary data as base64
      var archiveBase64 = base64.encode(archive);

      // Make request
      response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/envs/$env_id/deploy/archive/$scm_subtype',
          headers: {"content-type": "application/octet-stream"},
          body: archiveBase64);

      // Handle response
      if(response.statusCode == 401) {
        // Log event
        _client.ga?.sendException(response.reasonPhrase);

        // Sign out stale session credentials and throw error
        deleteSession();
        throw(response.body);
      } else if(response.statusCode != 200) {
        // Log event
        _client.ga?.sendException(response.reasonPhrase);

        // Throw error that callee can choose how to handle
        throw(response.body);
      }

      return response.body;
    } else if(browserRequest != null && browserFormData != null) {
      // Handle browser upload (The FormData object enables streaming of the data,
      // without it some browser clients might crash when we load all data into
      // memory)

      // Build url
      var url = '$_backend/orgs/${org_id}/pools/${pool_id}/apps/${app_id}/envs/${env_id}/deploy/archive/${scm_subtype}';

      // Wait for request to complete, then return
      browserRequest.onReadyStateChange.listen((_) {
        // When the request has completed, check status
        if(browserRequest.readyState == 4) {
          // Check for errors and return response via Future
          if(browserRequest.status != 200) {
            c.completeError(browserRequest.responseText);
          } else {
            c.complete(browserRequest.responseText);
          }
        }
      });

      // Create POST request (put open as late as possible to make time for
      // progress bar alert to setup it's event listener before we call open()
      // on the request, progress events must be listen to before)
      browserRequest.open("POST", url);

      // Setup headers
      browserRequest.setRequestHeader("sv-api-client", "sourcevoid-browser-client/v1");
      browserRequest.setRequestHeader("sv-session-token", _client.getSessionToken());
      browserRequest.setRequestHeader("sv-user-agent", _client.user_agent);

      // Start stream archive data
      browserRequest.send(browserFormData);

      return c.future;
    } else {
      throw("Missing argument, either of the named arguments archive or formData must be provided");
    }
  }
}

