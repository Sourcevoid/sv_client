library services;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';
import 'package:sv_models/rpc_models.dart';

class ServicesClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  ServicesClient(this._client, this._backend, this.deleteSession);

  Future<String> insert(String org_id, String pool_id, String service_type, String service_version, String description, String resource_name, int su) async {
    // Create new instance of args
    var args = new ServicesInsertArgs(org_id, pool_id, service_type, service_version, description, resource_name, su);

    // Log event
    _client.ga?.sendEvent('services', 'insert', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/services/$service_type/$su',
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
    var reply = new ServicesInsertReply.fromJson(json.decode(response.body));

    return reply.insert_id;
  }

  Future<List<Service>> list(String org_id, String pool_id, String service_type) async {
    // Log event
    _client.ga?.sendEvent('services', 'list', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/$service_type');

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
    var listReply = new ServicesListReply.fromJson(json.decode(response.body));

    return listReply.services;
  }

  Future<Service> retrieve(String org_id, String pool_id, String service_type, String service_id) async {
    // Log event
    _client.ga?.sendEvent('services', 'retrieve', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/$service_type/$service_id');

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
    var retrieveReply = new ServicesRetrieveReply.fromJson(json.decode(response.body));

    return retrieveReply.service;
  }

  Future update(String org_id, String pool_id, String service_type, String service_id, Service service) async {
    // Log event
    _client.ga?.sendEvent('services', 'update', label: org_id);

    var response = await _client.put('$_backend/orgs/$org_id/pools/$pool_id/services/$service_type/$service_id',
                                     headers: {"Content-type": "application/json"},
                                     body: json.encode(service));

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

  Future delete(String org_id, String pool_id, String service_type, String service_id) async {
    // Log event
    _client.ga?.sendEvent('services', 'delete', label: org_id);

    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/services/$service_type/$service_id');

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

