#!/usr/bin/perl
#
#    downsample.pl
#    quick program to downsample textures for buffers and resource data
#    mini/eso
#    small projects and stand-alone programs or documents, esoteric or dependant
#
#    Copyright (C) 1995-2018 Gabriel Thomas Sharp
#
#    Written by Gabriel T. Sharp <21shariria@gmail.com>
#    Latest versions of this and all of my projects can be
#    obtained by visiting the repository: 
#
#    <https://github.com/osirisgothra>
#
#    Because of the global availability of github at this point, hosting
#    any additional servers for public use no longer serves a purpose. All
#    content is available 24/7 through github. (Thanks to GITHUB!).
#
#    This program is free software; you can redistribute it and/or modify
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
#    HISTORY
#
#	 Wed 25 Nov 2020 11:10:10 AM EST
#            osirisgothra@ initially created this file
#            with the original name, downsample.pl

use warnings;
use strict;

use File::Find::Rule;
use Path::Tiny;
use Cwd;
use v5.20;
use Carp;
use POSIX;

my $flock = path("dont-downsample-me.dir");

my $destruction_msg = <<~'destruction_msg'

    HOW TO USE THIS SCRIPT

    This is a perl script, it was written and tested with Perl v5.30, and is versioned at v5.20, so you will need at least v5.20 to run it.
    This script is only verfied to run under Debian (Ubuntu, Mint, etc) environments. Windows users will most likely have to make changes
    to get it to run for them. That said, I do try to make things portable when possible usually (like not using external programs, instead
    using core modules when possible, using Path::Tiny, etc). If you need help there are tons of perl porting tips in perlport or on cpan.
    Just google it if you are unsure where to start, and with that out of the way, on to the main event.

    What it does:

    This program downsamples using convert-im6 from imagemagick, so you will need a copy of imagemagick in your system path (so that convert-im6
    will actually run).

    The target width/heights are hard coded, are set to 16px, if you want another size, you'll need to change that.

    Before You Begin

    WARNING!!

    THIS PROGRAM WILL DESTRUCTIVELY WORK ON FILES IN ITS DIRECTORY
    DONT RUN UNLESS YOU ARE SURE YOU ARE OK WITH POSSIBLY LOSING STUFF
    MAKE SURE YOU BACK UP ALL IMAGES IN A SAFE PLACE (NOT UNDER THE SAME DIR!)
    I AM NOT RESPONSIBLE FOR LOSS, DAMAGE, ETC TO YOU OR YOUR EQUIPMENT OR FILES!

    ONCE YOU ARE SURE YOU WANT TO ACTUALLY START

    zsh users: you might want to use 'emulate bash' 

    #) INSTRUCTION                                                                                      EXAMPLE OF WHAT TO TYPE AT COMMAND LINE (ASSUMES SHELL==zsh/bash)
    1) COPY TEXTUREPACK TO BE CONVERTED INTO A NEW DIRECTORY BY ITSELF                                  mkdir /tmp/no_regrets/isolated_dir; cd $_; cp --no-clobber /my/texpack/* -Rv $_
    2) PUT THIS SCRIPT FILE IN (MAKE COPY) THAT ROOT DIRECTORY                                          cp downsample.pl /tmp/no_regrets/isolated_dir/downsample.pl
    3) CHANGE TO THE ROOT OF THAT DIR                                                                   cd /tmp/no_regrets/isolated_dir
    4) MAKE downsample.pl EXECUTABLE, OR, IF YOU CANT DO THAT, SEE 5B, OTHERWISE SEE 5A                 chmod a+x downsample.pl
   5A) RUN SCRIPT WITH --destructive TO BEGIN CONVERSIONS                                               ./downsample.pl --destructive
   5B) NONEXE MODE; RUN WITH PERL AND --destructive PASS TO SCRIPT                                      perl ./downsample.pl -- --destructive
    6) CONVERSION WILL START (IT WILL TAKE LONGER DEPENDING ON THE FILE COUNT)                          *
    7) VERIFY FILES ARE CORRECT AND COPY TO WHEREVER YOU WANT THEM                                      setopt globstar; display-im6 **

    dont forget to 'setopt noglobstar' after finishing, along with 'emulate zsh' (zsh users only)       setopt noglobstar; emulate zsh

destruction_msg
                                                                                                        ;
unless ( @ARGV && $ARGV[0] eq "--destructive" ) 
{
    my $x=17;   
    if ( defined($ENV{TERM}) && length($ENV{TERM}) > 0 ) {
        (print("[38;5;" . $x . "m$_\n"),$x+=( $x < 255 ? ( /^\s*$/ ? 36 : 6 ) : (-1*$x) ) ) for split("\n",$destruction_msg);
    } else { print($destruction_msg); }
    exit(127);
}    
die("this texture pack is locked for safety purposes, if you REALLY want to convert it, make a new copy in another directory excluding the dont_downsample_me lockfile, ITS IS NOT RECOMMENDED TO JUST DELETE THE FILE AND RUN IN PLACE BECAUSE IT WILL DESTROY THE ORIGINAL FILES") if $flock->exists();




confess("please run in a valid texture directory root") unless ( -r "screenshot.png" || -r "override.txt" || -r "README.md" );

say "reading files...";
my @items = File::Find::Rule->file("*.png")->in(cwd());
say "checking filenames...";
for (@items) {
    die("an image has whitespace: $_") if /\s/;
}
die("no items to convert") if scalar(@items) < 1;
say "converting...";
my ($cur, $tot) = (0, scalar(@items));

for my $tgt (@items) {
    $cur++;    
    my $perc = POSIX::ceil(($cur*100)/$tot);
    
    printf("[s[38;5;".$perc."m[2Kconverting ($perc percent done) $tgt[u");

    my $dat = `identify-im6 $tgt 2>/dev/null` // "";
    if ((defined($dat) && length($dat) > 0)) 
    {
        my ($name,$kind,$res,$geom,$depth,$space,$colorcount,$size,$jitter,$duration) = split(m/\s+/,$dat);
        my ($resx, $resy) = split(m/x/,$res);
        if ($resx <= 512 || $resy <= 512)
        {
            # must be even resolution (ie 32x32) or a modulus of aeri (ie 256x32, 16x512, etc)
            if ($resx == $resy || !($resx % $resy) || !($resy % $resx)) 
            {               
                if ($resx > $resy)
                {
                    $resx = 16 * ($resx / $resy);
                    $resy = 16;                
                }
                elsif ($resy > $resx)
                {
                    $resy = 16 * ($resy / $resx);
                    $resy = 16;
                }
                else # ( resy == resx is the only possible other condition if they are not less or greater than one another )
                {
                    $resx = 16;
                    $resy = 16;
                }
                 system("convert-im6 $tgt -interpolative-resize ". $resx ."x" . $resy . " -colors 255 $tgt");
            }
            else 
            {
                if ($resx % $resy) 
                {
                    say("skipped too big image $tgt");
                } 
                else 
                {
                    say("image is not square (texture) or square modulus (animation), skipped $tgt");
                }                
           }    
        }
    } 
    else 
    {
        say("skipped nonimage $tgt");
    }
 }