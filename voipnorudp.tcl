# voip.tcl

# Setup simulator object
set ns [new Simulator -multicast on]

# Enable multicast
$ns multicast

# Open file for simulation
set nf [open outnudp.nam w]
$ns namtrace-all $nf

# Open file for plotting graphs
set f1 [open trackudp.tr w]
$ns trace-all $f1
 
proc finish {} {
    global ns nf f1
    $ns flush-trace
    
    # Close files
    close $nf    
    close $f1 
 
 #   exec xgraph track.tr -t "Simulation 1" -0 "Stream 1" -geometry 800x400 &
    exec nam outnudp.nam &
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

# Setup UDP source agents
set udp1 [new Agent/UDP]
set udp3 [new Agent/UDP]
set udp5 [new Agent/UDP]
set udp14 [new Agent/UDP]
set udp15 [new Agent/UDP]
set udp18 [new Agent/UDP]

# Setup UDP sinks
set udp2 [new Agent/Null]
set udp4 [new Agent/Null]
set udp7 [new Agent/Null]
set udp12 [new Agent/Null]
set udp16 [new Agent/Null]
set udp17 [new Agent/Null]

# Attach agents to respective source nodes
$ns attach-agent $n(1) $udp1
$ns attach-agent $n(3) $udp3
$ns attach-agent $n(5) $udp5
$ns attach-agent $n(14) $udp14
$ns attach-agent $n(15) $udp15
$ns attach-agent $n(18) $udp18

# Attach agents to respective destination nodes
$ns attach-agent $n(2) $udp2
$ns attach-agent $n(4) $udp4
$ns attach-agent $n(7) $udp7
$ns attach-agent $n(12) $udp12
$ns attach-agent $n(16) $udp16
$ns attach-agent $n(17) $udp17

# Setting node 1 paramaters 
$udp1 set packetSize_ 200
$udp1 set interval_ 2ms
$udp1 set fid_ 1
$udp1 set class_ 1

# Setup CBR on UDP1
set voip1 [new Application/Traffic/CBR]
$voip1 set packet_size_ 160
$voip1 set rate 640Kb
$voip1 set interval_ 2ms
$voip1 attach-agent $udp1

# connecting udp1 with the respective destination 17
$ns connect $udp1 $udp17

# Setting node 3 paramaters 
$udp3 set packetSize_ 200
$udp3 set interval_ 2ms
$udp3 set fid_ 2
$udp3 set class_ 2

# Setup CBR on UDP3
set voip3 [new Application/Traffic/CBR]
$voip3 set packet_size_ 160
$voip3 set rate 640Kb				
$voip3 set interval_ 2ms
$voip3 attach-agent $udp3

# connecting udp3 with the respective destination 12
$ns connect $udp3 $udp12

# Setting node 5 paramaters 
$udp5 set packetSize_ 200
$udp5 set interval_ 2ms
$udp5 set fid_ 3
$udp5 set class_ 3

# Setup CBR on UDP5
set voip5 [new Application/Traffic/CBR]
$voip5 set packet_size_ 160
$voip5 set rate 640Kb
$voip5 set interval_ 2ms
$voip5 attach-agent $udp5

# connecting udp5 with the respective destination 16
$ns connect $udp5 $udp16

# Setting node 14 paramaters 
$udp14 set packetSize_ 200
$udp14 set interval_ 2ms
$udp14 set fid_ 4
$udp14 set class_ 4

# Setup CBR on UDP14
set voip14 [new Application/Traffic/CBR]
$voip14 set packet_size_ 160
$voip14 set rate 640Kb
$voip14 set interval_ 2ms
$voip14 attach-agent $udp14

# connecting udp14 with the respective destination 7
$ns connect $udp14 $udp7

# Setting node 15 paramaters 
$udp15 set packetSize_ 200
$udp15 set interval_ 2ms
$udp15 set fid_ 5
$udp15 set class_ 5

# Setup CBR on UDP15
set voip15 [new Application/Traffic/CBR]
$voip15 set packet_size_ 160
$voip15 set rate 640Kb
$voip15 set interval_ 2ms
$voip15 attach-agent $udp15

# connecting udp15 with the respective destination 2
$ns connect $udp15 $udp2

# Setting node 18 paramaters 
$udp18 set packetSize_ 200
$udp18 set interval_ 2ms
$udp18 set fid_ 6
$udp18 set class_ 6

# Setup CBR on UDP18
set voip18 [new Application/Traffic/CBR]
$voip18 set packet_size_ 160
$voip18 set rate 640Kb
$voip18 set interval_ 2ms
$voip18 attach-agent $udp18

# connecting udp18 with the respective destination 4
$ns connect $udp18 $udp4

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


