set ns [new Simulator]

set nf [open lab5_1.nam w]
$ns namtrace-all $nf

set nt [open lab5_1.tr w]
$ns trace-all $nt

for {set i 0} {$i < 6} {incr i} {
    set n($i) [$ns node] 
}

$ns color 1 Red
$ns color 2 Green

for {set i 0 } {$i < 5} {incr i} {
    $ns duplex-link $n($i) $n([expr $i + 1]) 1Mb 10ms DropTail
}

$ns duplex-link $n(2) $n(4) 1Mb 10ms DropTail
$ns duplex-link $n(1) $n(5) 1Mb 10ms DropTail
$ns duplex-link $n(1) $n(4) 1Mb 10ms DropTail
$ns duplex-link $n(0) $n(5) 1Mb 10ms DropTail

$ns cost $n(0) $n(1) 5
$ns cost $n(5) $n(4) 3

set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set null0 [new Agent/Null]
$ns attach-agent $n(3) $null0 

$ns connect $udp0 $null0

set udp1 [new Agent/UDP]
$ns attach-agent $n(1) $udp1

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1

set null1 [new Agent/Null]
$ns attach-agent $n(3) $null1

$ns connect $udp1 $null1

$udp0 set fid_ 1
$udp1 set fid_ 2

$ns rtproto DV

$ns rtmodel-at 2.0 down $n(2) $n(3)
$ns rtmodel-at 2.8 down $n(1) $n(4)
$ns rtmodel-at 3.0 up $n(1) $n(4)
$ns rtmodel-at 3.5 up $n(2) $n(3)
$ns rtmodel-at 4.0 down $n(2) $n(3)
$ns rtmodel-at 4.0 down $n(2) $n(4)

proc finish {} {
    global ns nf nt
    $ns flush-trace
    close $nf
    close $nt
    exec nam lab5_1.nam &
    exit 0
}

$ns at 0.5 "$cbr0 start"
$ns at 1.0 "$cbr1 start"

$ns at 5.0 "finish"
$ns run