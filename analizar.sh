#!/bin/sh
output1=disk-usage.out
output2=disk-usage-1.out
echo "-------------------- ------------------------- ------- ------- ------- -------" >> $output1
echo "HostName            Filesystem                Size Used Avail Use% MountedOn" >> $output1
echo "-------------------- ------------------------- ------- ------- ------- -------" >> $output1

for server in `more servidores.txt`
do
output=`ssh $server df -Ph | tail -n +2 | sed s/%//g | grep -v '^overlay' | grep -v '^/dev/loop' | awk '{ if($5 > 80) print $0;}'`
echo "$server: $output" >> $output2
done

cat $output2 | column -t >> $output1

fscount=$(< "$output1" wc -l)
if [ $fscount -ge 4 ]; then
cat $output1 | column -t
else
echo "Todos os servidores rodando corretamente"
fi
rm $output1 $output2
