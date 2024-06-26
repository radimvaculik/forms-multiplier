.PHONY: install qa cs csf phpstan tests coverage

install:
	composer update

qa: phpstan cs

cs:
ifdef GITHUB_ACTION
	vendor/bin/phpcs --standard=ruleset.xml --encoding=utf-8 --extensions="php,phpt" --colors -nsp -q --report=checkstyle src tests | cs2pr
else
	vendor/bin/phpcs --standard=ruleset.xml --encoding=utf-8 --extensions="php,phpt" --colors -nsp src tests
endif

csf:
	vendor/bin/phpcbf --standard=ruleset.xml --encoding=utf-8 --colors -nsp src tests

phpstan:
	vendor/bin/phpstan analyse -c phpstan.neon

tests:
	vendor/bin/codecept build
	vendor/bin/codecept run

coverage:
ifdef GITHUB_ACTION
	vendor/bin/codecept build
	XDEBUG_MODE=coverage vendor/bin/codecept run --coverage --coverage-xml
else
	vendor/bin/codecept build
	XDEBUG_MODE=coverage vendor/bin/codecept run --coverage --coverage-html
endif
