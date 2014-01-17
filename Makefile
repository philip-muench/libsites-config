info:
	@echo "'make test' führt testschecks all files syntactically."
	@echo "'make dirs' erstellt Verzeichniss für alle Einrichtungen in isil.csv."
	@echo "'make docs' erstellt die Dokumentation im Verzeichnis doc/."
	@echo "'make clean' löscht alle Dateien, die nicht unter Versionskontrolle stehen."

test: test-code test-isil test-sites

test-isil:
	@cat isil.csv | perl -ne \
		'die "invalid ISIL in isil.csv: $$_" unless /^[A-Z]{1,3}-[A-Za-z0-9\/:-]{1,10}$$/'
	@echo isil.csv - OK

test-sites: sites
	@ls isil | perl -ne \
		'die "invalid ISIL directory: $$_" unless /^[A-Z]{1,3}-[A-Za-z0-9_:-]{1,10}$$/'

test-code:
	@prove -Ilib t

dirs: test-isil
	@cd isil && xargs mkdir -v -p < ../isil.csv

sites:
	@ls isil/*/sites.txt | xargs ./bin/sites

docs:
	@cd doc && make html pdf

clean:
	@git clean -xdf
