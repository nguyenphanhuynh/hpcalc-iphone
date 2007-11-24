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

$ver = `/usr/local/bin/svnversion .`;
$ver =~ s/[\r\n]//g;
($ver =~ m/\d+[MS]*$/) && ($ver = $&);
# $ver = `cat version` . "r" . $ver;
$ver =~ s/[\r\n]//g;

print "$ver\n";
