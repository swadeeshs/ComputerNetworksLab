BEGIN{tcp=0;ack=0;tcpDrop=0;ackDrop=0;udp=0;udpDrop=0}
{
if ($1 == "r" && $5 == "tcp")
    {
        tcp++;
    }
else if ($1 == "r" && $5 == "ack")
    {
        ack++;
    }
else if ($1 == "r" && $5 == "cbr")
    {
        udp++;
    }    
else if ($1 == "d" && $5 == "tcp")
    {
        tcpDrop++;
    }
else if ($1 == "d" && $5 == "ack")
    {
        ackDrop++;
    }  
else if ($1 == "d" && $5 == "cbr")
    {
        udpDrop++;
    }     
}
END{
    printf("TCP Received: %d\n", tcp);
    printf("TCP Dropped: %d\n", tcpDrop);
    printf("UDP Received: %d\n", udp);    
    printf("UDP Dropped: %d\n", udpDrop);    
    printf("ACK: %d\n", ack);
    printf("ACK Dropped: %d\n", ackDrop);           
}    
