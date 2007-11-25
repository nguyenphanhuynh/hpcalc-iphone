# Copyright (c) 2007, Thomas Fors
# All rights reserved.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

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
	   img/begin.png img/dmy.png \
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
