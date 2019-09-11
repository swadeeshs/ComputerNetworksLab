BEGIN{tcp=0;ack=0;tcpDrop=0;ackDrop=0}
{
if ($1 == "r" && $5 == "tcp")
    {
        tcp++;
    }
else if ($1 == "r" && $5 == "ack")
    {
        ack++;
    }
else if ($1 == "d" && $5 == "tcp")
    {
        tcpDrop++;
    }
else if ($1 == "d" && $5 == "ack")
    {
        ackDrop++;
    }   
}
END{
    printf("TCP: %d\n", tcp);
    printf("ACK: %d\n", ack);
    printf("TCP Dropped: %d\n", tcpDrop);
    printf("ACK Dropped: %d\n", ackDrop);           
}    
