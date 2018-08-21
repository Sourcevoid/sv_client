library certs;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class CertsClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  CertsClient(this._client, this._backend, this.deleteSession);

  Future<String> insert(String org_id, String pool_id, String name, String description, String certificate, String private_key) async {
    // Create new instance of args
    var args = new CertsInsertArgs(org_id, pool_id, name, description, certificate, private_key);

    // Log event
    _client.ga?.sendEvent('certs', 'insert', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/certs',
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
    var reply = new CertsInsertReply.fromJson(json.decode(response.body));

    return reply.insert_id;
  }

  Future<List<Cert>> list(String org_id, String pool_id) async {
    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/certs');

    // Log event
    _client.ga?.sendEvent('certs', 'list', label: org_id);

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
    var listReply = new CertsListReply.fromJson(json.decode(response.body));

    return listReply.certs;
  }

  Future<Cert> retrieve(String org_id, String pool_id, String cert_id) async {
    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/certs/$cert_id');

    // Log event
    _client.ga?.sendEvent('certs', 'retrieve', label: org_id);

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
    var retrieveReply = new CertsRetrieveReply.fromJson(json.decode(response.body));

    return retrieveReply.cert;
  }

  Future update(String org_id, String pool_id, String cert_id, Cert cert) async {
    var response = await _client.put('$_backend/orgs/$org_id/pools/$pool_id/certs/$cert_id',
                                     headers: {"Content-type": "application/json"},
                                     body: json.encode(cert));

    // Log event
    _client.ga?.sendEvent('certs', 'update', label: org_id);

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

  Future delete(String org_id, String pool_id, String cert_id) async {
    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/certs/$cert_id');

    // Log event
    _client.ga?.sendEvent('certs', 'delete', label: org_id);

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

