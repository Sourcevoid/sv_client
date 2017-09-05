library scms;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class ScmsClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  ScmsClient(this._client, this._backend, this.deleteSession);

  // NOTE: This call hardcodes "client_redirect=true", this is because a ajax
  // call can't handle a redirect that the backend does on the default
  // "client_redirect=false". When using this function it's assumed that you
  // do the redirect client side so the user gets to "Redirect_uri".
  Future<String> providersConnect(String provider) async {
    // Log event
    _client.ga?.sendEvent('scms', 'providersConnect');

    var response = await _client.get('$_backend/accounts/scms/providers/$provider?client_redirect=true');

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
    var reply = new ScmsProviderConnectReply.fromJson(JSON.decode(response.body));

    return reply.redirect_uri;
  }

  // Test method, never used from users code as this endpoint is called by the scm's callback
//  Future _providersInsert(String provider) async {
//    var options;
//
//    // Build options for url (Sample data, is provided by provider live)
//    switch(provider) {
//      case "github":
//        options = 'code=xxxxxxxxxxxxxxxxxxxx&state=yyyyyyyyyyyyyyyyyyyyy';
//        break;
////      case "bitbucket":
////        options = '';
////        break;
////      case "gitlab":
////        options = '';
////        break;
//      default:
//        throw('Unsupported scm provider $provider');
//    }
//
//    // Make request
//    var response = await _client.get('$_backend/accounts/scms/callback/providers/$provider?$options');
//
//    // Check for errors
//    if(response.statusCode != 200) {
//      throw(response.body);
//    }
//
//    return response.body;
//  }

  Future<List<String>> providersList() async {
    // Log event
    _client.ga?.sendEvent('scms', 'providersList');

    var response = await _client.get('$_backend/accounts/scms/providers');

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
    var reply = new ScmsProviderListReply.fromJson(JSON.decode(response.body));

    return reply.providers;
  }

  Future providersDelete(String provider) async {
    // Log event
    _client.ga?.sendEvent('scms', 'providersDelete');

    var response = await _client.delete('$_backend/accounts/scms/providers/$provider');

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

  Future reposInsert(String provider, String repo_owner, String repo_name, bool private) async {
    // Log event
    _client.ga?.sendEvent('scms', 'reposInsert');

    var response = await _client.post('$_backend/accounts/scms/providers/$provider/repos/owner/$repo_owner/name/$repo_name?private=$private');

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

  Future<List<ScmRepo>> reposList(String provider, String repo_owner) async {
    // Log event
    _client.ga?.sendEvent('scms', 'reposList');

    var response = await _client.get('$_backend/accounts/scms/providers/$provider/repos/owner/$repo_owner');

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
    var reply = new ScmsReposListReply.fromJson(JSON.decode(response.body));

    return reply.repos;
  }

  Future<List<String>> repoBranchesList(String provider, String repo_owner, String repo_name) async {
    // Log event
    _client.ga?.sendEvent('scms', 'repoBranchesList');

    var response = await _client.get('$_backend/accounts/scms/providers/$provider/repos/owner/$repo_owner/name/$repo_name/branches');

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
    var reply = new ScmsRepoBranchesListReply.fromJson(JSON.decode(response.body));

    return reply.branches;
  }

  Future<List<String>> repoTagsList(String provider, String repo_owner, String repo_name) async {
    // Log event
    _client.ga?.sendEvent('scms', 'repoTagsList');

    var response = await _client.get('$_backend/accounts/scms/providers/$provider/repos/owner/$repo_owner/name/$repo_name/tags');

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
    var reply = new ScmsRepoTagsListReply.fromJson(JSON.decode(response.body));

    return reply.tags;
  }
}

