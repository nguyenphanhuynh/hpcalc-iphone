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

MODEL=15c
UCMODEL=$(subst c,C,$(MODEL))
APPNAME=HP-$(UCMODEL)
EXE=hp$(MODEL)

CC = /usr/local/bin/arm-apple-darwin-gcc
LD = $(CC)

CFLAGS += -I/Developer/SDKs/iPhone/include -Ibuild
CFLAGS += -DHP$(UCMODEL)
CFLAGS += -O3
CFLAGS += -Isrc

LDFLAGS = -isystem $(HEAVENLY) \
          -ObjC -dead_strip \
          -Lsrc -lot \
          -lobjc -lc -lz -lcrypto \
          -framework CoreFoundation \
          -framework Foundation \
          -framework UIKit \
          -framework LayerKit \
          -framework CoreGraphics \
          -framework GraphicsServices \
          -framework WebCore \
	      -framework AudioToolbox \
	      -framework Celestial

NONPAREIL = build/proc_nut.o \
            build/macutil.o \
            build/digit_ops.o \
            build/voyager_lcd.o

OBJS = build/main-$(MODEL).o \
       build/CalculatorApp-$(MODEL).o \
       build/CalculatorView-$(MODEL).o \
       build/KeypadView-$(MODEL).o \
       build/DisplayView-$(MODEL).o \
       build/MenuView-$(MODEL).o \
       build/MenuAlert-$(MODEL).o \
       build/MenuButton-$(MODEL).o \
       build/Key-$(MODEL).o \
       build/hpcalc-$(MODEL).o \
       $(NONPAREIL)

IMGS = img/Default-$(MODEL).png \
       img/keypad-$(MODEL).png \
       img/display-$(MODEL).png \
       img/9.png img/8.png img/7.png \
       img/6.png img/5.png img/4.png \
       img/3.png img/2.png img/1.png \
       img/0.png img/neg.png \
       img/a.png img/CC.png img/FF.png \
       img/comma.png img/decimal.png \
       img/d.png img/b.png img/h.png \
       img/f.png img/g.png img/c.png\
       img/grad.png img/rad.png \
       img/E.png img/RR.png img/O.png \
       img/r.png img/u.png img/n.png \
       img/i.png img/P.png\
       img/user.png img/prgm.png \
       img/begin.png img/dmy.png \
       img/alertbg.png img/alertbutton.png img/alertbuttonpressed.png \
       src/menu-$(MODEL).plist \
       img/icon-$(MODEL).png
	
BUNDLE = build/$(EXE) src/$(MODEL).obj $(IMGS)

