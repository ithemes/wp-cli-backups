Feature: Merge values into wp-config.php

  Scenario: Merge multiple values into wp-config.php
    Given a WP install
    And a original-wp-config.php file:
      """
      <?php
      /**
       * The base configuration for WordPress
       *
       * The wp-config.php creation script uses this file during the installation.
       * You don't have to use the web site, you can copy this file to "wp-config.php"
       * and fill in the values.
       *
       * This file contains the following configurations:
       *
       * * Database settings
       * * Secret keys
       * * Database table prefix
       * * ABSPATH
       *
       * @link https://wordpress.org/documentation/article/editing-wp-config-php/
       *
       * @package WordPress
       */

      // ** Database settings - You can get this info from your web host ** //
      /** The name of the database for WordPress */
      define( 'DB_NAME', 'wordpress' );

      /** Database username */
      define( 'DB_USER', 'root' );

      /** Database password */
      define( 'DB_PASSWORD', 'password' );

      /** Database hostname */
      define( 'DB_HOST', 'localhost' );

      /** Database charset to use in creating database tables. */
      define( 'DB_CHARSET', 'utf8' );

      /** The database collate type. Don't change this if in doubt. */
      define( 'DB_COLLATE', '' );

      /**#@+
       * Authentication unique keys and salts.
       *
       * Change these to different unique phrases! You can generate these using
       * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
       *
       * You can change these at any point in time to invalidate all existing cookies.
       * This will force all users to have to log in again.
       *
       * @since 2.6.0
       */
      define( 'AUTH_KEY',         'put your unique phrase here' );
      define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
      define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
      define( 'NONCE_KEY',        'put your unique phrase here' );
      define( 'AUTH_SALT',        'put your unique phrase here' );
      define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
      define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
      define( 'NONCE_SALT',       'put your unique phrase here' );

      /**#@-*/

      /**
       * WordPress database table prefix.
       *
       * You can have multiple installations in one database if you give each
       * a unique prefix. Only numbers, letters, and underscores please!
       */
      $table_prefix = 'wp_';

      /**
       * For developers: WordPress debugging mode.
       *
       * Change this to true to enable the display of notices during development.
       * It is strongly recommended that plugin and theme developers use WP_DEBUG
       * in their development environments.
       *
       * For information on other constants that can be used for debugging,
       * visit the documentation.
       *
       * @link https://wordpress.org/documentation/article/debugging-in-wordpress/
       */
      define( 'WP_DEBUG', false );

      /* Add any custom values between this line and the "stop editing" line. */



      /* That's all, stop editing! Happy publishing. */

      /** Absolute path to the WordPress directory. */
      if ( ! defined( 'ABSPATH' ) ) {
      	define( 'ABSPATH', __DIR__ . '/' );
      }

      /** Sets up WordPress vars and included files. */
      require_once ABSPATH . 'wp-settings.php';
      """
    And a wp-config-values.json file:
      """
      [
        {
          "name": "DB_NAME",
          "value": "new_database",
          "type": "constant"
        },
        {
          "name": "DB_USER",
          "value": "new_user",
          "type": "constant"
        },
        {
          "name": "WP_DEBUG",
          "value": true,
          "type": "constant"
        },
        {
          "name": "WP_CACHE",
          "value": true,
          "type": "constant"
        },
        {
          "name": "table_prefix",
          "value": "wp_new_",
          "type": "variable"
        }
      ]
      """
    And copy the original-wp-config.php file to wp-config.php

    When I run `cat wp-config-values.json | wp solid backups merge-wp-config`
    Then STDOUT should contain:
      """
      Success: Successfully saved config values: DB_NAME, DB_USER, WP_DEBUG, WP_CACHE, table_prefix.
      """
    And the wp-config.php file should contain:
      """
      define( 'DB_NAME', 'new_database' );
      """
    And the wp-config.php file should contain:
      """
      define( 'DB_USER', 'new_user' );
      """
    And the wp-config.php file should contain:
      """
      define( 'WP_DEBUG', true );
      """
    And the wp-config.php file should contain:
      """
      define( 'WP_CACHE', true );
      """
    And the wp-config.php file should contain:
      """
      $table_prefix = 'wp_new_';
      """

  Scenario: Test merge with --porcelain flag
    Given a WP install
    And a original-wp-config.php file:
      """
      <?php
      define( 'DB_NAME', 'wordpress' );
      define( 'DB_USER', 'root' );
      $table_prefix = 'wp_';
      """
    And a wp-config-values.json file:
      """
      [
        {
          "name": "DB_NAME",
          "value": "new_database",
          "type": "constant"
        },
        {
          "name": "DB_USER",
          "value": "new_user",
          "type": "constant"
        }
      ]
      """
    And copy the original-wp-config.php file to wp-config.php

    When I run `cat wp-config-values.json | wp solid backups merge-wp-config --porcelain`
    Then STDOUT should be empty
    And the wp-config.php file should contain:
      """
      define( 'DB_NAME', 'new_database' );
      """
    And the wp-config.php file should contain:
      """
      define( 'DB_USER', 'new_user' );
      """

  Scenario: Test merge with --config-file flag
    Given a WP install
    And a custom-wp-config.php file:
      """
      <?php
      define( 'DB_NAME', 'wordpress' );
      define( 'DB_USER', 'root' );
      $table_prefix = 'wp_';
      """
    And a wp-config-values.json file:
      """
      [
        {
          "name": "DB_NAME",
          "value": "new_database",
          "type": "constant"
        }
      ]
      """

    When I run `cat wp-config-values.json | wp solid backups merge-wp-config --config-file=custom-wp-config.php`
    Then STDOUT should contain:
      """
      Success: Successfully saved config values: DB_NAME.
      """
    And the custom-wp-config.php file should contain:
      """
      define( 'DB_NAME', 'new_database' );
      """

  Scenario: Test merge with invalid JSON input
    Given a WP install

    When I try `echo "invalid json" | wp solid backups merge-wp-config`
    Then STDERR should contain:
      """
      Error: Invalid input. You must pass a JSON array to stdin.
      """
    And the return code should be 1

  Scenario: Test merge with invalid entry (missing required keys)
    Given a WP install
    And a wp-config-invalid.json file:
      """
      [
        {
          "name": "DB_NAME",
          "value": "new_database"
        }
      ]
      """

    When I try `cat wp-config-invalid.json | wp solid backups merge-wp-config`
    Then STDERR should contain:
      """
      Error: Invalid entry #0. The following keys are required: name, value, type.
      """
    And the return code should be 1

  Scenario: Test merge with invalid entry (invalid type)
    Given a WP install
    And a wp-config-invalid-type.json file:
      """
      [
        {
          "name": "DB_NAME",
          "value": "new_database",
          "type": "invalid"
        }
      ]
      """

    When I try `cat wp-config-invalid-type.json | wp solid backups merge-wp-config`
    Then STDERR should contain:
      """
      Error: Invalid entry #0. The type must be either "constant" or "variable".
      """
    And the return code should be 1
