asm_calc
========

Simple calculator for windows completely programmed in x86 assembly!

I have just found this little calculator I did a while back in my old
backup folder. It is all written in x86 assembly and it uses plain
Windows APIs to create and manage a window.

You need to have [masm32](http://www.masm32.com/) to build this (build script is included).

Math is limited to -65535 to +65535 because I used 16 bit division
to perform number to string conversion but 32 bit registers are used
everywhere else, that is why such an unconventional range :)
