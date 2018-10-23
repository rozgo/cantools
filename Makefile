test:
	python2 setup.py test
	python3 setup.py test
	$(MAKE) test-sdist
	env PYTHONPATH=. python2 examples/hello_world.py
	env PYTHONPATH=. python3 examples/hello_world.py
	env PYTHONPATH=. python3 examples/dbc_io/main.py
	env PYTHONPATH=. python3 examples/diagnostics/did.py
	codespell -d $$(git ls-files | grep -v \.kcd)
	$(MAKE) test_c

test_c:
	gcc -Wall tests/main.c \
	    tests/files/motohawk.c \
	    tests/files/padding_bit_order.c && ./a.out

test-sdist:
	rm -rf dist
	python setup.py sdist
	cd dist && \
	mkdir test && \
	cd test && \
	tar xf ../*.tar.gz && \
	cd cantools-* && \
	python setup.py test

release-to-pypi:
	python setup.py sdist
	python setup.py bdist_wheel --universal
	twine upload dist/*