TESTS = $(subst tests,tests/$(EXE),$(subst src,build,$(wildcard src/tests/*)))

.PHONY: app
app: build/$(APPNAME).app

.PHONY: post
post:
	./postToTestRepo.pl $(APPNAME) $(EXE)

.PHONY: all
all:
	$(MAKE) app MODEL=15c
	$(MAKE) app MODEL=12c
	$(MAKE) app MODEL=11c
	$(MAKE) app MODEL=16c
	
.PHONY: uploadall
uploadall:
	$(MAKE) upload MODEL=15c
	$(MAKE) upload MODEL=12c
	$(MAKE) upload MODEL=11c
	$(MAKE) upload MODEL=16c

.PHONY: upload
upload: build/$(APPNAME).app
	rsync -avz --delete build/$(APPNAME).app/ $(IPHONEIP):/Applications/$(APPNAME).app/

.PHONY: package
package:
	$(MAKE) pkg MODEL=15c
	$(MAKE) pkg MODEL=12c
	$(MAKE) pkg MODEL=11c
	$(MAKE) pkg MODEL=16c
	
pkg: build/$(APPNAME).app	
	tools/buildPackage.pl $(APPNAME) $(EXE)
	
.PHONY: moreinfo
moreinfo:
	$(MAKE) mi MODEL=15c
	$(MAKE) mi MODEL=12c
	$(MAKE) mi MODEL=11c
	$(MAKE) mi MODEL=16c
	
.PHONY: mi
mi:
	tools/buildInfoPage.pl $(APPNAME) > ../repo/$(EXE).html

publish: pkg
	@# Don't need to copy .zip file since it will go in the files section
	@# cp build/`cat build/latest`.zip ../repo
	cp build/`cat build/latest.$(EXE)`.xml ../repo
	cat `ls ../repo/hp15c-*.xml | sed -e "s/.xml//" | sort -r | head -n 1`.xml > ../repo/latest.xml
	cat `ls ../repo/hp12c-*.xml | sed -e "s/.xml//" | sort -r | head -n 1`.xml >> ../repo/latest.xml
	cat `ls ../repo/hp11c-*.xml | sed -e "s/.xml//" | sort -r | head -n 1`.xml >> ../repo/latest.xml
	cat `ls ../repo/hp16c-*.xml | sed -e "s/.xml//" | sort -r | head -n 1`.xml >> ../repo/latest.xml
	cat src/packages.xml > ../repo/packages.xml
	cat ../repo/latest.xml >> ../repo/packages.xml
	echo "</array>" >> ../repo/packages.xml
	echo "</dict>" >> ../repo/packages.xml
	echo "</plist>" >> ../repo/packages.xml
	
build/Info-$(MODEL).plist: Makefile meta/version.$(EXE) $(BUNDLE)
	@ tools/updateSvnRev.pl > svnrev
	@ tools/incrBuildNum.pl
	tools/genInfoPlist.pl $(APPNAME) $(EXE) > build/Info-$(MODEL).plist

build/$(APPNAME).app: $(BUNDLE) build/Info-$(MODEL).plist
	@mkdir -p build/$(APPNAME).app
	@list='$?'; for p in $$list; do \
		cp -R $$p build/$(APPNAME).app/; \
	done
	@if test -e build/$(APPNAME).app/keypad-$(MODEL).png; then \
		rm -f build/$(APPNAME).app/keypad.png; \
		mv build/$(APPNAME).app/keypad-*.png build/$(APPNAME).app/keypad.png; \
	fi;
	@if test -e build/$(APPNAME).app/display-$(MODEL).png; then \
		rm -f build/$(APPNAME).app/display.png; \
		mv build/$(APPNAME).app/display-*.png build/$(APPNAME).app/display.png; \
	fi;
	@if test -e build/$(APPNAME).app/Default-$(MODEL).png; then \
		rm -f build/$(APPNAME).app/Default.png; \
		mv build/$(APPNAME).app/Default-*.png build/$(APPNAME).app/Default.png; \
	fi;
	@if test -e build/$(APPNAME).app/icon-$(MODEL).png; then \
		rm -f build/$(APPNAME).app/icon.png; \
		mv build/$(APPNAME).app/icon-*.png build/$(APPNAME).app/icon.png; \
	fi;
	@if test -e build/$(APPNAME).app/Info-$(MODEL).plist; then \
		rm -f build/$(APPNAME).app/Info.plist; \
		mv build/$(APPNAME).app/Info-$(MODEL).plist build/$(APPNAME).app/Info.plist; \
	fi;
	@if test -e build/$(APPNAME).app/menu-$(MODEL).plist; then \
		rm -f build/$(APPNAME).app/menu.plist; \
		mv build/$(APPNAME).app/menu-$(MODEL).plist build/$(APPNAME).app/menu.plist; \
	fi;
	@touch build/$(APPNAME).app
	@echo Files copied to build/$(APPNAME).app

build/$(EXE): $(OBJS)
	$(LD) -o $@ $^ $(LDFLAGS)

build/%-$(MODEL).o: src/%.m build/version-$(MODEL).h
	$(CC) $(CFLAGS) -c $(CPPFLAGS) $< -o $@

build/%.o: src/%.m
	$(CC) $(CFLAGS) -c $(CPPFLAGS) $< -o $@

build/%.o: src/%.c
	$(CC) $(CFLAGS) -c $(CPPFLAGS) $< -o $@
	  
build/version-$(MODEL).h: meta/version.$(EXE)
	cat $< | tools/updateVersion.pl > $@
	
.PHONY: checkall
checkall:
	$(MAKE) check MODEL=15c
	$(MAKE) check MODEL=12c
	$(MAKE) check MODEL=11c
	$(MAKE) check MODEL=16c

.PHONY: check	
check: testprep $(TESTS)
	@echo $(EXE) Passed all tests.
	
.PHONY: testprep
testprep:
	@echo Preparing $(EXE) for tests...
	@if test $(MODEL) = "11c"; then \
		ssh $(IPHONEIP) '/Applications/$(APPNAME).app/$(EXE) --nogui "FIX 9"' > /dev/null; \
	fi
	@if test $(MODEL) = "12c"; then \
		ssh $(IPHONEIP) '/Applications/$(APPNAME).app/$(EXE) --nogui "f 9"' > /dev/null; \
	fi
	@if test $(MODEL) = "15c"; then \
		ssh $(IPHONEIP) '/Applications/$(APPNAME).app/$(EXE) --nogui "FIX 9"' > /dev/null; \
	fi
	@if test $(MODEL) = "16c"; then \
		ssh $(IPHONEIP) '/Applications/$(APPNAME).app/$(EXE) --nogui "FLOAT 9"' > /dev/null; \
	fi
	
build/tests/$(EXE)/%: src/tests/% build/$(APPNAME).app/$(EXE)
	@tools/testHarness.pl $(APPNAME) $(EXE) $(IPHONEIP) $<
	
.PHONY: clean
clean:
	rm -rf build/HP-*.app build/*
