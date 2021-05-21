#!/bin/zsh

hex2dec3()
{
    # v-V
    # 0123456
    #     ^
    # aabbcc
    # 
    #  
    r=$(printf "%d" 0x${1: 0:2})
    g=$(printf "%d" 0x${1: 2:2})
    b=$(printf "%d" 0x${1: 4:2})
    integer rmod=4
    integer gmod=4 
    integer bmod=4
    r=$(( r / rmod ))
    g=$(( g / gmod ))
    b=$(( b / bmod ))
    
    print "$r,$g,$b"
    

}

declare -gA ele=( 
elements_aluminum_ingot.png aaaaaa
elements_gallium_ingot.png 446444
elements_germanium_ingot.png 334433
elements_hafnium_ingot.png bbaebb
elements_indium_ingot.png aaaaaa
elements_iridium_ingot.png ccaaaa
elements_lithium_ingot.png aaaacc
elements_molybendium_ingot.png 444444
elements_nichrome_ingot.png efefef
elements_nickel_ingot.png eeeedd
elements_niobium_ingot.png fefefe
elements_palladium_ingot.png fefefe
elements_rhenium_ingot.png 4444dd
elements_rhodium_ingot.png dd4444
elements_ruthenium_ingot.png 555555
elements_scandium_ingot.png 555544
elements_tantalum_ingot.png 555566
elements_technetium_ingot.png 884424
elements_tellurium_ingot.png aeaeae
elements_thallium_ingot.png bebebe
elements_tungsten_ingot.png decece
elements_vanadium_ingot.png dedece
elements_yttrium_ingot.png ddddcf
elements_zirconium_ingot.png aabbcc
ethereal_crystal_ingot.png 2468af
lavastuff_ingot.png af2428
technic_brass_ingot.png af9875

)

for x in ${(k)ele}; do

y="$(hex2dec3 $ele[$x])"
convert ingot_base.png -colorize "$y" $x

done