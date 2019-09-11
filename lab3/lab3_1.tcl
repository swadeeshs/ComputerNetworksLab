set ns [new Simulator]
set nf [open lab3_1.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 1Mb 8ms DropTail
$ns duplex-link $n1 $n2 1Mb 8ms DropTail

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf 
	exec nam lab3_1.nam &
	exit 0
	}
$ns at 0.1ms "$ftp start"
$ns at 4ms "finish"
$ns run

