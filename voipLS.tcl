# voip.tcl

# Setup simulator object
set ns [new Simulator -multicast on]

$ns rtproto LS

# Enable multicast
$ns multicast

# Open file for simulation
set nf [open outls.nam w]
$ns namtrace-all $nf

# Open file for plotting graphs
set f1 [open trackls.tr w]
$ns trace-all $f1
 
proc finish {} {
    global ns nf f1
    $ns flush-trace
    
    # Close files
    close $nf    
    close $f1 
 
 #   exec xgraph track.tr -t "Simulation 1" -0 "Stream 1" -geometry 800x400 &
    exec nam outls.nam &
    exit 0
}


set n(0) [$ns node]
set n(1) [$ns node]
set n(2) [$ns node]
set n(3) [$ns node]
set n(4) [$ns node]
set n(5) [$ns node]
set n(6) [$ns node]
set n(7) [$ns node]
set n(8) [$ns node]
set n(9) [$ns node]
set n(10) [$ns node]
set n(11) [$ns node]
set n(12) [$ns node]
set n(13) [$ns node]
set n(14) [$ns node]
set n(15) [$ns node]
set n(16) [$ns node]
set n(17) [$ns node]
set n(18) [$ns node]

# Color
$ns color 1 red
$ns color 2 Blue
$ns color 3 Green
$ns color 4 purple
$ns color 5 black
$ns color 6 orange

# Setup network topology: links
for {set i 1} {$i <= 5} {incr i} {
    $ns duplex-link $n($i) $n(0) 100Mb 10ms DropTail
}
$ns duplex-link $n(0) $n(6) 10Mb 5ms DropTail
$ns duplex-link $n(0) $n(7) 10Mb 5ms DropTail
$ns duplex-link $n(6) $n(9) 10Mb 5ms DropTail
$ns duplex-link $n(9) $n(11) 10Mb 5ms DropTail
$ns duplex-link $n(7) $n(10) 10Mb 5ms DropTail
$ns duplex-link $n(10) $n(11) 10Mb 5ms DropTail
$ns duplex-link $n(6) $n(8) 10Mb 5ms DropTail
$ns duplex-link $n(8) $n(9) 10Mb 5ms DropTail
$ns duplex-link $n(10) $n(9) 10Mb 5ms DropTail
$ns duplex-link $n(11) $n(13) 10Mb 5ms DropTail
$ns duplex-link $n(11) $n(12) 10Mb 5ms DropTail
$ns duplex-link $n(12) $n(13) 10Mb 5ms DropTail

for {set i 14} {$i <= 18} {incr i} {
    $ns duplex-link $n(13) $n($i) 100Mb 10ms DropTail
}

#Set Queue Size of link (n0-n6, n6-n11, n13-n16) to 10
$ns queue-limit $n(0) $n(6) 3
$ns queue-limit $n(0) $n(7) 1
$ns queue-limit $n(6) $n(9) 2
$ns queue-limit $n(9) $n(11) 2
$ns queue-limit $n(7) $n(10) 2
$ns queue-limit $n(11) $n(13) 2

# setting the orientation of the nodes
$ns duplex-link-op $n(0) $n(1) orient up
$ns duplex-link-op $n(0) $n(2) orient left-up
$ns duplex-link-op $n(0) $n(3) orient left
$ns duplex-link-op $n(0) $n(4) orient left-down
$ns duplex-link-op $n(0) $n(5) orient down
$ns duplex-link-op $n(0) $n(6) orient right
$ns duplex-link-op $n(0) $n(7) orient right-up
$ns duplex-link-op $n(6) $n(8) orient down
$ns duplex-link-op $n(6) $n(9) orient right
$ns duplex-link-op $n(7) $n(10) orient right
$ns duplex-link-op $n(8) $n(9) orient right-up
$ns duplex-link-op $n(9) $n(10) orient up
$ns duplex-link-op $n(9) $n(11) orient right
$ns duplex-link-op $n(10) $n(11) orient right-down
$ns duplex-link-op $n(11) $n(12) orient down
$ns duplex-link-op $n(11) $n(13) orient right
$ns duplex-link-op $n(12) $n(13) orient right-up
$ns duplex-link-op $n(13) $n(14) orient up
$ns duplex-link-op $n(13) $n(15) orient right-up
$ns duplex-link-op $n(13) $n(16) orient right
$ns duplex-link-op $n(13) $n(17) orient right-down
$ns duplex-link-op $n(13) $n(18) orient down


#Monitor the queue for link (n0-n1, n0-n6). (for NAM)
$ns duplex-link-op $n(0) $n(6) queuePos 0.1
$ns duplex-link-op $n(0) $n(7) queuePos 0.1
$ns duplex-link-op $n(6) $n(9) queuePos 0.1
$ns duplex-link-op $n(9) $n(11) queuePos 0.1
$ns duplex-link-op $n(7) $n(10) queuePos 0.1
$ns duplex-link-op $n(11) $n(13) queuePos 0.1



# Set multicast parameters
set mproto DM
set mrthandle [$ns mrtproto $mproto {}]

