library sv_client;

import 'package:http/http.dart';
import 'package:usage/usage.dart';

import 'accounts_client.dart';
import 'orgs_client.dart';
import 'pools_client.dart';
import 'apps_client.dart';
import 'certs_client.dart';
import 'envs_client.dart';
import 'disks_client.dart';
import 'scms_client.dart';
import 'services_client.dart';
import 'service_users_client.dart';
import 'mongodb_databases_client.dart';
import 'mongodb_collections_client.dart';
import 'mongodb_documents_client.dart';
import 'mysql_databases_client.dart';
import 'mysql_tables_client.dart';
import 'postgresql_databases_client.dart';
import 'postgresql_tables_client.dart';

abstract class SvClient extends BaseClient {
  String rootUrl;
  String servicePath;
  String pool_id;

  // Sourcevoid specific headers
  String api_client;
  String user_agent;
  String session_token;

  // Google Analytics object
  Analytics ga;

  // Resource clients
  AccountsClient            get accounts            => new AccountsClient(this, '$rootUrl/$servicePath', getAccountId, getSessionId, saveSession, deleteSession);

  OrgsClient                get orgs                => new OrgsClient(this, '$rootUrl/$servicePath', deleteSession);

  PoolsClient               get pools               => new PoolsClient(this, '$rootUrl/$servicePath', deleteSession);

  AppsClient                get apps                => new AppsClient(this, '$rootUrl/$servicePath', deleteSession);

  CertsClient               get certs               => new CertsClient(this, '$rootUrl/$servicePath', deleteSession);

  EnvsClient                get envs                => new EnvsClient(this, '$rootUrl/$servicePath', deleteSession);

  DisksClient               get disks               => new DisksClient(this, '$rootUrl/$servicePath', deleteSession);

  ScmsClient                get scms                => new ScmsClient(this, '$rootUrl/$servicePath', deleteSession);

  ServicesClient            get services            => new ServicesClient(this, '$rootUrl/$servicePath', deleteSession);

  ServiceUsersClient        get serviceUsers        => new ServiceUsersClient(this, '$rootUrl/$servicePath', deleteSession);

  MongodbDatabasesClient    get mongodbDatabases    => new MongodbDatabasesClient(this, '$rootUrl/$servicePath', deleteSession);

  MongodbCollectionsClient  get mongodbCollections  => new MongodbCollectionsClient(this, '$rootUrl/$servicePath', deleteSession);

  MongodbDocumentsClient    get mongodbDocuments    => new MongodbDocumentsClient(this, '$rootUrl/$servicePath', deleteSession);

  MysqlDatabasesClient      get mysqlDatabases      => new MysqlDatabasesClient(this, '$rootUrl/$servicePath', deleteSession);

  MysqlTablesClient         get mysqlTables         => new MysqlTablesClient(this, '$rootUrl/$servicePath', deleteSession);

  PostgresqlDatabasesClient get postgresqlDatabases => new PostgresqlDatabasesClient(this, '$rootUrl/$servicePath', deleteSession);

  PostgresqlTablesClient    get postgresqlTables    => new PostgresqlTablesClient(this, '$rootUrl/$servicePath', deleteSession);

  // These functions is implemented differently by the browser and server clients
  String getAccountId() => '';
  String getSessionId() => '';
  String getSessionToken() => '';
  void saveSession(String session_id, String session_token) {}
  void deleteSession() {}
}

