---
case: internal-source-option-fix
expected_route: lightweight
authorization_source: activating-request
target: lib/example/options.rb
behavior_change: true
public_contract_change: false
migration_change: false
configuration_change: false
permission_change: false
security_or_concurrency_risk: false
external_actions: []
focused_test: test/options_test.rb
---

Correct one internal option branch. The exact behavior seam, changed paths, acceptance criteria, and focused regression
test are known. No public contract, compatibility surface, refactor, managed Sia definition, or unresolved assumption is
in scope.
