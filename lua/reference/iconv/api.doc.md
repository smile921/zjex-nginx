
Lua-iconv is POSIX 'iconv' binding for the Lua Programming Language. The
iconv library converts a sequence of characters from one codeset into a
sequence of corresponding characters in another codeset. The codesets
are those specified in the iconv.new() call that returned the conversion
descriptor, cd.

Lua-iconv 7 *requires* Lua 5.1 or Lua 5.2. For Lua 5.0, use the first
release (lua-iconv-r1).

Details on iconv may be obtained in the Open Group's interface definition
(http://www.opengroup.org/onlinepubs/007908799/xsh/iconv.h.html).



=== Download and installation ===

Lua-iconv can be obtained from its GitHub project page
(https://github.com/ittner/lua-iconv/downloads), from a LuaRocks server or
from some Linux distributions which already provide it (eg. Debian).

Unless you downloaded a compiled package, you must build the library for
your system. If you have LuaRocks installed, all the process is automatic;
just fire up your favourite shell and type, as root:

    luarocks install lua-iconv

and the package will be downloaded from a rock server, installed and
configured. Otherwise, you must compile and install the package. In a system
with pkg-config (as many Linux distributions and Unix flavors) open a shell,
untar the distribution package and, within the program directory, type:

    make install

as root. The library will be compiled and installed on the in the correct
path (which is defined in lua5.x.pc). Compiling on systems without pkg-config
requires manual changes in the Makefile (this includes Windows).



=== Loading and initialization ===

Lua-iconv is a shared library that must be loaded in the Lua interpreter
before use. You can simply do a

    local iconv = require("iconv")

call to load up the library (that, of course, must be installed in a
directory from package.cpath).



=== API documentation ===

  cd = iconv.new(to, from)
  cd = iconv.open(to, from)

    Opens a new conversion descriptor, from the 'from' charset to the
    'to' charset. Concatenating "//TRANSLIT" to the first argument will
    enable character transliteration and concatenating "//IGNORE" to
    the first argument will cause iconv to ignore any invalid characters
    found in the input string.

    This function returns a new converter or nil on error.


  nstr, err = cd:iconv(str)

    Converts the 'str' string to the desired charset. This method always
    returns two arguments: the converted string and an error code, which
    may have any of the following values:

    nil
        No error. Conversion was successful.

    iconv.ERROR_NO_MEMORY
        Failed to allocate enough memory in the conversion process.

    iconv.ERROR_INVALID
        An invalid character was found in the input sequence.

    iconv.ERROR_INCOMPLETE
        An incomplete character was found in the input sequence.

    iconv.ERROR_FINALIZED
        Trying to use an already-finalized converter. This usually means
        that the user was tweaking the garbage collector private methods.

    iconv.ERROR_UNKNOWN
        There was an unknown error.

