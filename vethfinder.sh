# #!/bin/bash

# for container in $(docker ps -q); do
#     container_name=$(docker inspect --format='{{.Name}}' $container | sed 's;/;;')
#     iflink=$(docker exec -it $container bash -c 'cat /sys/class/net/eth0/iflink')
#     iflink=$(echo $iflink | tr -d '\r')
#     veth=$(grep -l $iflink /sys/class/net/veth*/ifindex)
#     veth=$(echo $veth | sed -e 's;^.*net/\(.*\)/ifindex$;\1;')
#     ip_addr=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)
#     echo "$container_name:$veth $ip_addr $container_name"
# done
#!/bin/bash

for container in $(docker ps -q); do
    container_name=$(docker inspect --format='{{.Name}}' $container | sed 's;/;;')
    ip_addr=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)

    for interface in $(docker exec $container ls /sys/class/net/); do
        iflink=$(docker exec -it $container bash -c "cat /sys/class/net/$interface/iflink")
        iflink=$(echo $iflink | tr -d '\r')
        veth=$(grep -l $iflink /sys/class/net/veth*/ifindex)
        veth=$(echo $veth | sed -e 's;^.*net/\(.*\)/ifindex$;\1;')
        echo "$container_name:$veth $ip_addr $container_name"
        done
done
