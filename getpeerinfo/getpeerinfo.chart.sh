# no need for shebang - this file is loaded from charts.d.plugin

# netdata
# real-time performance and health monitoring, done right!
# (C) 2016 Costa Tsaousis <costa@tsaousis.gr>
# GPL v3+
#

gridcoin_getpeerinfo_update_every=10
load_priority=2

# this is an example charts.d collector
# it is disabled by default.
# there is no point to enable it, since netdata already
# collects this information using its internal plugins.
gridcoin_getpeerinfo_enabled=1

gridcoin_getpeerinfo_check() {
	# this should return:
	#  - 0 to enable the chart
	#  - 1 to disable the chart

	if [ ${gridcoin_getpeerinfo_update_every} -lt 10 ]
		then
		# there is no meaning for shorter than 5 seconds
		# the kernel changes this value every 5 seconds
		gridcoin_getpeerinfo_update_every=10
	fi

	[ ${gridcoin_getpeerinfo_enabled} -eq 0 ] && return 1
	return 0
}

gridcoin_getpeerinfo_create() {
        # create a chart with 3 dimensions
cat <<EOF
CHART GRC.PeerVersions '' "Gridcoin difficulties" "difficulty" Difficulties gridcoin.difficulty line $((load_priority + 1)) $gridcoin_getpeerinfo_update_every
while read data
do
    currentLine="$data"
    stringarray=($currentLine)
    echo "DIMENSION ${stringarray[0]} '${stringarray[1]}' absolute 1 1"
done < peerinfo_versions.txt
EOF

        return 0
}

gridcoin_getpeerinfo_update() {
        # write the result of the work.
        cat <<VALUESEOF
BEGIN GRC.PeerVersions
do
    currentLine="$data"
    stringarray=($currentLine)
    echo "SET ${stringarray[0]} '${stringarray[2]}' absolute 1 1"
done < peerinfo_versions.txt
END
VALUESEOF

        return 0
}
