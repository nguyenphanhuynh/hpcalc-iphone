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

$hash = `md5 build/$archive`;
$hash =~ s/[\r\n]//g;
$hash =~ s/^.*=\s+//;
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
