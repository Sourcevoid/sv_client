library apps;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class AppsClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  AppsClient(this._client, this._backend, this.deleteSession);

  Future<String> insert(String org_id, String pool_id, String name) async {
    // Create new instance of args
    var args = new AppsInsertArgs(org_id, pool_id, name);

    // Log event
    _client.ga?.sendEvent('apps', 'insert', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/apps',
                                      headers: {"Content-type": "application/json"},
                                      body: JSON.encode(args));

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
    var reply = new AppsInsertReply.fromJson(JSON.decode(response.body));

    return reply.insert_id;
  }

  Future<List<App>> list(String org_id, String pool_id) async {
    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/apps');

    // Log event
    _client.ga?.sendEvent('apps', 'list', label: org_id);

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
    var listReply = new AppsListReply.fromJson(JSON.decode(response.body));

    return listReply.apps;
  }

  Future<App> retrieve(String org_id, String pool_id, String app_id) async {
    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id');

    // Log event
    _client.ga?.sendEvent('apps', 'retrieve', label: org_id);

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
    var retrieveReply = new AppsRetrieveReply.fromJson(JSON.decode(response.body));

    return retrieveReply.app;
  }

  Future update(String org_id, String pool_id, String app_id, App app, {bool validate: true}) async {
    // Validate
    if(validate) {
      app.validate();
    }

    // Log event
    _client.ga?.sendEvent('apps', 'update', label: org_id);

    // Make request
    var response = await _client.put('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id',
                                     headers: {"Content-type": "application/json"},
                                     body: JSON.encode(app));

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

  Future delete(String org_id, String pool_id, String app_id) async {
    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id');

    // Log event
    _client.ga?.sendEvent('apps', 'delete', label: org_id);

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

  Future insertHook(String org_id, String pool_id, String app_id) async {
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/hooks');

    // Log event
    _client.ga?.sendEvent('apps', 'insertHook', label: org_id);

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

  Future deleteHook(String org_id, String pool_id, String app_id) async {
    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/hooks');

    // Log event
    _client.ga?.sendEvent('apps', 'deleteHook', label: org_id);

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

  Future verifyDomain(String org_id, String pool_id, String app_id) async {
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/verify/domain');

    // Log event
    _client.ga?.sendEvent('apps', 'verifyDomain', label: org_id);

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

    // Decode reply
    var retrieveReply = new AppsVerifyDomainReply.fromJson(JSON.decode(response.body));

    return retrieveReply;
  }

  Future attachDisk(String org_id, String pool_id, String app_id, String disk_id) async {
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/disks/$disk_id');

    // Log event
    _client.ga?.sendEvent('apps', 'attachDisk', label: org_id);

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

  Future detachDisk(String org_id, String pool_id, String app_id, String disk_id) async {
    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/apps/$app_id/disks/$disk_id');

    // Log event
    _client.ga?.sendEvent('apps', 'detachDisk', label: org_id);

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

  Future swapPaths(String org_id, String pool_id, String app_id, String path_prefix_x, String path_prefix_y) async {
    throw("swapPaths is not implemented");
  }
}

