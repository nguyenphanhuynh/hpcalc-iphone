# Copyright (c) 2007, Thomas Fors
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the copyright holder nor the names of its
#       contributors may be used to endorse or promote products derived from
#       this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
# OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

APPNAME=HP-15C
EXE=hp15c

CC = /usr/local/bin/arm-apple-darwin-gcc
LD = $(CC)
CFLAGS += -I/Developer/SDKs/iPhone/include
LDFLAGS = -isystem $(HEAVENLY) \
          -lobjc -lc \
          -framework CoreFoundation \
          -framework Foundation \
          -framework UIKit \
          -framework LayerKit \
          -framework CoreGraphics \
          -framework GraphicsServices \
          -framework WebCore \
		  -framework Celestial

NONPAREIL = build/proc_nut.o \
			build/macutil.o \
			build/digit_ops.o \
			build/voyager_lcd.o

OBJS = build/main.o \
       build/CalculatorApp.o \
       build/CalculatorView.o \
       build/KeypadView.o \
       build/DisplayView.o \
       build/Key.o \
	   build/hp15c.o \
	   $(NONPAREIL)

IMGS = img/Default.png \
       img/keypad.png \
       img/display.png \
	   img/9.png img/8.png img/7.png \
	   img/6.png img/5.png img/4.png \
	   img/3.png img/2.png img/1.png \
	   img/0.png img/neg.png \
	   img/comma.png img/decimal.png \
	   img/f.png img/g.png img/c.png\
	   img/grad.png img/rad.png \
	   img/E.png img/RR.png img/O.png \
	   img/r.png img/u.png img/n.png \
	   img/i.png img/P.png\
	   img/user.png img/prgm.png \
       img/icon.png
	
BUNDLE = build/$(EXE) src/15c.obj $(IMGS)


.PHONY: all
all: build/$(APPNAME).app

.PHONY: upload
upload: build/$(APPNAME).app
	rsync -avz --delete build/$(APPNAME).app/ $(IPHONEIP):/Applications/$(APPNAME).app/
	
package: build/$(APPNAME).app	
	tools/buildPackage.pl $(APPNAME) $(EXE)

publish: package
	@# Don't need to copy .zip file since it will go in the files section
	@# cp build/`cat build/latest`.zip ../repo
	cp build/`cat build/latest`.xml ../repo
	cp build/`cat build/latest`.xml ../repo/latest.xml
	cat src/packages.xml > ../repo/packages.xml
	cat build/`cat build/latest`.xml >> ../repo/packages.xml
	echo "</array>" >> ../repo/packages.xml
	echo "</dict>" >> ../repo/packages.xml
	echo "</plist>" >> ../repo/packages.xml

build/Info.plist: Makefile version $(BUNDLE)
	tools/updateSvnRev.pl > svnrev
	tools/incrBuildNum.pl
	tools/genInfoPlist.pl $(APPNAME) $(EXE) > build/Info.plist


build/$(APPNAME).app: $(BUNDLE) build/Info.plist
	mkdir -p build/$(APPNAME).app
	@list='$?'; for p in $$list; do \
		echo cp $$p build/$(APPNAME).app/; \
		cp $$p build/$(APPNAME).app/; \
	done
	@touch build/$(APPNAME).app

build/$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

build/%.o: src/%.m
	$(CC) $(CFLAGS) -c $(CPPFLAGS) $< -o $@

build/%.o: src/%.c
	$(CC) $(CFLAGS) -c $(CPPFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -rf build/$(APPNAME).app build/*
