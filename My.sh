#!/bin/bash

# Function to display the top 10 applications consuming the most CPU and memory
function top_apps {
    echo "Top 10 Applications by CPU and Memory Usage:"
    ps aux --sort=-%cpu,-%mem | awk 'NR<=10 {printf "%-8s %-8s %-8s %-8s %-8s %s\n", $1, $2, $3, $4, $11, $12}'
}

# Function to monitor network connections and traffic
function network_monitor {
    echo "Network Monitoring:"
    echo "Concurrent Connections:"
    ss -s | grep estab
    echo "Packet Drops:"
    netstat -s | grep "packet receive errors"
    echo "Network Traffic (MB in/out):"
    ifstat -i eth0 1 1 | awk 'NR==3 {print "In: " $6 "MB, Out: " $8 "MB"}'
}

# Function to display disk usage
function disk_usage {
    echo "Disk Usage by Mounted Partitions:"
    df -h | awk '$5 >= 80 {print "Warning: Partition " $1 " is using " $5 " of disk space."} {print $0}'
}

# Function to show the system load
function system_load {
    echo "System Load:"
    echo "Load Average:"
    uptime
    echo "CPU Usage Breakdown:"
    mpstat | grep all | awk '{printf "User: %.2f%%\nSystem: %.2f%%\nIdle: %.2f%%\n", $3+$4, $5, $12}'
}

# Function to display memory usage
function memory_usage {
    echo "Memory Usage:"
    free -h
    echo "Swap Usage:"
    swapon --show
}

# Function to monitor processes
function process_monitor {
    echo "Process Monitoring:"
    echo "Number of Active Processes:"
    ps -e | wc -l
    echo "Top 5 Processes by CPU and Memory Usage:"
    ps aux --sort=-%cpu,-%mem | head -6 | tail -5
}

# Function to monitor essential services
function service_monitor {
    echo "Service Monitoring:"
    for service in sshd nginx apache2 iptables; do
        systemctl is-active --quiet $service && echo "$service is running" || echo "$service is not running"
    done
}

# Display the custom dashboard based on command-line switches
case $1 in
    -cpu)
        top_apps
        system_load
        ;;
    -memory)
        memory_usage
        ;;
    -network)
        network_monitor
        ;;
    -disk)
        disk_usage
        ;;
    -process)
        process_monitor
        ;;
    -service)
        service_monitor
        ;;
    -all|*)
        top_apps
        network_monitor
        disk_usage
        system_load
        memory_usage
        process_monitor
        service_monitor
        ;;
esac
