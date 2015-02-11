BEGIN{
	total;			  # total no. of packets from all the sources
	total117=0;		  # total no. of packets from node 1 to node 17
	total312=0;		  # total no. of packets from node 3 to node 12	
	total516=0;		  # total no. of packets from node 5 to node 16
	total147=0;		  # total no. of packets from node 14 to node 7
	total152=0;		  # total no. of packets from node 15 to node 2
	total184=0;		  # total no. of packets from node 18 to node 4
	hpktid = 0;		  # highest packet id
	disp=1;
	tdelay=0.0;		  # total delay for a packet
	packet_duration=0;	  # duration for packet to reach to its destination
	avg_delay=0;	       	  # average delay for a packet
	maxdelay=0;		  # maximum delay for a packet
	mindelay=60;	 	  # minimum amount of delay.
	dropped=0;	 	  # total no of packets that are dropped.
	sir=0;			  # It is sustained information rate i.e no of bits transmitted per second.
	packet=0;
	sent=0;
	rec=0;

	delay_diff = 0;		  # difference between consecutive delays
	last_seqno = 0;		  # last sequence no. thata is used.
	last_delay = 0;		  # delay of the last packet
	seqno_diff = 0;		  # difference between sequence no.
	total_jitter=0;		  # total jitter
}
{	action=$1;	
	time=$2;
	from=$3;
	to=$4;
	type=$5;
	pktsize=$6;
	flow_id=$8;
	src=$9;
	dst=$10;
	seq_no=$11;
	packet_id=$12;

# for calculating total no of packets
	if(action=="r" && from==13 && to==17 )
		total117++;
	if(action=="r" &&  from==11 && to==12 )
		total312++;
	if(action=="r" &&  from==13 && to==16 )
		total516++;
	if(action=="r" &&  from==10 && to==7 )
		total147++;
	if(action=="r" &&  from==0 && to==2 )
		total152++;
	if(action=="r" &&  from==0 && to==4 )
		total184++;
	total=total117+total312+total516+total147+total152+total184;

	if(action=="d")
		dropped++;

#	if (action=="-" && (from==1 || from==3 || from==5 || from==14 || from==15 || from==17 ))
#		sent++;

# for calculating highest no of packet from all source and time for each packet
	if(packet_id>hpkid)
		hpkid=packet_id;
	if(start_time[packet_id]==0.0)
	{	start_time[packet_id] = time;
		pkt_seqno[packet_id] = seq_no;
	}
	if(action!="d") 
	{
		if (action=="r" && from==13 && to==17) 
		{	
			rec++;
			end_time[packet_id]=time;
		}
		else if (action=="r" && from==11 && to==12 )
		{
			rec++;
			end_time[packet_id]=time;
		}
		else if (action=="r" && from==13 && to==16 )
		{
			rec++;
			end_time[packet_id]=time;
		}
		else if (action=="r" && from==10 && to==7 )
		{
			rec++;
			end_time[packet_id]=time;
		}
		else if (action=="r" && from==0 && to==2 )
		{
			rec++;
			end_time[packet_id]=time;
		}
		else if (action=="r" && from==0 && to==4 )
		{
			rec++;
			end_time[packet_id]=time;
		}

	}
	else
	{
		end_time[packet_id]=-1;
	}
}
END{
	if(disp)
	{	for(packet_id=0;packet_id<=hpkid;packet_id++)
		{
			start=start_time[packet_id];
			end=end_time[packet_id];
			packet_duration = end - start;
			if(packet_duration<0)
				packet_duration=-1*packet_duration;
			tdelay=tdelay+packet_duration;			
			#printf("\tet:%f %f\n",packet_duration,tdelay);
			
			if(packet_duration>maxdelay)
				maxdelay=packet_duration;
			if(mindelay>packet_duration)
				mindelay=packet_duration;
			if (start<end) 
			{	#printf("%d %f\n",packet_id,packet_duration);
				if(pkt_seqno[packet_id]>=0)				
					seqno_diff = pkt_seqno[packet_id] - last_seqno;
				else
					seqno_diff=0;
				delay_diff = packet_duration - last_delay;
				if (seqno_diff == 0) 
				{
					jitter =0;
				}
				else
				{
				jitter = delay_diff/seqno_diff;
				total_jitter+=jitter;
				}
				last_seqno = pkt_seqno[packet_id];
				last_delay = packet_duration;
			}
		}
		avg_delay=tdelay/total;
		sir=hpkid*200*8/60;

		# Packet information as:
		printf("***********The packets Information**************\n");
		printf("The total number of packets communicated between 1 and 17 are: %d\n",total117);
		printf("The total number of packets communicated between 3 and 12 are: %d\n",total312);
		printf("The total number of packets communicated between 5 and 16 are: %d\n",total516);
		printf("The total number of packets communicated between 14 and 7 are: %d\n",total147);
		printf("The total number of packets communicated between 15 and 2 are: %d\n",total152);
		printf("The total number of packets communicated between 18 and 4 are: %d\n",total184);
		printf("The total number of packets communicated are: %d\n\n",total);

		# all the delays are as:
		printf("***********Packet Delay Information**************\n")
		printf("The avg delay is: %f\nThe Max Delay is: %f\nThe Min Delay is: %f\n\n",avg_delay,maxdelay,mindelay);

		# Sustained Information Rate is:
		printf("***********Sustained Information Rate**************\n")
		printf("SIR: %f bits/second\n\n",sir);

		# coefficient of variation is:
		printf("***********COV Information**************\n")
		printf("The Coeff of Variation is %f\n\n", total_jitter/avg_delay); 

		# packet drop rate is:
		printf("***********Packet Drop Information**************\n")
		sent=dropped+rec;
		rate=(dropped/sent)*100;
		printf("Number of packets sent are :%d and lost(dropped) are :%d\n", sent, dropped);
		printf("The packet drop rate is : %.2f%\n\n",rate);

		# Loss rate is:
		printf("***********Packet Loss Rate Information**************\n")
		rate1=dropped/60;
		printf("The loss rate(no of packet dropped per simultion time) is : %.2f\n\n",rate1);

		# Throughput for the above network is:
		printf("***********Throughput Information**************\n")
		rate2=(rec/hpkid)*100;
		printf("The throughput for the above network is: %.2f%\n\n",rate2);
	}
	
}
