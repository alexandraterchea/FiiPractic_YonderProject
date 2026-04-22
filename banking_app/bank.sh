#!/bin/bash

FILE="bank.csv"
H_FILE="history.csv"
MINIMUM_SOLD=0

if [ ! -f "$FILE" ]; then
    echo "Nume, Prenume, Sold curent" > "$FILE"
fi

if [ ! -f "$H_FILE" ]; then
    echo "Client, Tip Operatiune, Suma, Sold dupa operatiune, Data/Ora" > "$H_FILE"
fi


valid_name()
{
    name="$1"
    if [[ -z "$name" ]]; then
        echo "Numele nu poate fi gol. Va rugam introduceti un nume valid"
        return 1
    fi
    if [[ ! "$name" =~ ^[a-zA-Z]+$ ]]; then 
        echo "Numele trebuie sa contina doar litere. Va rugam introduceti un nume valid"
        return 1
    fi
    return 0

}

add_history()
{ 
    client="$1"
    type="$2"
    amount="$3"
    new_sold="$4"
    time=$(date +"%d-%m-%Y %H:%M:%S")
    echo "$client, $type, $amount, $new_sold, $time" >> "$H_FILE"
}
while true; do 
    echo "MENIU BANCAR"
    echo "1.Adauga client"
    echo "2.Afiseaza clienti"
    echo "3.Depunere"
    echo "4.Retragere"
    echo "5.Sterge client"
    echo "6.Istoric tranzactii"
    echo "7.Iesire"
    read -p "Va rugam selectati o optiune:" option 

    case $option in 
        1)
            read -p "Introduceti numele noului client:" last_name
            read -p "Introduceti prenumele noului client:" first_name

            valid_name "$last_name" || continue
            valid_name "$first_name" || continue

            if grep -q "$last_name, $first_name" "$FILE"; then
                echo "Clientul $last_name, $first_name exista deja"
            else
                echo "$last_name, $first_name, 0" >> "$FILE"
                add_history "$last_name, $first_name" "Adaugare client" "0" "0"
                echo "Clientul $last_name, $first_name a fost adaugat cu succes"
            fi
            ;;
        2)
            echo "Lista clientilor:"
            cat "$FILE"
            ;;
        3)
            read -p "Introduceti numele clientului:" last_name
            read -p "Introduceti prenumele clientului:" first_name 

            valid_name "$last_name" || continue
            valid_name "$first_name" || continue

            if grep -q "$last_name, $first_name" "$FILE"; then 
                read -p "Introduceti suma de depus pentru clientul $last_name, $first_name:" sold_to_add
                    if ! [[ "$sold_to_add" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
                        echo "Valoare invalida pentru sold, vrugam sa introduceti un numar valid"
                    else 
                        current_sold=$(grep "$last_name, $first_name" "$FILE" | awk -F', ' '{print $3}')
                        new_sold=$(echo "$current_sold + $sold_to_add")
                        grep -v "$last_name, $first_name" "$FILE" > temporary.csv  
                        echo "$last_name, $first_name, $new_sold" >> temporary.csv
                        mv temporary.csv "$FILE"
                        add_history "$last_name, $first_name" "Depunere" "$sold_to_add" "$new_sold"
                        echo "Soldul pentru clientul $last_name, $first_name a fost actualizat la $new_sold"
                    fi
            else
                echo "Nu am putut gasi clientul $last_name, $first_name"
            fi
            ;;
        4) 
              read -p "Introduceti numele clientului:" last_name
            read -p "Introduceti prenumele clientului:" first_name 

            valid_name "$last_name" || continue
            valid_name "$first_name" || continue

            if grep -q "$last_name, $first_name" "$FILE"; then 
                read -p "Introduceti suma de retras pentru clientul $last_name, $first_name:" sold_to_add
                    if ! [[ "$sold_to_add" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
                        echo "Valoare invalida pentru sold, vrugam sa introduceti un numar valid"
                    else 
                        current_sold=$(grep "$last_name, $first_name" "$FILE" | awk -F', ' '{print $3}')
                        new_sold=$(echo "$current_sold - $sold_to_add")
                        if (( $(echo "$new_sold < $MINIMUM_SOLD" | bc -l) )); then
                            echo "Fonduri insuficimente. Sold curent: $current_sold, Suma incercata: $sold_to_add"
                            
                        else
                            grep -v "$last_name, $first_name" "$FILE" > temporary.csv  
                            echo "$last_name, $first_name, $new_sold" >> temporary.csv
                            mv temporary.csv "$FILE"
                            add_history "$last_name, $first_name" "Retragere" "$sold_to_add" "$new_sold"
                            echo "Soldul pentru clientul $last_name, $first_name a fost actualizat la $new_sold"
                        fi
                    fi
            else
                echo "Nu am putut gasi clientul $last_name, $first_name"
            fi
            ;;
        5)
            read -p "Introduceti numele clientului pe care doriti sa-l stergeti:" last_name
            read -p "Introduceti prenumele clientului pe care doriti sa-l stergeti:" first_name 

            valid_name "$last_name" || continue
            valid_name "$first_name" || continue

            if grep -q "$last_name, $first_name" "$FILE"; then 
               grep -v "$last_name, $first_name" "$FILE" > temporary.csv
                mv temporary.csv "$FILE"
                add_history "$last_name, $first_name" "Stergere client" "0" "0"
                echo "Clientul $last_name, $first_name a fost sters cu succes"
            else 
                echo "Nu am putut gasi clientul $last_name, $first_name"
            fi
            ;;

        6) echo "1.Istoric toti clientii:"
           echo "2.Istoric client specific"
           read -p "Selectati o optiune:" history_option
           case $history_option in
            1) echo "Istoric tranzactii pentru toti clientii:"
               cat "$H_FILE"
               ;;
            2) read -p "Introduceti numele clientului:" last_name
               read -p "Introduceti prenumele clientului:" first_name

                valid_name "$last_name" || continue
                valid_name "$first_name" || continue
                echo "Istoric tranzactii pentru clientul $last_name, $first_name:"
                grep "$last_name, $first_name" "$H_FILE"
               ;;
            *) echo "Optiune invalida. Va rugam selectati o optiune intre 1 si 2"
               ;;
           esac
            ;;

        7)
            echo "La revedere!"
            exit 0
            ;;
        *) 
            echo "Optiune invalida. Va rugam selectati o optiune intre 1 si 7"
            ;;
    esac
done
             
