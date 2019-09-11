set ns [new Simulator]

set nf [open lab4_3.nam w]
$ns namtrace-all $nf

set nt [open lab4_3.tr w]
$ns trace-all $nt

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 1Mb 80ms DropTail
$ns duplex-link $n1 $n2 1Mb 80ms DropTail
$ns duplex-link $n2 $n3 1Mb 80ms DropTail

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

set null [new Agent/Null]
$ns attach-agent $n3 $null

$ns connect $tcp $sink
$ns connect $udp $null

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

proc finish {} {
	global ns nf nt
	$ns flush-trace
	close $nf 
	close $nt
	exec nam lab4_3.nam &
	exit 0
	}
$ns at 0.1ms "$ftp start"
$ns at 0.1ms "$cbr start"
$ns at 4ms "finish"
$ns run

