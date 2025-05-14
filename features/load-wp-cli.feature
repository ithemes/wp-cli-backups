Feature: Test that WP-CLI loads.

  Scenario: WP-CLI loads for your tests
    Given a WP install

    When I run `wp solid backups merge-wp-config --help`
    Then STDOUT should contain:
      """
      Merges a list of wp-config values
      """
