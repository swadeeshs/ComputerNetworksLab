set ns [new Simulator]

set nf [open lab6_2.nam w]
$ns namtrace-all $nf

set nt [open lab6_2.tr w]
$ns trace-all $nt

$ns color 1 Green
$ns color 2 Red

for {set i 0} {$i < 6} {incr i 1} {
    set n($i) [$ns node]
}

$ns duplex-link $n(0) $n(2) 2Mb 4ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 4ms DropTail
$ns duplex-link $n(2) $n(3) 2Mb 4ms DropTail

$ns queue-limit $n(2) $n(3) 20
$ns duplex-link-op $n(2) $n(3) queuePos 0.5

set lan [$ns newLan "$n(3) $n(4) $n(5)" 2Mb 40ms LL Queue/DropTail MAC/802_3 Channel]

set err [new ErrorModel]
$err ranvar [new RandomVariable/Uniform]
$err drop-target [new Agent/Null]
$ns lossmodel $err $n(2) $n(3)
#$err set rate_ 0.1 $n(3) $n(4)

set tcp [new Agent/TCP]
$ns attach-agent $n(0) $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n(4) $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set udp [new Agent/UDP]
$ns attach-agent $n(1) $udp

set null [new Agent/Null]
$ns attach-agent $n(5) $null

$ns connect $udp $null

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

$tcp set fid_ 1
$cbr set fid_ 2

proc finish {} {
    global ns nf nt 
    $ns flush-trace
    close $nf
    close $nt
    exec nam lab6_2.nam &
    set tcpSize [exec sh tcpSize.sh]
    set tcpCount [exec sh tcpCount.sh]
    set udpSize [exec sh udpSize.sh]
    set udpCount [exec sh udpCount.sh]
    set time_of_exec 124
    puts "Throughput of TCP is [expr $tcpSize * $tcpCount / $time_of_exec] bytes per sec |n]"
    puts "Throughput of UDP is [expr $udpSize * $udpCount / $time_of_exec] bytes per sec |n]"
    exit 0 
}

$ns at 0.0ms "$ftp start"
$ns at 0.0.ms "$cbr start"
$ns at 124ms "finish"
$ns run