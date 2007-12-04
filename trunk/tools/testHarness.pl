#!/usr/bin/perl

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
					print "ssh $iphone '/Applications/$app.app/$exe \"$rpn\"'\n";
				}
				$output = `ssh $iphone '/Applications/$app.app/$exe "$rpn"'`;
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