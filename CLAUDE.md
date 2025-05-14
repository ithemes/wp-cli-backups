# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build/Lint/Test Commands
- Run all tests: `composer test`
- Run linter tests: `composer run lint`
- Run behat tests: `WP_CLI_TEST_DBHOST=127.0.0.1:33065 composer run behat`
- Run a single Behat feature: `WP_CLI_TEST_DBHOST=127.0.0.1:33065 omposer run behat features/specific-feature.feature`
- Run PHP CodeSniffer: `composer phpcs`
- Fix code style automatically: `composer phpcbf`

## Code Style Guidelines
- **Namespaces**: Use `SolidWP\WP_CLI\Backups` for all classes
- **Error Handling**: Use WP_CLI::error() for fatal errors, WP_CLI::warning() for non-fatal issues
- **Formatting**: Follow WordPress Coding Standards (WPCS)
- **Documentation**: PHPDoc blocks for classes and methods with @param, @return, etc.
- **Type Declarations**: Use PHP docblock type annotations
- **Command Structure**: Follow WP-CLI command patterns with OPTIONS and EXAMPLES sections
- **Testing**: Include Behat tests for commands and PHPUnit tests for units
- **Variable Naming**: Use snake_case for variables, CamelCase for class names
