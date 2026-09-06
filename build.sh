#!/bin/sh

carbon build *.carbon --output=snake -- -- raylib/lib/libraylib.a -lX11
