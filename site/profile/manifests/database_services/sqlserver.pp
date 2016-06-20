class profile::database_services::sqlserver {

  $db_hash     = hiera_hash('profile::database_services::sqlserver::db_hash')

  sqlserver_instance{'MSSQLSERVER':
    features                => ['SQL'],
    source                  => 'E:/',
    sql_sysadmin_accounts   => ['dbuser'],
  }
  sqlserver_features { 'Generic Features':
    source    => 'E:/',
    features  => ['ADV_SSMS', 'BC', 'Conn', 'SDK', 'SSMS'],
  }

  $db_hash.each |$key, $value| {
    sqlserver::database { $key:
      instance => 'MSSQLSERVER',
    }
    sqlserver::login{ "${key}_login":
      password => $value['password'],
    }

    sqlserver::user{ "${key}_user":
      user     => "${key}_user",
      database => $key,
      require  => Sqlserver::Login["${key}_login"],
    }
  }
}
