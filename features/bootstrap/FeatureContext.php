<?php

use Behat\Behat\Context\Context;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use WP_CLI\Tests\Context\FeatureContext as WPCLIFeatureContext;

/**
 * Features context for SolidWP Backups command
 */
class FeatureContext implements Context {

	/**
	 * @var WPCLIFeatureContext
	 */
	private $wpCliContext;

	/**
	 * Get the environment variables required for launch
	 */
	private static function get_process_env_variables() {
		$env = array();

		return $env;
	}

	/**
	 * @BeforeScenario
	 */
	public function before_scenario( BeforeScenarioScope $scope ) {
		$this->wpCliContext = $scope->getEnvironment()->getContext( 'WP_CLI\Tests\Context\FeatureContext' );
	}

	/**
	 * Copies a file to another file
	 *
	 * @Given /^copy the (.+) file to (.+)$/
	 */
	public function given_copy_file( $source_file, $destination_file ) {
		if ( isset( $this->wpCliContext ) ) {
			$cwd = $this->wpCliContext->variables['RUN_DIR'];

			$source_path      = $cwd . '/' . $source_file;
			$destination_path = $cwd . '/' . $destination_file;

			$this->wpCliContext->proc( "cp {$source_path} {$destination_path}", [] )->run();
		} else {
			throw new \Exception( 'WP-CLI FeatureContext not available.' );
		}
	}
}
