Feature: Merge array values into wp-config.php

  Scenario: Test merge with array values
    Given a WP install
    And a basic-wp-config.php file:
      """
      <?php
      define( 'DB_NAME', 'wordpress' );
      define( 'WP_DEBUG', false );
      $table_prefix = 'wp_';

      /* Add any custom values between this line and the "stop editing" line. */

      /* That's all, stop editing! Happy publishing. */

      /** Absolute path to the WordPress directory. */
      if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
      }

      /** Sets up WordPress vars and included files. */
      require_once ABSPATH . 'wp-settings.php';
      """
    And a wp-config-array-values.json file:
      """
      [
        {
          "name": "WP_DEBUG_LOG",
          "value": true,
          "type": "constant"
        },
        {
          "name": "WP_REDIS_SERVERS",
          "value": [["127.0.0.1", 6379], ["10.0.0.1", 6379]],
          "type": "constant"
        },
        {
          "name": "WP_ALLOWED_HOSTS",
          "value": ["example.com", "www.example.com", "*.example.com"],
          "type": "constant"
        },
        {
          "name": "custom_settings",
          "value": {"debug": true, "cache": {"enabled": true, "ttl": 3600}},
          "type": "variable"
        }
      ]
      """
    And copy the basic-wp-config.php file to wp-config.php

    When I run `cat wp-config-array-values.json | wp solid backups merge-wp-config`
    Then STDOUT should contain:
      """
      Success: Successfully saved config values: WP_DEBUG_LOG, WP_REDIS_SERVERS, WP_ALLOWED_HOSTS, custom_settings.
      """
    And the wp-config.php file should contain:
      """
      define( 'WP_DEBUG_LOG', true );
      """
    And the wp-config.php file should contain:
      """
      define( 'WP_REDIS_SERVERS', array (
        0 => 
        array (
          0 => '127.0.0.1',
          1 => 6379,
        ),
        1 => 
        array (
          0 => '10.0.0.1',
          1 => 6379,
        ),
      ) );
      """
    And the wp-config.php file should contain:
      """
      define( 'WP_ALLOWED_HOSTS', array (
        0 => 'example.com',
        1 => 'www.example.com',
        2 => '*.example.com',
      ) );
      """
    And the wp-config.php file should contain:
      """
      $custom_settings = array (
        'debug' => true,
        'cache' => 
        array (
          'enabled' => true,
          'ttl' => 3600,
        ),
      );
      """
    
    When I run `wp config get WP_DEBUG_LOG --format=json`
    Then STDOUT should be:
      """
      true
      """
      
    When I run `wp config get WP_REDIS_SERVERS --format=json`
    Then STDOUT should be JSON containing:
      """
      [
        [
          "127.0.0.1",
          6379
        ],
        [
          "10.0.0.1",
          6379
        ]
      ]
      """
      
    When I run `wp config get WP_ALLOWED_HOSTS --format=json`
    Then STDOUT should be JSON containing:
      """
      [
        "example.com",
        "www.example.com",
        "*.example.com"
      ]
      """
      
    When I run `wp config get custom_settings --format=json`
    Then STDOUT should be JSON containing:
      """
      {
        "debug": true,
        "cache": {
          "enabled": true,
          "ttl": 3600
        }
      }
      """

  Scenario: Test merge with associative arrays
    Given a WP install
    And a minimal-wp-config.php file:
      """
      <?php
      define( 'DB_NAME', 'wordpress' );

      /* Add any custom values between this line and the "stop editing" line. */

      /* That's all, stop editing! Happy publishing. */

      /** Absolute path to the WordPress directory. */
      if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
      }

      /** Sets up WordPress vars and included files. */
      require_once ABSPATH . 'wp-settings.php';
      """
    And a wp-config-assoc-arrays.json file:
      """
      [
        {
          "name": "WP_ENVIRONMENT_TYPES",
          "value": ["local", "development", "staging", "production"],
          "type": "constant"
        },
        {
          "name": "WP_CACHE_CONFIG",
          "value": {
            "enabled": true,
            "timeout": 3600,
            "servers": {
              "main": "redis-main.local",
              "fallback": "redis-fallback.local"
            }
          },
          "type": "constant"
        },
        {
          "name": "db_settings",
          "value": {
            "master": {
              "host": "master-db.local",
              "user": "master_user",
              "password": "master_pass"
            },
            "slave": {
              "host": "slave-db.local",
              "user": "slave_user",
              "password": "slave_pass"
            }
          },
          "type": "variable"
        }
      ]
      """
    And copy the minimal-wp-config.php file to wp-config.php

    When I run `cat wp-config-assoc-arrays.json | wp solid backups merge-wp-config`
    Then STDOUT should contain:
      """
      Success: Successfully saved config values: WP_ENVIRONMENT_TYPES, WP_CACHE_CONFIG, db_settings.
      """
    And the wp-config.php file should contain:
      """
      define( 'WP_ENVIRONMENT_TYPES', array (
        0 => 'local',
        1 => 'development',
        2 => 'staging',
        3 => 'production',
      ) );
      """
    And the wp-config.php file should contain:
      """
      define( 'WP_CACHE_CONFIG', array (
        'enabled' => true,
        'timeout' => 3600,
        'servers' => 
        array (
          'main' => 'redis-main.local',
          'fallback' => 'redis-fallback.local',
        ),
      ) );
      """
    And the wp-config.php file should contain:
      """
      $db_settings = array (
        'master' => 
        array (
          'host' => 'master-db.local',
          'user' => 'master_user',
          'password' => 'master_pass',
        ),
        'slave' => 
        array (
          'host' => 'slave-db.local',
          'user' => 'slave_user',
          'password' => 'slave_pass',
        ),
      );
      """
    
    When I run `wp config get WP_ENVIRONMENT_TYPES --format=json`
    Then STDOUT should be JSON containing:
      """
      [
        "local",
        "development",
        "staging",
        "production"
      ]
      """
      
    When I run `wp config get WP_CACHE_CONFIG --format=json`
    Then STDOUT should be JSON containing:
      """
      {
        "enabled": true,
        "timeout": 3600,
        "servers": {
          "main": "redis-main.local",
          "fallback": "redis-fallback.local"
        }
      }
      """
      
    When I run `wp config get db_settings --format=json`
    Then STDOUT should be JSON containing:
      """
      {
        "master": {
          "host": "master-db.local",
          "user": "master_user",
          "password": "master_pass"
        },
        "slave": {
          "host": "slave-db.local",
          "user": "slave_user",
          "password": "slave_pass"
        }
      }
      """

  Scenario: Test merge with deeply nested arrays
    Given a WP install
    And a empty-wp-config.php file:
      """
      <?php
      // Empty config

      /* Add any custom values between this line and the "stop editing" line. */

      /* That's all, stop editing! Happy publishing. */

      /** Absolute path to the WordPress directory. */
      if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
      }

      /** Sets up WordPress vars and included files. */
      require_once ABSPATH . 'wp-settings.php';
      """
    And a wp-config-nested-arrays.json file:
      """
      [
        {
          "name": "SITE_CONFIG",
          "value": {
            "sites": {
              "main": {
                "domain": "example.com",
                "settings": {
                  "theme": "twentytwentyone",
                  "plugins": ["seo", "security", "cache"],
                  "options": {
                    "comments": true,
                    "registration": false,
                    "performance": {
                      "optimize_images": true,
                      "minify": {
                        "css": true,
                        "js": true,
                        "html": false
                      }
                    }
                  }
                }
              },
              "staging": {
                "domain": "staging.example.com",
                "settings": {
                  "theme": "twentytwentyone",
                  "plugins": ["seo", "security"],
                  "options": {
                    "comments": false,
                    "registration": false
                  }
                }
              }
            }
          },
          "type": "constant"
        }
      ]
      """
    And copy the empty-wp-config.php file to wp-config.php

    When I run `cat wp-config-nested-arrays.json | wp solid backups merge-wp-config`
    Then STDOUT should contain:
      """
      Success: Successfully saved config values: SITE_CONFIG.
      """
    And the wp-config.php file should contain:
      """
      define( 'SITE_CONFIG', array (
        'sites' => 
        array (
          'main' => 
          array (
            'domain' => 'example.com',
            'settings' => 
            array (
              'theme' => 'twentytwentyone',
              'plugins' => 
              array (
                0 => 'seo',
                1 => 'security',
                2 => 'cache',
              ),
              'options' => 
              array (
                'comments' => true,
                'registration' => false,
                'performance' => 
                array (
                  'optimize_images' => true,
                  'minify' => 
                  array (
                    'css' => true,
                    'js' => true,
                    'html' => false,
                  ),
                ),
              ),
            ),
          ),
          'staging' => 
          array (
            'domain' => 'staging.example.com',
            'settings' => 
            array (
              'theme' => 'twentytwentyone',
              'plugins' => 
              array (
                0 => 'seo',
                1 => 'security',
              ),
              'options' => 
              array (
                'comments' => false,
                'registration' => false,
              ),
            ),
          ),
        ),
      ) );
      """
      
    When I run `wp config get SITE_CONFIG --format=json`
    Then STDOUT should be JSON containing:
      """
      {
        "sites": {
          "main": {
            "domain": "example.com",
            "settings": {
              "theme": "twentytwentyone",
              "plugins": [
                "seo",
                "security",
                "cache"
              ],
              "options": {
                "comments": true,
                "registration": false,
                "performance": {
                  "optimize_images": true,
                  "minify": {
                    "css": true,
                    "js": true,
                    "html": false
                  }
                }
              }
            }
          },
          "staging": {
            "domain": "staging.example.com",
            "settings": {
              "theme": "twentytwentyone",
              "plugins": [
                "seo",
                "security"
              ],
              "options": {
                "comments": false,
                "registration": false
              }
            }
          }
        }
      }
      """