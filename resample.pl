#!/usr/bin/perl
#
# FILE
#    resample.pl
#    fixes way-too-large files so they are minimal size without too much loss in detail" "earthseige64" "minetest earthsiege64 is a minetest texture pack with a couple utilities for converting it for the user
#
# PROJECT
#    resample.pl-proj
#	 project resample.pl-proj: container for resample.pl
#
# AUTHOR / COPYRIGHT
#
#    Copyright (C) 2020, 
#
#    Written by  osirisgothra@larnica.(none)
#    Latest versions of this and all of 's projects can be
#    obtained from:
#
#     <<projbranch>>
#
#    Documentation Available At:
#
#     <http://www.github.com/osirisgothra/resample.pl-proj.git>
#
# LICENSE
#
#    resample.pl-proj/resample.pl  is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
#  NOTES
#
#     * TODO: move 'use' statements to top if you want to keep them**
#    ** this feature will be added to the next version of perltemplate (hopefully)
#   *** warnings are disabled for experimental and once because they are pretty
#       annoying here, you might want to re-enable them for your own program
#       to do this during testing and development.
#
#  HISTORY
#
#	Sat Dec 19 12:35:35 2020
#         osirisgothra@larnica.(none) created this file using the template generator 'perltemplate'
#         and named it resample.pl for the project 'earthsiege64'
#
#
# (created with perltemplate by Gabriel T. Sharp <osirisgothra@hotmail.com>)
#

use warnings;
use v5.18;
use strict;
no warnings "experimental";			# 	allow given/when/default and smartmatching without their warnings***
no warnings "once";					# 	allow variables to be used just once without warning***

# my use set, any commented ones are not used in this project
use Path::Tiny qw( path );
use Curses::UI;
use File::MimeInfo;
use Term::ANSIColor;
use Cwd;
use Carp;
use Symbol;
use File::Find;
use Type::Tiny;
use Try::Tiny;
use Role::Tiny;
use HTTP::Tiny;
# personal uses - you will need to install these
# if downloaded from source, my lib projects and put them in /src/perl or change it to your location (like /home/me/src/perl, etc)
use lib "/src/perl";
use Term::Put;
use Config::INI;












