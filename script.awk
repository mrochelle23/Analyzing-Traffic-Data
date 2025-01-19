#! /usr/bin/env gawk -f

BEGIN {
    FS = ","  # Set the field separator to comma
    # Initialize counters
    total_accidents = 0
    multi_vehicle_accidents = 0
    jan_feb_accidents = 0
    mi_accidents = 0
    mi_multi_vehicle_accidents = 0
    mi_jan_feb_accidents = 0
}

# Process each row (skip header row)
NR > 1 {
    total_accidents++

    # Proportion of Multiple Vehicles (VE_TOTAL >= 2)
    if ($3 ~ /^[2-9][0-9]*$/) {
        multi_vehicle_accidents++
    }

    # Accidents in January or February (MONTH == 1 or 2)
    if ($13 ~ /^(1|2)$/) {
        jan_feb_accidents++
    }

    # MI-specific accidents
    if ($1 == "26") {
        mi_accidents++

        # MI Multiple Vehicles
        if ($3 ~ /^[2-9][0-9]*$/) {
            mi_multi_vehicle_accidents++
        }

        # MI January or February
        if ($13 ~ /^(1|2)$/) {
            mi_jan_feb_accidents++
        }
    }

    # Count drunk drivers by state (accumulate DRUNK_DR field by state)
    state = $1
    drunk_drivers[state] = drunk_drivers[state] + $52  # Simple addition
}

END {
    # Output proportions with commas
    print "Multiple Vehicles Proportion:", multi_vehicle_accidents / total_accidents
    print "Jan/Feb Proportion:", jan_feb_accidents / total_accidents

    # MI-specific proportions
    mi_multi_vehicle_proportion = mi_multi_vehicle_accidents / mi_accidents
    if (mi_multi_vehicle_proportion == int(mi_multi_vehicle_proportion)) {
        print "MI Multiple Vehicles Proportion:", int(mi_multi_vehicle_proportion)
    } else {
        print "MI Multiple Vehicles Proportion:", mi_multi_vehicle_proportion
    }

    mi_jan_feb_proportion = mi_jan_feb_accidents / mi_accidents
    if (mi_jan_feb_proportion == int(mi_jan_feb_proportion)) {
        print "MI Jan/Feb Proportion:", int(mi_jan_feb_proportion)
    } else {
        print "MI Jan/Feb Proportion:", mi_jan_feb_accidents / mi_accidents
    }

    # Output drunk drivers by state with commas
    print "State Code and Drunk Drivers Count:"
    for (state in drunk_drivers) {
        print state "," drunk_drivers[state]
    }
}

