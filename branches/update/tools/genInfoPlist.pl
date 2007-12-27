#!/usr/bin/perl

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

$name = $ARGV[0];
$exe = $ARGV[1];

$id = $name;
$id =~ s/-//g;
$id =~ tr/A-Z/a-z/;
$id = "net.fors.iphone.$id";
             

$svnrev = `cat svnrev`;
$build = `cat buildnum`;
$ver = `cat meta/version.$exe`; # . " (r${svnrev}x${build})";
$ver =~ s/[\r\n]//g;

print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print "<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n";
print "<plist version=\"1.0\">\n";
print "<dict>\n";
print "    <key>CFBundleDevelopmentRegion</key>\n";
print "    <string>English</string>\n";
print "    <key>CFBundleExecutable</key>\n";
print "    <string>$exe</string>\n";
print "    <key>CFBundleIdentifier</key>\n";
print "    <string>$id</string>\n";
print "    <key>CFBundleInfoDictionaryVersion</key>\n";
print "    <string>6.0</string>\n";
print "    <key>CFBundleName</key>\n";
print "    <string>$name</string>\n";
print "    <key>CFBundlePackageType</key>\n";
print "    <string>APPL</string>\n";
print "    <key>CFBundleSignature</key>\n";
print "    <string>????</string>\n";
print "    <key>CFBundleVersion</key>\n";
print "    <string>$ver</string>\n";
# print "    <key>SBUsesNetwork</key>\n";
# print "    <integer>3</integer>\n";
# print "    <key>UIHasPrefs</key>\n";
# print "    <true/>\n";
# print "    <key>UIPriority</key>\n";
# print "    <integer>75</integer>\n";
# print "    <key>NSPrincipalClass</key>\n";
# print "    <string>DrinksApp</string>\n";
print "</dict>\n";
print "</plist>\n";
