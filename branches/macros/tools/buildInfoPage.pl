#!/usr/bin/perl

$name = $ARGV[0];
$name =~ s/-//;

$url = "http://code.google.com/p/hpcalc-iphone/wiki/Info$name";

print <<'_PRE_';
<html>
<head>
<meta name="viewport" content="width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
<style>
body { font-family: arial, helvetica; font-size: 11pt; padding-bottom: 60px;}
img { text-align: left; background-color: #ccc;}
p { padding: 0px 10px 0px 10px; margin: 5px 0px 0px 0px; }
h1 { font-size: 14pt; padding: 15px 10px 0px 10px; margin: 0px; }
ul { margin-top: 5px; }
</style>
</head>
<body>
_PRE_

$data = `curl -s "$url"`;
$data =~ s/[\r\n]//g;
$data =~ s/.*-----start-----\s+<\/p>//;
$data =~ s/-----end-----.*//;
$data =~ s/rel="nofollow"//g;
$data =~ s/<p><img (src=".*screenshot-[0-9][0-9]c.png") \/>\s+<\/p>/<img $1 width="285" height="224" alt="Loading..."\/>/;
print "$data\n";

print <<'_POST_';
<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-71850-9";
urchinTracker();
</script></body>
</html>
_POST_

