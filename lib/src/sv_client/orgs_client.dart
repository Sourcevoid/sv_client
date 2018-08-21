library orgs;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class OrgsClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  OrgsClient(this._client, this._backend, this.deleteSession);

  Future<String> insert(String name, bool personal, String country, String url, String description) async {
    // Create new instance of args
    var args = new OrgsInsertArgs(name, personal, country, url, description);

    // Log event
    _client.ga?.sendEvent('orgs', 'insert');

    // Make REST request
    var response = await _client.post('$_backend/orgs',
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
    var reply = new OrgsInsertReply.fromJson(json.decode(response.body));

    return reply.insert_id;
  }

  Future<Org> retrieve(String org_id) async {
    // Log event
    _client.ga?.sendEvent('orgs', 'retrieve', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id');

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
    var retrieveReply = new OrgsRetrieveReply.fromJson(json.decode(response.body));

    return retrieveReply.org;
  }

  Future update(String org_id, Org org) async {
    // Create new instance of args
    var args = new OrgsUpdateArgs(org_id, org);

    // Log event
    _client.ga?.sendEvent('orgs', 'update', label: org_id);

    var response = await _client.put('$_backend/orgs/$org_id',
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

  Future delete(String org_id) async {
    // Log event
    _client.ga?.sendEvent('orgs', 'delete', label: org_id);

    // Make REST request
    var response = await _client.delete('$_backend/orgs/$org_id');

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

  Future<String> enableBilling(String org_id, String email, String token, String client_ip) async {
    // Create new instance of args
    var args = new OrgsEnableBillingArgs(org_id, email, token, client_ip);

    // Log event
    _client.ga?.sendEvent('orgs', 'enableBilling', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/billing',
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

    // Decode enable reply
//    var reply = new BillingsEnableReply.fromJson(json.decode(response.body));

    return '';
  }

  Future<String> disableBilling(String org_id) async {
    // Log event
    _client.ga?.sendEvent('orgs', 'disableBilling', label: org_id);

    // Make REST request
    var response = await _client.delete('$_backend/orgs/$org_id/billing');

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
//    var reply = new BillingsDisableReply.fromJson(json.decode(response.body));

    return '';
  }

  Future<String> updateBilling(String org_id, String email, String token, String client_ip) async {
    // Create new instance of args
    var args = new OrgsUpdateBillingArgs(org_id, email, token, client_ip);

    // Log event
    _client.ga?.sendEvent('orgs', 'updateBilling', label: org_id);

    // Make REST request
    var response = await _client.put('$_backend/orgs/$org_id/billing',
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

    // Decode enable reply
//    var reply = new BillingsEnableReply.fromJson(json.decode(response.body));

    return '';
  }

  Future<String> updateSupportPlan(String org_id, int support_plan) async {
    // Log event
    _client.ga?.sendEvent('orgs', 'updateSupportPlan', label: org_id);

    var response = await _client.put('$_backend/orgs/$org_id/support/$support_plan');

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

    // Decode disable reply
//    var retrieveReply = new OrgsUpdateSupportPlanReply.fromJson(json.decode(response.body));

    return '';
  }

  Future<OrgUsage> usage(String org_id, DateTime from, DateTime to) async {
    // Create new instance of args
    var args = new OrgsUsageArgs(org_id, from, to);

    // Log event
    _client.ga?.sendEvent('orgs', 'usage', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/usage',
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
    var reply = new OrgsUsageReply.fromJson(json.decode(response.body));

    return reply.usage;
  }

  Future<int> creditsBalance(String org_id) async {
    // Log event
    _client.ga?.sendEvent('orgs', 'creditsBalance', label: org_id);

    // Make REST request
    var response = await _client.get('$_backend/orgs/$org_id/credits/balance');

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
    var reply = new OrgsCreditsBalanceReply.fromJson(json.decode(response.body));

    return reply.credits_in_usd_bp;
  }

  Future<List<Invoice>> invoices(String org_id) async {
    // Log event
    _client.ga?.sendEvent('orgs', 'invoices', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/invoices');

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
    var reply = new OrgsInvoicesReply.fromJson(json.decode(response.body));

    return reply.invoices;
  }

  Future<Invoice> invoice(String org_id, String invoice_id, String format) async {
    // Log event
    _client.ga?.sendEvent('orgs', 'invoice', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/invoices/$invoice_id/$format');

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
    var reply = new OrgsInvoiceReply.fromJson(json.decode(response.body));

    return reply.invoice;
  }

  Future<ResourceIds> rns(String org_id, String resource, String name) async {
    // Log event
    _client.ga?.sendEvent('orgs', 'rns', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/rns/${resource}/${name}');

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
    var retrieveReply = new OrgsRnsReply.fromJson(json.decode(response.body));

    return retrieveReply.ids;
  }
}

