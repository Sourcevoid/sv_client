library accounts;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class AccountsClient {
  String _backend;
  SvClient _client;

  // Function to save/delete token, implemented differently for client and server API clients
  var getAccountId;
  var getSessionId;
  var saveSession;
  var deleteSession;

  AccountsClient(this._client, this._backend, this.getAccountId, this.getSessionId, this.saveSession, this.deleteSession);

  Future<String> insert(String email, Utm utm) async {
    // Create new instance of args
    var args = new AccountsInsertArgs(email, utm);

    // Log event
    _client.ga?.sendEvent('accounts', 'insert');

    // Make REST request
    var response = await _client.post('$_backend/accounts',
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
    var reply = new AccountsInsertReply.fromJson(json.decode(response.body));

    return reply.insert_id;
  }

  Future<Account> verifyEmail(String email_token, String phone) async {
    var account = new Account();

    // Log event
    _client.ga?.sendEvent('accounts', 'verifyEmail', label: email_token);

    // Create new instance of args
    var args = new AccountsVerifyEmailArgs(email_token, phone);

    // Make REST request
    var response = await _client.post('$_backend/accounts/verify/email',
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

    // Decode reply
    var reply = new AccountsVerifyEmailReply.fromJson(json.decode(response.body));

    // Send back phone number (as saved in normalized format on the backend)
    account.phone = reply.phone;

    return account;
  }

  Future verifyPhone(String first_name, String last_name, String password, String email_token, String phone_code, bool news_letter) async {
    // Log event
    _client.ga?.sendEvent('accounts', 'verifyPhone', label: email_token);

    // Create new instance of args
    var args = new AccountsVerifyPhoneArgs(first_name, last_name, password, email_token, phone_code, news_letter);

    // Make REST request
    var response = await _client.post('$_backend/accounts/verify/phone',
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
    var reply = new AccountsVerifyPhoneReply.fromJson(json.decode(response.body));

    // Save session id and token
    saveSession(reply.session_id, reply.session_token);

    return;
  }

  Future<AccountsResetReply> reset(String email) async {
    // Create new instance of args
    var args = new AccountsResetArgs(email);

    // Log event
    _client.ga?.sendEvent('accounts', 'reset');

    // Make REST request
    var response = await _client.post('$_backend/accounts/reset',
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

    // Decode reply
    var reply = new AccountsResetReply.fromJson(json.decode(response.body));

    return reply;
  }

  Future<AccountsVerifyResetReply> verifyReset(String email, String reset_token, String password) async {
    // Create new instance of args
    var args = new AccountsVerifyResetArgs(email, reset_token, password);

    // Log event
    _client.ga?.sendEvent('accounts', 'verifyReset', label: reset_token);

    // Make REST request
    var response = await _client.post('$_backend/accounts/verify/reset',
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

    // Decode reply
    var reply = new AccountsVerifyResetReply.fromJson(json.decode(response.body));

    // Save session id and token
    saveSession(reply.session_id, reply.session_token);

    return reply;
  }

  Future<Account> retrieve() async {
    var response = await _client.get('$_backend/accounts');

    // Log event
    _client.ga?.sendEvent('accounts', 'retrieve');

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
    var retrieveReply = new AccountsRetrieveReply.fromJson(json.decode(response.body));

    return retrieveReply.account;
  }

  Future update(Account account) async {
    // Create new instance of args
    var args = new AccountsUpdateArgs(account);

    // Log event
    _client.ga?.sendEvent('accounts', 'update');

    var response = await _client.put('$_backend/accounts',
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

  Future delete() async {
    // Make REST request
    var response = await _client.delete('$_backend/accounts');

    // Log event
    _client.ga?.sendEvent('accounts', 'delete');

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

  Future signIn(String identifier, String password, String two_step_code, Duration ttl) async {
    // Create new instance of args
    var args = new AccountsSignInArgs(identifier, password, two_step_code, ttl);

    // Log event
    _client.ga?.sendEvent('accounts', 'signIn');

    // Make REST request
    var response = await _client.post('$_backend/accounts/signin',
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
    var reply = new AccountsSignInReply.fromJson(json.decode(response.body));

    // Save session id and token
    saveSession(reply.session_id, reply.session_token);

    return;
  }

  Future signOut([String session_id = ""]) async {
    // Create new instance of args
    var args = new AccountsSignOutArgs(session_id);

    // Log event
    _client.ga?.sendEvent('accounts', 'signOut');

    // Make REST request
    var response = await _client.post('$_backend/accounts/signout',
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

    // Delete session id and token if we signout from the current session
    if(session_id == "") {
      deleteSession();
    }

    return response.body;
  }

  Future<List<AuthSession>> sessions() async {
    var response = await _client.get('$_backend/accounts/sessions');

    // Log event
    _client.ga?.sendEvent('accounts', 'sessions');

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
    var retrieveReply = new AccountsSessionsReply.fromJson(json.decode(response.body));

    return retrieveReply.sessions;
  }

  Future<List<Operation>> operations(int limit, int skip) async {
    var response = await _client.get('$_backend/accounts/operations?limit=$limit&skip=$skip');

    // Log event
    _client.ga?.sendEvent('accounts', 'operations');

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
    var retrieveReply = new AccountsOperationsReply.fromJson(json.decode(response.body));

    return retrieveReply.operations;
  }

  Future<List<Org>> orgs() async {
    var response = await _client.get('$_backend/accounts/orgs');

    // Log event
    _client.ga?.sendEvent('accounts', 'orgs');

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
    var listReply = new AccountsOrgsReply.fromJson(json.decode(response.body));

    return listReply.orgs;
  }
}

