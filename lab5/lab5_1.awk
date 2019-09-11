BEGIN{udpRec = 0; udpDrop = 0}
{
temp = $0
if ($1 == "r" && $5 == "cbr")
        {
                udpRec++;             
        }
else if ($1 == "d" && $5 == "cbr")
        {
                udpDrop++;
        }
}
END{
        printf("Number of packets received: %d\n", udpRec);
        printf("Number of packets dropped: %d\n", udpDrop);
}
