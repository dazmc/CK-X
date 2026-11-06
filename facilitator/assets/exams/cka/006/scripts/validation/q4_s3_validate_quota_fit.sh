#!/bin/bash
READ=$(kubectl get pods -n resource-tuning -l app=web -o json 2>/dev/null | jq -r '
  [.items[] | select(.status.phase=="Running") | .spec.containers[]] |
  (map(.resources.requests.cpu // "0") |
     map(if endswith("m") then (rtrimstr("m")|tonumber) else (tonumber*1000) end) | add // 0) as $cpu |
  (map(.resources.requests.memory // "0") |
     map(if endswith("Gi") then (rtrimstr("Gi")|tonumber*1024)
         elif endswith("Mi") then (rtrimstr("Mi")|tonumber)
         elif endswith("G") then (rtrimstr("G")|tonumber*953.67431640625)
         elif endswith("M") then (rtrimstr("M")|tonumber*0.95367431640625)
         elif endswith("Ki") then (rtrimstr("Ki")|tonumber/1024)
         else (tonumber/1048576) end) | add // 0) as $mem |
  "\($cpu) \($mem)"')
CPU=$(echo "$READ" | awk '{print $1}')
MEM=$(echo "$READ" | awk '{print $2}')
OK=$(awk -v c="${CPU:-999999}" -v m="${MEM:-999999}" 'BEGIN{print (c<=1000 && m<=2048)?1:0}')
if [ "$OK" != "1" ]; then
  echo "Total requests are ${CPU}m CPU / ${MEM}Mi memory, must fit within 1000m CPU and 2048Mi memory"
  exit 1
fi
echo "Total requests ${CPU}m CPU / ${MEM}Mi memory fit within the quota"
exit 0
