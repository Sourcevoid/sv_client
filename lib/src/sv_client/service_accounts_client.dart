library service_accounts;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class ServiceAccountsClient {
  String _backend;
  SvClient _client;

  // Function to save/delete token, implemented differently for client and server API clients
  var getAccountId;
  var getSessionId;
  var saveSession;
  var deleteSession;

  ServiceAccountsClient(this._client, this._backend, this.getAccountId, this.getSessionId, this.saveSession, this.deleteSession);

  Future<String> insert(String org_id, String name) async {
    // Create new instance of args
    var args = new ServiceAccountsInsertArgs(org_id, name);

    // Log event
    _client.ga?.sendEvent('serviceAccounts', 'insert');

    // Make REST request
    var response = await _client.post('$_backend/orgs/${org_id}/accounts',
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
    var reply = new ServiceAccountsInsertReply.fromJson(json.decode(response.body));

    return reply.insert_id;
  }

  Future<List<ServiceAccount>> list(String org_id) async {
    // Log event
    _client.ga?.sendEvent('serviceAccounts', 'list', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/accounts');

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
    var listReply = new ServiceAccountsListReply.fromJson(json.decode(response.body));

    return listReply.accounts;
  }

  Future<ServiceAccount> retrieve(String org_id, String service_account_id) async {
    var response = await _client.get('$_backend/orgs/${org_id}/accounts/${service_account_id}');

    // Log event
    _client.ga?.sendEvent('serviceAccounts', 'retrieve');

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
    var retrieveReply = new ServiceAccountsRetrieveReply.fromJson(json.decode(response.body));

    return retrieveReply.account;
  }

  Future update(String org_id, String service_account_id, ServiceAccount account) async {
    // Create new instance of args
    var args = new ServiceAccountsUpdateArgs(org_id, service_account_id, account);

    // Log event
    _client.ga?.sendEvent('serviceAccounts', 'update');

    var response = await _client.put('$_backend/orgs/${org_id}/accounts/${service_account_id}',
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

    return response.body;
  }

  Future delete(String org_id, String service_account_id) async {
    // Make REST request
    var response = await _client.delete('$_backend/orgs/${org_id}/accounts/${service_account_id}');

    // Log event
    _client.ga?.sendEvent('serviceAccounts', 'delete');

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

    // Delete session data after successful account deletion
    deleteSession();

    return response.body;
  }

  Future createAccountSession(String org_id, String service_account_id, Duration ttl) async {
    // Create new instance of args
    var args = new ServiceAccountsCreateSessionArgs(org_id, service_account_id, ttl);

    // Log event
    _client.ga?.sendEvent('serviceAccounts', 'createSession');

    // Make REST request
    var response = await _client.post('$_backend/orgs/${org_id}/accounts/${service_account_id}/session',
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
    var reply = new ServiceAccountsCreateSessionReply.fromJson(json.decode(response.body));

    // Save session id and token
    saveSession(reply.session_id, reply.session_token);

    return;
  }

  Future deleteAccountSession(String org_id, String service_account_id, String session_id) async {
    // Log event
    _client.ga?.sendEvent('serviceAccounts', 'deleteSession');

    // Make REST request
    var response = await _client.delete('$_backend/accounts/orgs/${org_id}/accounts/${service_account_id}/session/${session_id}',
        headers: {"Content-type": "application/json"});

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
  
  Future<List<Operation>> operations(String org_id, String service_account_id, int limit, int skip) async {
    var response = await _client.get('$_backend/accounts/orgs/${org_id}/accounts/${service_account_id}/operations?limit=$limit&skip=$skip');

    // Log event
    _client.ga?.sendEvent('serviceAccounts', 'operations');

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
    var retrieveReply = new ServiceAccountsOperationsReply.fromJson(json.decode(response.body));

    return retrieveReply.operations;
  }
}

