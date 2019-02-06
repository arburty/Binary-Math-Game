#! /bin/bash

declare -r PROGRAM=$(basename $0)
# declare arg for one line initialization of byteLength
arg="$1"
declare -r let byteLength=$(( $(( arg > 2 )) ? arg : 4 ))

die() {
    echo "ERROR: $PROGRAM: Line $BASH_LINENO: $*" 1>&2
    exit 1
}

get_random() {
    seconds=$(date +%s)
    rndm=$(($seconds/$RANDOM%2))
    echo -n $rndm
}

buildBytes() {
    str=""
    for ((  i=0; i<$byteLength; i++ ))
    do
        str="$str"$(get_random)
    done
    echo $str
}
getValue() {
    [[ ! -z "$1" ]] || die "getValue() needs an argument of a binary string"

    let total=0
    while read byte
    do
        total=$(($total*2))
        if [[ $byte == "1" ]]
        then
            total=$(($total+1))
        fi
    done < <(grep -o . <<< $1)
    echo "$total"
}

spacing() {
    [[ ! -z $1 ]] || { die "spacing() needs an argument"; }

    str=""
    num=$(echo -n $1 | wc -c | tr -d '[:blank:]')
    for (( i=0; i<=$num; i++ ))
    do
        str+=" "
    done
    echo "$str"
}

play() {
    correct=0
    wrong=0
    counter=0
    while true
    do
        ((counter++))
        bytes=$(buildBytes)
        value=$(getValue $bytes)
        echo "$counter: $bytes"
        spaces=$(spacing "$counter;")
        echo -n "$spaces"
        read input
        if [[ $input == "q" ]]; then
            echo "Thanks for playing!  you got $correct correct and $wrong wrong."
            exit 1
        elif [[ $input -eq $value ]]
        then
            echo "$spaces""NICE!"
            ((correct++))
        else
            echo "$spaces""WRONG $bytes: $value"
            ((wrong++))
        fi
    done
}

main() {
    read input
    if [[ $input == "n" ]]; then
        echo "Welp. Bye then"
    elif [[ $input == "y" ]]
    then
        echo "Good Luck! Enter 'q' to quit"
        play
    else
        echo "-- Must press 'y' or 'n' --"
        main
    fi
}

echo "Welcome! See how many binary strings you can correctly value."
echo "Are you ready to play? (y or n)"
main

exit 0
