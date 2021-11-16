
# Squish - One language to write them all, one squisher to squish them (LuaJIT version)

Squish is a simple script to build a single file out of multiple scripts, modules, and other files.

For example if you have a script called A, and it requires modules X, Y and Z, all of them could be squished 
into a single file, B.

When run, Squish reads a file called 'squishy' in the current (or specified) directory, which contains 
instructions on how to squish a project.

For an example you can see Squish's own squishy file, included in this package. For reference, see below.

## Building and installing

Squish uses itself to squish itself and its components into a single 'squish' utility that can be run anywhere.
To build squish, just run "make" - there are no dependencies other than Lua.

You can run "make install" to copy squish to /usr/local/bin/ if you have permission.

## Squishing

Running squish will search for a 'squishy' file in the current directory. Alternatively you can pass to squish 
a directory to look in.

Command-line options vary depending on what features squish has been built with. Below are the standard ones.

### Gzip
Gzip, or rather the DEFLATE algorithm, is extremely good at compressing text-based data, including scripts. Using
this extension compresses the squished code, and adds some runtime decompression code. This decompression code adds
a little bit of time to the loading of the script, and adds 4K to the size of the generated code, but the overall
savings are usually well worth it.

#### --gzip
Compress the generated code with gzip. Requires the gzip command-line utility (for compression only).

### Virtual IO
Squish allows you to pack resources (any file) into the squished output. Sometimes it would be convenient to access these through 
the standard Lua io interface. Well now you can! :)

#### --virtual-io
Inserts code into the squished output which replaces io.open, io.lines, dofile and loadfile. The new functions will first check 
whether the specified filename matches a packed resource's name. If it does then it will operate on that resource instead of an 
actual file. If the filename does _not_ match a resource then the function passes on to the real Lua functions.

## Squishy reference

A squishy file is actually a Lua script which calls some Squish functions. These functions are listed here.

### Module "name" "path"
Adds the specified module to the list of those to be squished into the output file. The optional path specifies 
where to find the file (relative to the squishy file), otherwise Squish will attempt to find the module itself.

### Main "script.lua"
Adds a script into the squished output. Scripts are executed in the order specified in the squishy file, but only 
after all modules have been loaded.

### Output "filename.lua"
Names the output file. If none is specified, the default is 'squished.out.lua'.

### Option "name" "value"
Sets the specified option, to 'true', or to the optional given value. This allows a squishy file to set default 
command-line options.

### GetOption "name"
Returns the current value of the given option.

### Resource "name" "path"
Adds a 'resource' to the squished file. A resource may be any file, text, binary, large or small. Scripts can 
retrieve the resource at runtime by calling require_resource("name"). If no path is given then the name is used 
as the path.

### AutoFetchURL "url"
**Experimental** feature which is subject to change. When specified, all the following Module statements will be 
fetched via HTTP if not found on the filesystem. A ? (question mark) in the URL is replaced by the relative path 
of the module file that was given in the Module statement.

## make_squishy

Squish includes a small utility which aims to help with converting a project to use Squish. Pass it a list of files 
and it will scan those files looking for calls to require(). It will then attempt to resolve the module names to 
files relative to the directory of the first filename passed to make_squishy.

It generates a 'squishy.new' file in the current directory. Modify accordingly and rename to just 'squishy'.
