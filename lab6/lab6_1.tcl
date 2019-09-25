set ns [new Simulator]

set nf [open lab6_1.nam w]
$ns namtrace-all $nf

set nt [open lab6_1.tr w]
$ns trace-all $nt

$ns color 1 Green

for {set i 0} {$i < 6} {incr i 1} {
    set n($i) [$ns node]
}

$ns duplex-link $n(0) $n(2) 2Mb 4ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 4ms DropTail
$ns duplex-link $n(2) $n(3) 2Mb 4ms DropTail


set lan [$ns newLan "$n(3) $n(4) $n(5)" 2Mb 40ms LL Queue/DropTail MAC/802_3 Channel]

set err [new ErrorModel]
$err set rate_ 0.1 $n(3) $n(4)

set tcp [new Agent/TCP]
$ns attach-agent $n(0) $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n(4) $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$tcp set fid_ 1

proc finish {} {
    global ns nf nt 
    $ns flush-trace
    close $nf
    close $nt
    exec nam lab6_1.nam &
    exit 0 
}

$ns at 0.1ms "$ftp start"
$ns at 4ms "finish"
$ns run