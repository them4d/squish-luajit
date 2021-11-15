
OPTIONS=-q --with-virtual-io

squish: squish.lua squishy
	./squish.lua $(OPTIONS) # Bootstrap squish
	chmod +x squish
	./squish -q gzip # Minify gunzip code
	./squish $(OPTIONS) --with-gzip # Build squish with minified gzip
	
install: squish
	install squish /usr/local/bin/squish

clean:
	rm squish gunzip.lua