# Setup RTP source agents
set rtp1 [new Agent/RTP]
set rtp3 [new Agent/RTP]
set rtp5 [new Agent/RTP]
set rtp14 [new Agent/RTP]
set rtp15 [new Agent/RTP]
set rtp18 [new Agent/RTP]

# Setup RTP sinks
set rtp2 [new Agent/LossMonitor]
set rtp4 [new Agent/LossMonitor]
set rtp7 [new Agent/LossMonitor]
set rtp12 [new Agent/LossMonitor]
set rtp16 [new Agent/LossMonitor]
set rtp17 [new Agent/LossMonitor]

# Attach agents to respective source nodes
$ns attach-agent $n(1) $rtp1
$ns attach-agent $n(3) $rtp3
$ns attach-agent $n(5) $rtp5
$ns attach-agent $n(14) $rtp14
$ns attach-agent $n(15) $rtp15
$ns attach-agent $n(18) $rtp18

# Attach agents to respective destination nodes
$ns attach-agent $n(2) $rtp2
$ns attach-agent $n(4) $rtp4
$ns attach-agent $n(7) $rtp7
$ns attach-agent $n(12) $rtp12
$ns attach-agent $n(16) $rtp16
$ns attach-agent $n(17) $rtp17

# Setting node 1 paramaters 
$rtp1 set packetSize_ 200
$rtp1 set interval_ 2ms
$rtp1 set fid_ 1
$rtp1 set class_ 1

# Setup CBR on RTP1
set voip1 [new Application/Traffic/CBR]
$voip1 set packet_size_ 160
$voip1 set rate 640Kb
$voip1 set interval_ 2ms
$voip1 attach-agent $rtp1

# connecting rtp1 with the respective destination 17
$ns connect $rtp1 $rtp17

# Setting node 3 paramaters 
$rtp3 set packetSize_ 200
$rtp3 set interval_ 2ms
$rtp3 set fid_ 2
$rtp3 set class_ 2

# Setup CBR on RTP3
set voip3 [new Application/Traffic/CBR]
$voip3 set packet_size_ 160
$voip3 set rate 640Kb				#
$voip3 set interval_ 2ms
$voip3 attach-agent $rtp3

# connecting rtp3 with the respective destination 12
$ns connect $rtp3 $rtp12

# Setting node 5 paramaters 
$rtp5 set packetSize_ 200
$rtp5 set interval_ 2ms
$rtp5 set fid_ 3
$rtp5 set class_ 3

# Setup CBR on RTP5
set voip5 [new Application/Traffic/CBR]
$voip5 set packet_size_ 160
$voip5 set rate 640Kb
$voip5 set interval_ 2ms
$voip5 attach-agent $rtp5

# connecting rtp5 with the respective destination 16
$ns connect $rtp5 $rtp16

# Setting node 14 paramaters 
$rtp14 set packetSize_ 200
$rtp14 set interval_ 2ms
$rtp14 set fid_ 4
$rtp14 set class_ 4

# Setup CBR on RTP14
set voip14 [new Application/Traffic/CBR]
$voip14 set packet_size_ 160
$voip14 set rate 640Kb
$voip14 set interval_ 2ms
$voip14 attach-agent $rtp14

# connecting rtp14 with the respective destination 7
$ns connect $rtp14 $rtp7

# Setting node 15 paramaters 
$rtp15 set packetSize_ 200
$rtp15 set interval_ 2ms
$rtp15 set fid_ 5
$rtp15 set class_ 5

# Setup CBR on RTP15
set voip15 [new Application/Traffic/CBR]
$voip15 set packet_size_ 160
$voip15 set rate 640Kb
$voip15 set interval_ 2ms
$voip15 attach-agent $rtp15

# connecting rtp15 with the respective destination 2
$ns connect $rtp15 $rtp2

# Setting node 18 paramaters 
$rtp18 set packetSize_ 200
$rtp18 set interval_ 2ms
$rtp18 set fid_ 6
$rtp18 set class_ 6

# Setup CBR on RTP18
set voip18 [new Application/Traffic/CBR]
$voip18 set packet_size_ 160
$voip18 set rate 640Kb
$voip18 set interval_ 2ms
$voip18 attach-agent $rtp18

# connecting rtp18 with the respective destination 4
$ns connect $rtp18 $rtp4

# *** Run ***
# Strange... uncomment the following line will double the bandwidth!
$ns at 0.1 "$voip1 start"  
$ns at 0.2 "$voip3 start"  
$ns at 0.3 "$voip5 start"  
$ns at 0.4 "$voip14 start"  
$ns at 0.5 "$voip15 start"  
$ns at 0.6 "$voip18 start"  
$ns at 59 "$voip1 stop"  
$ns at 59.2 "$voip3 stop"  
$ns at 59.3 "$voip5 stop"
$ns at 59.35 "$voip14 stop"
$ns at 59.45 "$voip15 stop"
$ns at 59.6 "$voip18 stop"
$ns rtmodel-at 5.0 down $n(11) $n(10)
$ns rtmodel-at 7.0 up $n(11) $n(10)
$ns rtmodel-at 8.0 down $n(9) 
$ns rtmodel-at 12.0 up $n(9)

# *** Finish ***
$ns at 60 "finish"

$ns run


