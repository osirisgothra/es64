#!/usr/bin/perl

use warnings;
use strict;
use v5.20.2;                                                            #1
use feature 'signatures';                                               #2
no warnings 'experimental'; 

# Core Modules

use Carp;
use Cwd;
use Path::Tiny;
use Getopt::Long::Descriptive;
use POSIX qw( ceil floor exit );







## CSCS2021

#1  for this version, see feature(3perl) for bundle features
#2  signatures are experimental, but stable and are required in this file
#   also, warnings are shut off for experimental features enabled by #1 also
#   such as 'given' and 'when' and possibly the ~~ operator (smartmatch) 
#   extra functionalle`.
