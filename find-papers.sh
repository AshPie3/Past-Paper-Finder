#!/bin/bash
dir="."
browser=brave
num=-1
year=0
to_folder=0
while getopts "d:s:n:p:l:y:b:hc" flag
do
    case "${flag}" in
        h) echo "Find subject papers on IB DOCS repo! 
                -d: input directory (defaults to current) 
                -s*: Subject - 2 letter abriviation or full name
                -p*: paper - 1, 2 or 3
                -l*: level - HL or SL
                -n: number of papers to open (defaults to all)
                -y: specify exam year (defaults to all)
                -b: specify program used to open pdf files (defaults to brave)
                -c: no argument (copies the found files into a new directory)
                *required arguments"
                exit 1;;
        d) dir=${OPTARG};;
        s) case ${OPTARG^^} in
            CS) subject="computer*science";;
            MA) subject="Mathematics*analysis*and*approaches";;
            MATH) subject="Mathematics*analysis*and*approaches";;
            MATHS) subject="Mathematics*analysis*and*approaches";;
            MATHEMATICS) subject="Mathematics*analysis*and*approaches";;
            PS) subject="Psychology";;
            PSYCH) subject="Psychology";;
            PSYCHOLOGY) subject="Psychology";;
            EN) subject="English*A*Literature";;
            ENG) subject="English*A*Literature";;
            ENGLISH) subject="English*A*Literature";;
            GE) subject="German*ab*initio";;
            GERMAN) subject="German*ab*initio";;
            PH) subject="Physics";;
            PHYSICS) subject="Physics";;
        esac ;;
        p) case ${OPTARG} in
            1) paper="paper_1";;
            2) paper="paper_2";;
            3) paper="paper_3";;
        esac ;;
        l) level=${OPTARG};;
        n) num=${OPTARG};;
        y) year=${OPTARG};;
        b) browser=${OPTARG};;
        c) to_folder=1;;
    esac
done
find_var="${subject}*${paper}*${level}"
if [ ${year} == 0 ]; then
    readarray -d '' arr < <( find "$dir" -iname "${find_var}.pdf" -print0 -or -iname "${find_var}*markscheme.pdf" -print0 )
    folder_name="${subject}_${paper}_${level}"
else
    readarray -d '' arr < <( find "$dir" -path "*${year}*" -iname "${find_var}.pdf" -print0 -or -path "*${year}*" -iname "${find_var}*markscheme.pdf" -print0 )
    folder_name="${subject}_${paper}_${level}_${year}"
fi
if [ $num == -1 ]; then 
    num=${#arr[@]}
fi
if [ $to_folder == 1 ]; then
    mkdir "${folder_name}"
else 
    $browser & disown
fi 
for (( i = 0; i < $num ; i++))
do 
    if [ $to_folder == 1 ]; then
        cp "${arr[$i]}" "${folder_name}"
        mv "${folder_name}/${arr[$i]}" "${arr[$i]}_${i}"
    else
        $browser "${arr[$i]}"
    fi
    echo "File path: ${arr[$i]}"

done 
