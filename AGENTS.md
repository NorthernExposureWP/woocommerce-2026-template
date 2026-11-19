# Project Overview

- This repository is a reusable WordPress and WooCommerce development template.
- Each project cloned from this template has its own Git history and may add its own plugins and requirements.
- The repository provides infrastructure and a working WordPress/WooCommerce environment; it is not itself a sample plugin.
- Preserve the existing architecture and avoid adding project-specific functionality to the template without an explicit task.
- Use repository configuration as the source of truth for PHP, WordPress, WooCommerce, PHPUnit, PHPStan, and Docker versions.

## Repository Layout

- `public/` contains the WordPress installation and Core.
- Root `wp-content/` contains the project's WordPress content, including custom plugins and bundled third-party components such as WooCommerce.
- Root `vendor/` contains project Composer dependencies.
- Do not modify WordPress Core, WooCommerce, Composer dependencies, or generated files to implement project functionality. Do not modify files in `vendor/`. Modify `composer.json` and `composer.lock` only when dependency or project configuration changes are explicitly authorized by the user.
- Extend platform behavior through supported APIs, hooks, and filters.

## WordPress and WooCommerce Development

- Prefer public, documented WordPress and WooCommerce APIs.
- Check the installed project versions and consult official documentation when API behavior or compatibility is uncertain.
- Avoid deprecated APIs and WooCommerce internal classes or methods unless a task explicitly requires them and their use is justified.
- Put new WordPress functionality in a plugin. Use theme code only for presentation or behavior that is strictly theme-dependent.
- Follow existing project conventions. Keep implementation straightforward and avoid abstractions that do not solve a demonstrated need.
- Use WordPress APIs for options, metadata, HTTP requests, scheduling, and other platform-managed behavior.
- Use WooCommerce CRUD objects and supported query APIs for products, orders, customers, and other WooCommerce data.
- Do not assume that WooCommerce data is stored in a particular WordPress table or bypass its data stores with direct SQL.
- When an extension adds order functionality, account for High-Performance Order Storage (HPOS). Test with HPOS enabled and disabled when both modes are in scope.
- Declare HPOS or other WooCommerce feature compatibility only after the relevant behavior has been tested.
- For cart and checkout changes, determine whether the feature uses shortcode-based checkout, Cart and Checkout blocks, or the Store API. Use the extension points appropriate to the active experience; do not assume legacy hooks cover block checkout.
- Treat Store API responses as potentially public. Do not expose credentials, private keys, or other sensitive data.

## Security and Data Handling

- Treat request data, database values, and third-party responses as untrusted.
- Validate values against expected types, formats, ranges, and allowed choices. Sanitize when transformation is appropriate.
- Escape output as late as possible using the function appropriate to its HTML, attribute, URL, JavaScript, or other context.
- Check user capabilities for authorization before privileged actions.
- Use WordPress nonces to verify request intent and help prevent CSRF. A nonce is not authentication or authorization and does not replace capability checks.
- For REST API routes, define an appropriate `permission_callback`; validate and sanitize registered arguments.
- Use prepared queries for any justified direct database query. Prefer platform APIs when they provide the required behavior.
- Do not expose secrets in source code, logs, command output, documentation, or responses.

## Testing and Verification

- Inspect the existing test setup and relevant documentation before choosing checks.
- Add or change tests when requested or when needed to verify implemented behavior. Do not add test frameworks, dependencies, or directory structures without a clear reason.
- Use the existing unit and integration test suites for their intended purposes.
- For WordPress and WooCommerce behavior, verify runtime behavior in the project environment when practical. Include relevant modes such as HPOS or block checkout when the change affects them.
- Run the project's documented syntax checks, static analysis, and tests that are relevant to the change.
- Do not modify tests merely to make them pass; confirm the underlying behavior and requirement.
- Report exactly which checks were run and their results. State what remains unverified if a check could not run.

## Project Documentation

- Consult `docs/ARCHITECTURE.md` for project structure and Composer autoloading conventions.
- Consult `docs/TESTING.md` for test organization and test commands.
- Consult `docs/CODE_QUALITY.md` for static-analysis instructions.

## Working with Codex

- Read the applicable instructions, Git status, and relevant files before making changes.
- Treat existing modified, staged, and untracked files as user-owned. Do not overwrite, discard, or reformat unrelated work.
- Make only changes needed for the requested task. For non-trivial tasks, analyze requirements and propose an implementation plan before making changes. Wait for the user's approval before implementing the plan.
- Do not change dependency versions, database structures, public interfaces, or project configuration beyond the task scope.
- Do not install, remove, or update dependencies unless explicitly authorized.
- Do not run destructive commands or modify external services without explicit authorization.
- Do not stage, commit, push, publish, or send messages unless explicitly requested.
- Use English for development communication and artifacts.
- Before finishing, inspect the diff and report the files changed, relevant decisions, checks performed, and limitations. Never claim a check passed unless it was run successfully.