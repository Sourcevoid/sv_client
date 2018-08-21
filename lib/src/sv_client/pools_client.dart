library pools;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class PoolsClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  PoolsClient(this._client, this._backend, this.deleteSession);

  Future<String> insert(String org_id, String name, int pool_type) async {
    // Create new instance of args
    var args = new PoolsInsertArgs(org_id, name, pool_type);

    // Log event
    _client.ga?.sendEvent('pools', 'insert', label: org_id);
 
    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/pools',
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
    var reply = new PoolsInsertReply.fromJson(json.decode(response.body));

    return reply.insert_id;
  }

  Future<List<Pool>> list(String org_id) async {
    // Log event
    _client.ga?.sendEvent('pools', 'list', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools');

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
    var listReply = new PoolsListReply.fromJson(json.decode(response.body));

    return listReply.pools;
  }

  Future<Pool> retrieve(String org_id, String pool_id) async {
    // Log event
    _client.ga?.sendEvent('pools', 'retrieve', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id');

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
    var retrieveReply = new PoolsRetrieveReply.fromJson(json.decode(response.body));

    return retrieveReply.pool;
  }

  Future update(String org_id, String pool_id, Pool pool) async {
    // Log event
    _client.ga?.sendEvent('pools', 'update', label: org_id);

    var response = await _client.put('$_backend/orgs/$org_id/pools/$pool_id',
                                     headers: {"Content-type": "application/json"},
                                     body: json.encode(pool));

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

  Future delete(String org_id, String pool_id) async {
    // Log event
    _client.ga?.sendEvent('pools', 'delete', label: org_id);

    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id');

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
}

