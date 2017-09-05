library disks;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class DisksClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  DisksClient(this._client, this._backend, this.deleteSession);

  Future<String> insert(String org_id, String pool_id, String Name, int Size_gb, String Dir, String Description) async {
    // Create new instance of args
    var args = new DisksInsertArgs(org_id, pool_id, Name, Size_gb, Dir, Description);

    // Log event
    _client.ga?.sendEvent('disks', 'insert', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/disks',
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
    var reply = new DisksInsertReply.fromJson(JSON.decode(response.body));

    return reply.insert_id;
  }

  Future<List<Disk>> list(String org_id, String pool_id, List<String> disk_types) async {
    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/disks?disk_types=${disk_types.join(",")}');

    // Log event
    _client.ga?.sendEvent('disks', 'list', label: org_id);

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
    var listReply = new DisksListReply.fromJson(JSON.decode(response.body));

    return listReply.disks;
  }

  Future<Disk> retrieve(String org_id, String pool_id, String disk_id) async {
    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/disks/$disk_id');

    // Log event
    _client.ga?.sendEvent('disks', 'retrieve', label: org_id);

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
    var retrieveReply = new DisksRetrieveReply.fromJson(JSON.decode(response.body));

    return retrieveReply.disk;
  }

  Future update(String org_id, String pool_id, String disk_id, Disk disk) async {
    var response = await _client.put('$_backend/orgs/$org_id/pools/$pool_id/disks/$disk_id',
                                     headers: {"Content-type": "application/json"},
                                     body: JSON.encode(disk));

    // Log event
    _client.ga?.sendEvent('disks', 'update', label: org_id);

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

  Future delete(String org_id, String pool_id, String disk_id) async {
    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/disks/$disk_id');

    // Log event
    _client.ga?.sendEvent('disks', 'delete', label: org_id);

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

  Future<List<App>> apps(String org_id, String pool_id, String disk_id) async {
    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/disks/$disk_id/apps');

    // Log event
    _client.ga?.sendEvent('disks', 'apps', label: org_id);

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
    var retrieveReply = new DisksAppsReply.fromJson(JSON.decode(response.body));

    return retrieveReply.apps;
  }
}

