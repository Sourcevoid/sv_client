library service_users_client;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class ServiceUsersClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  ServiceUsersClient(this._client, this._backend, this.deleteSession);

  Future<String> insert(String org_id, String pool_id, String service_type, String service_id, String username, String password, bool service_resource, String description) async {
    // Create new instance of args
    var args = new ServiceUsersInsertArgs(org_id, pool_id, service_id, service_type, username, password, service_resource, description);

    // Log event
    _client.ga?.sendEvent('serviceUsers', 'insert', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/services/$service_type/$service_id/users',
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
    var reply = new ServiceUsersInsertReply.fromJson(JSON.decode(response.body));

    return reply.insert_id;
  }

  Future<List<ServiceUser>> list(String org_id, String pool_id, String service_type, String service_id) async {
    // Log event
    _client.ga?.sendEvent('serviceUsers', 'list', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/$service_type/$service_id/users');

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
    var listReply = new ServiceUsersListReply.fromJson(JSON.decode(response.body));

    return listReply.service_users;
  }

  Future<ServiceUser> retrieve(String org_id, String pool_id, String service_type, String service_id, String service_username) async {
    // Log event
    _client.ga?.sendEvent('serviceUsers', 'retrieve', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/$service_type/$service_id/users/$service_username');

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
    var retrieveReply = new ServiceUsersRetrieveReply.fromJson(JSON.decode(response.body));

    return retrieveReply.service_user;
  }

  Future update(String org_id, String pool_id, String service_type, String service_id, String service_username, ServiceUser user) async {
    // Log event
    _client.ga?.sendEvent('serviceUsers', 'update', label: org_id);

    var response = await _client.put('$_backend/orgs/$org_id/pools/$pool_id/services/$service_type/$service_id/users/$service_username',
                                     headers: {"Content-type": "application/json"},
                                     body: JSON.encode(user));

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

  Future delete(String org_id, String pool_id, String service_type, String service_id, String service_username) async {
    // Log event
    _client.ga?.sendEvent('serviceUsers', 'delete', label: org_id);

    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/services/$service_type/$service_id/users/$service_username');

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

  Future reset(String org_id, String pool_id, String service_type, String service_id, String service_username) async {
    // Log event
    _client.ga?.sendEvent('serviceUsers', 'reset', label: org_id);

    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/services/$service_type/$service_id/users/$service_username/reset');

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

