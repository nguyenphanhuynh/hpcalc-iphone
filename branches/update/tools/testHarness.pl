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

$| = 1;

$debug = 0;

$app = $ARGV[0];
$exe = $ARGV[1];
$iphone = $ARGV[2];

exec `mkdir -p build/tests/$exe`;

$longest = 25;

for ($i=0; $i<$#ARGV-2; $i++) {
	$file = $ARGV[3+$i];
	
	if ($file =~ /tests/) {
		$data = `cat $file`;
		$data =~ s/[\r\n]//g;
		# $data =~ s/\s+/ /g;

		@tests = split("</test>", $data);

		print "$exe $file";
		for ($j=length($file); $j<$longest; $j++) {
			print ".";
		}
		print " ";

		$passed = 0;
		$failed = 0;
		$n = 0;
		foreach (@tests) {
			$n++;
			$test = $_;
			$models = $test;
			$models =~ s/.*<models>(.*?)<\/models>.*/$1/;
			$models = ($models eq $test) ? "all" : $models;
			$rpn = $_;
			$rpn =~ s/.*<rpn>(.*?)<\/rpn>.*/$1/;
			$rpn = ($rpn eq $test) ? "" : $rpn;
			$rpn =~ s/^\s*(.*?)\s*$/$1/;
			$result = $_;
			$result =~ s/.*<result>(.*?)<\/result>.*/$1/;
			$result = ($result eq $test) ? "" : $result;
			$result =~ s/^\s*(.*?)\s*$/$1/;

			$buildModel = $exe;
			$buildModel =~ s/hp//g;
			# print "$buildModel |$models|\n";
			if ( (($models eq "all") || ($models =~ /$buildModel/)) && ($rpn ne "") && ($result ne "") ) {
				if ($debug) {
					print "ssh $iphone '/Applications/$app.app/$exe --nogui \"$rpn\"'\n";
				}
				$output = `ssh $iphone '/Applications/$app.app/$exe --nogui "$rpn"'`;
				$output =~ s/[\r\n]//g;
				$output =~ s/^\s*(.*?)\s*$/$1/;
				if ($debug) {
					print "expected: |" . $result . "|\n";
					print "received: |" . $output . "|\n";
				}
				if ($output eq $result) {
					$passed++;
				} else {
					$failed++;
				}
			}
		}
		
		if ( !$passed && !$failed ) {
			print "n/a";
		}

		if ($passed) {
			print $passed . " passed";
			if ($failed) {
				print ", ";
			}
		}
		if ($failed) {
			print $failed . " FAILED";
		}
		print "\n";

		if ($failed) {
			exit 1;
		}

		$name = $file;
		$name =~ s/.*\///;
		exec `touch build/tests/$exe/$name`;
	}
}

exit 0;
