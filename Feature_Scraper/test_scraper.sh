output=$(python3 run.py usyd-10a 6r7mYcxLHXLq8Rgu url_config.json)

echo "BMC: "
if [[ "$output" =~ .*"BMC".* ]]; 
then
    echo "Catch BMC keyword successfully"
    not_found_bmc=false
    for element in CPU_FAN CPU_OPT CPU_ECC Memory_Train_ERR Watchdog2 +12V +3.3V +3.3V_ALW +5V +5V_ALW +CPU_1.8V +CPU_1.8V_S5 +CPU_3.3V +PCH_CLDO +VCORE +VDDIO_ABCD +VDDIO_EFGH +VSOC CHIPSET_FAN "CPU Temp." "LAN Temp." SOC_FAN VBAT
        do
            if [[ "$output" =~ .*"$element".* ]]; 
            then
                suc_message='Catch the info of '
                suc_message+="$element"
                suc_message+=" successfully"
                echo "$suc_message"
            else
                not_found_bmc=true
                failed_message="Failed to get the info of "
                failed_message+="$element"
                echo "$failed_message"
            fi
        done
    if [ "$not_found_bmc" = true ] ; 
    then
        echo 'Failed to catch all BMC info'
    else
        echo 'Catch all BMC info successfully'
    fi
else
    echo "Catch BMC keyword failed"
fi
echo " "

echo "GPU: "
if [[ "$output" =~ .*"GPU".* ]]; 
then
    echo "Catch GPU keyword successfully"
    if [[ "$output" =~ .*"GPU_count".* ]]; 
    then
        echo "Catch GPU_count keyword successfully"
        not_found_gpu=false
        for element in UUID BIOS Name Temperature totalMemory usedMemory freeMemory power limitPower minLimitPower maxLimitPower graphicsFrequency StreamingMultiprocessorFrequency memoryFrequency MaxgraphicsFrequency MaxStreamingMultiprocessorFrequency MaxmemoryFrequency fanSpeed
            do
                if [[ "$output" =~ .*"$element".* ]]; 
                then
                    suc_message='Catch the info of '
                    suc_message+="$element"
                    suc_message+=" successfully"
                    echo "$suc_message"
                else
                    not_found_gpu=true
                    failed_message="Failed to get the info of "
                    failed_message+="$element"
                    echo "$failed_message"
                fi
            done
        if [ "$not_found_gpu" = true ] ; 
        then
            echo 'Failed to catch all GPU info'
        else
            echo 'Catch all GPU info successfully'
        fi
    else
        echo "Catch GPU_count keyword failed"
    fi
else
    echo "Catch GPU keyword failed"
fi
echo "  "

echo "CPU: "
if [[ "$output" =~ .*"CPU".* ]]; 
then
    echo "Catch CPU keyword successfully"
    if [[ "$output" =~ .*"cpu_freq".* ]]; 
    then
        echo "Catch cpu_freq keyword successfully"
        not_found_cpu=false
        for element in cpu_current_freq cpu_min_freq cpu_max_freq
            do
                if [[ "$output" =~ .*"$element".* ]]; 
                then
                    suc_message='Catch the info of '
                    suc_message+="$element"
                    suc_message+=" successfully"
                    echo "$suc_message"
                else
                    not_found_cpu=true
                    failed_message="Failed to get the info of "
                    failed_message+="$element"
                    echo "$failed_message"
                fi
            done
        if [ "$not_found_cpu" = true ] ; 
        then
            echo 'Failed to catch all CPU info'
        else
            echo 'Catch all CPU info successfully'
        fi
    else
        echo "Catch cpu_freq keyword failed"
    fi
else
    echo "Catch CPU keyword failed"
fi
echo " "

echo "BIOS: "
if [[ "$output" =~ .*"BIOS".* ]]; 
then
    echo "Catch BIOS keyword successfully"
    if [[ "$output" =~ .*"baseboard-serial-number".* ]]; 
    then
        echo "Catch baseboard-serial-number successfully"
    else
        echo "Catch baseboard-serial-number failed"
    fi
    if [[ "$output" =~ .*"On Board Devices".* ]]; 
    then
        echo "Catch On_Board_Devices keyword successfully"
        not_found_devices=false
        for element in Type Status Description
            do
                if [[ "$output" =~ .*"$element".* ]]; 
                then
                    suc_message='Catch the device info of '
                    suc_message+="$element"
                    suc_message+=" successfully"
                    echo "$suc_message"
                else
                    not_found_devices=true
                    failed_message="Failed to get the device info of "
                    failed_message+="$element"
                    echo "$failed_message"
                fi
            done
        if [ "$not_found_devices" = true ] ; 
        then
            echo 'Failed to catch all devices info'
        else
            echo 'Catch all devices info successfully'
        fi
    else
        echo "Catch On_Board_Devices keyword failed"
    fi
    if [[ "$output" =~ .*"PCIe information".* ]]; 
    then
        echo "Catch PCIe_information keyword successfully"
        not_found_PCIe=false
        for element in Designation Type "Current Usage" Length ID Characteristics "Bus Address"
            do
                if [[ "$output" =~ .*"$element".* ]]; 
                then
                    suc_message='Catch the PCIe info of '
                    suc_message+="$element"
                    suc_message+=" successfully"
                    echo "$suc_message"
                else
                    not_found_PCIe=true
                    failed_message="Failed to get the PCIe info of "
                    failed_message+="$element"
                    echo "$failed_message"
                fi
            done
        if [ "$not_found_PCIe" = true ] ; 
        then
            echo 'Failed to catch all PCIe info'
        else
            echo 'Catch all PCIe info successfully'
        fi
    else
        echo "Catch PCIe_information keyword failed"
    fi
else
    echo "Catch BIOS keyword failed"
fi
echo " "




