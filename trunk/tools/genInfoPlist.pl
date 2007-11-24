#!/usr/bin/perl

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

$name = $ARGV[0];
$exe = $ARGV[1];

$id = $name;
$id =~ s/-//g;
$id =~ tr/A-Z/a-z/;
$id = "net.fors.iphone.$id";
             

$svnrev = `cat svnrev`;
$build = `cat buildnum`;
$ver = `cat version`; # . " (r${svnrev}x${build})";
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
