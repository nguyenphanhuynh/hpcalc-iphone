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
$id =~ s/\-//g;
$id =~ tr/A-Z/a-z/;
$id = "net.fors.iphone.$id";

$svnrev = `cat svnrev`;
$build = `cat buildnum`;
$ver = `cat version`; # . "r${svnrev}x${build}";
$ver =~ s/[\r\n]//g;
           
$archive = $name;
$archive =~ s/\-//g;
$archive =~ tr/A-Z/a-z/;
$archive .= "-" . `cat version`; # . "r${svnrev}x${build}";
$archive =~ s/[\r\n]//g;

$latest = $archive;

$xml = $archive;
$xml .= ".xml";

$archive .= ".zip";

# Create Archive
exec `cd build; zip -r $archive $name.app`;

# Create XML

open(FP, ">build/$xml");

print FP "<dict>\n";

print FP "    <key>bundleIdentifier</key>\n";
print FP "    <string>$id</string>\n";

print FP "    <key>name</key>\n";
print FP "    <string>$name</string>\n";

print FP "    <key>version</key>\n";
print FP "    <string>$ver</string>\n";

print FP "    <key>location</key>\n";
print FP "    <string>http://hpcalc-iphone.googlecode.com/files/$archive</string>\n";

print FP "    <key>maintainer</key>\n";
print FP "    <string>Thomas Fors</string>\n";

print FP "    <key>contact</key>\n";
print FP "    <string>tom\@fors.net</string>\n";

@size = stat("build/$archive");
print FP "    <key>size</key>\n";
print FP "    <string>" . $size[7] . "</string>\n";

$now = `date +%s`;
$now =~ s/[\r\n]//g;
print FP "    <key>date</key>\n";
print FP "    <string>" . $now . "</string>\n";

$hash = `md5sum build/$archive`;
$hash =~ s/[\r\n]//g;
$hash =~ s/\s.*$//;
print FP "    <key>hash</key>\n";
print FP "    <string>" . $hash . "</string>\n";

print FP "    <key>url</key>\n";
print FP "    <string>http://hpcalc-iphone.googlecode.com/</string>\n";

$desc = `cat description`;
$desc =~ s/[\r\n]/ /g;
print FP "    <key>description</key>\n";
print FP "    <string>$desc</string>\n";

@scripts = `cat src/scripts.xml`;
$n = 0;
foreach $line (@scripts) {
    if ($line =~ /\$\(\(NAME\)\)/i) {
        $line =~ s/\$\(\(NAME\)\)/$name/i;
        $scripts[$n] = $line;
    }
	if ($line =~ /\$\(\(EXE\)\)/i) {
        $line =~ s/\$\(\(EXE\)\)/$exe/i;
        $scripts[$n] = $line;
    }

	$scripts[$n] = "    " . $scripts[$n];

    $n++;
}
print FP @scripts;

print FP "    <key>category</key>\n";
print FP "    <string>Utilities</string>\n";

print FP "</dict>\n";

close(FP);

exec `echo $latest > build/latest`;
