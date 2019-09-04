#!/bin/bash
io_test() {
    (LANG=C dd if=/dev/zero of=test_$$ bs=8k count=30000 conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$3} END { print io}'
}

function detect_ioSpeed()
{

io_test>/dev/null

io1=$( io_test )
io2=$( io_test )
io3=$( io_test )
ioraw1=$( echo $io1 | awk 'NR==1 {print $1}' )
ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
ioall=$( awk 'BEGIN{print '$ioraw1' + '$ioraw2' + '$ioraw3'}' )
ioavg=$( awk 'BEGIN{printf "%.1f", '$ioall' / 3}' )
echo "$ioavg MB/s"
}
detect_ioSpeed
