#!/bin/bash

#----------------------------------------------------------------------------------------------
# Functions
#----------------------------------------------------------------------------------------------

help()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "Syntax: bankScript [-h|f|A]"
   echo "options:"
   echo "h     Print this Help."
   echo "f     Mandatory: CSV file location."
   echo "A     Output all transactions."
   echo
}

aggregateCategories(){ 
# Read csv and throw away unnecessary lines, filter for specific transactions and sum together
RESULT=$(csvtool -t ';' -u ';' col 5,13 $FILE \
 | grep -i -E $CATEGORIES \
 | csvtool -t ';' -u ';' col 2 - | csvtool -t ';' -u ';' drop 1 - )

# read transactions to array
readarray -td ' ' a <<<"$RESULT"; declare -p a;
printf "transactions: \n${a[@]}"

# sum array entries
sum=0
for i in ${RESULT[@]}; do
  let sum+=$i
done
echo "Total for categories \"$CATEGORIES\": $sum€"
}

printAllTransactions(){
  echo $FILE
  # Cols: Buchungstag Valuta Textschl�ssel Primanota Zahlungsempf�nger Zahlungsempf�ngerKto Zahlungsempf�ngerIBAN Zahlungsempf�ngerBLZ Zahlungsempf�ngerBIC Vorgang/Verwendungszweck Kundenreferenz W�hrung Umsatz Soll/Haben
  csvtool -t ';' -u '|' col 1,5,13,14 $FILE | column -t -s '|'
}

#----------------------------------------------------------------------------------------------
# Variables/Params/Flags
#----------------------------------------------------------------------------------------------
printAll=false
# categories to aggregate
CATEGORIES="edeka|sandpassage|aldi|rewe|penny|baeckerei|famila|back|harms|kiebitzmarkt|baumarkt|toom|hornbach|bauhaus|biomarkt|denns|kaufland|drogerie"

# Get the options
while getopts ":hf:Ac:" option; do
   case $option in
      h) # display Help
         help
         exit;;
      f)
        FILE=$OPTARG;;
      c)
        CATEGORIES=$OPTARG;;
      A) # print all transactions
         printAll=true;;
      \?) # Invalid option
         echo "Error: Invalid option"
         help
         exit 1;;
   esac
done

#----------------------------------------------------------------------------------------------
# Main
#----------------------------------------------------------------------------------------------
if $printAll; then
  printAllTransactions
else
  aggregateCategories
fi
