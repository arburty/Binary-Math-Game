#! /bin/bash

declare -r PROGRAM=$(basename $0)

USAGE() {
    echo "ERROR: $PROGRAM: I don't know how but you mucked up"
    exit 1
}

get_random() {
    seconds=$(date +%s)
    rndm=$(($seconds/$RANDOM%2))
    echo -n $rndm
}

build4() {
    str=""
    for i in {1..4}
    do
        str="$str"$(get_random)
    done
    echo $str
}
getValue() {
    if [[ -z "$1" ]]; then
        USAGE
    fi

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

play() {
    correct=0
    wrong=0
    while true
    do
        bytes=$(build4)
        value=$(getValue $bytes)
        echo "$bytes"
        read input
        if [[ $input == "q" ]]; then
            echo "Thanks for playing!  you got $correct correct and $wrong wrong."
            exit 1
        elif [[ $input -eq $value ]]
        then
            echo "NICE!"
            ((correct++))
        else
            echo "Sorry, its actually $value"
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
