<?php

namespace WP_CLI\HelloWorld;

use SolidWP\WP_CLI\Backups\MergeWpConfig;
use WP_CLI;

if ( ! class_exists( '\WP_CLI' ) ) {
	return;
}

( function () {
	$autoload = __DIR__ . '/vendor/autoload.php';

	if ( file_exists( $autoload ) ) {
		require_once $autoload;
	}

	WP_CLI::add_command( 'solid backups merge-wp-config', MergeWpConfig::class );
} )();
