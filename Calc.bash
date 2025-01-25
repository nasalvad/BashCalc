echo $$ > tmppid
dir=`pwd`
#make sure that OPutput.txt is clean
> Output.txt

MyExit(){
  echo "MyExit \n"
  exit
}
Pres="n"
Calc() { 
# echo "Calc "
 # read operands and operator from Inst.txt file
#echo $dir
Instfile=$dir/Inst.txt
if ! test -r $Instfile
then
        echo "file missing: $Instfile"
	return
fi
#cat $Instfile
Tmp=$(awk ' { print $0 }' $Instfile)
Inst=(${Tmp[@]})
#echo ${Inst[@]}
op1=${Inst[0]}
oper=${Inst[1]}
operO=${Inst[2]}
#echo $op1 $oper $operO
op2=$(expr $op1 + 1)
#echo "op2 =  $op2"
if [[ $operO == "n" ]]
then
#echo "$Dsize $op1"
 if [[ $op1 -ge $Dsize || $op2 -ge $Dsize ]]
 then
  echo "Exceeded number of operands in CalcData.txt , need to reset pointer"
 return
 fi
x=${Data2[$op1]}
y=${Data2[$op2]}
#echo "x is equal to $x and y is equal to $y"
elif [[ $operO == "1" ]]
then
 if [[ $Pres == "n" ]]
  then
   echo "No previous response , make new selection with 'n' "
   return
 fi
 if [[ $op1 -ge $Dsize ]]
 then
  echo "Exceeded number of operands in CalcData.txt , need to reset pointer"
 return
 fi
#echo "last res = $res"
x=$res
y=${Data2[$op1]}
#echo "x = $x y = $y  oper0 = $oper1"
elif [[ $operO == "2" ]]
  then
 if [[ $Pres == "n" ]]
  then
   echo "No previous response , make new selection with 'n' "
   return
 fi 
 if [[ $op1 -ge $Dsize ]]
 then
  echo "Exceeded number of operands in CalcData.txt , need to reset pointer"
 return
 fi
#echo "last res = $res"
 y=$res
 x=${Data2[$op1]}
fi

if [[ $oper == "+" ]]
then
	res=$(expr $x + $y)	
#echo "$res" 	
elif [[ $oper == "-" ]]
then
	res=$(expr $x - $y)	
#echo "$res" 	
elif [[ $oper == "M" ]]
then
	res=$(expr $x \* $y)	
#echo "$res" 	
elif [[ $oper == "/" ]]
then
	if [[ $y == 0 ]]
	 then
	 res=0
	else
	#res=$(expr $x / $y)	
	res=`echo $x/$y | bc -l `
	fi
#echo "$res" 	
fi
echo $res > resFile.txt
d=`date`
printf "Calc.bash run on %s processID %d \n" "$d" "$$"
printf "Calc.bash run on %s processID %d \n" "$d" "$$" >> Output.txt

if [[ $oper == "M" ]]
then
printf "Calculator result for: %d * %d \n" $x $y
printf "Calculator result for: %d * %d \n" $x $y >> Output.txt
else
printf "Calculator result for: %d %c %d \n" $x $oper $y
printf "Calculator result for: %d %c %d \n" $x $oper $y >> Output.txt
fi
if [[ $oper == "/" ]]
then
printf "Result: %.3f \n" "$res"
printf "Result: %.3f \n" "$res" >> Output.txt
else
printf "Result: %d \n" "$res"
printf "Result: %d \n" "$res" >> Output.txt
fi
Pres="y"
} # end of Calc()

# trap signal 10, signal from CalcUI to process results
trap Calc 10

dfile=$dir/CalcData.txt
#echo $dfile
if ! test -r $dfile
then
    echo "File missing: $dfile"
exit
fi

Data=$(cat $dfile | awk -F, '
{
if( $1 >= 0 ) {
  for(i = 1; i <= NF; i++) {

        if( $i != "END" ) {
         print $i
   }
  }
 }
}')
#echo ${Data[@]}
Data2=(${Data[@]})
Dsize=${#Data2[@]}
#echo $Dsize
#echo ${Data2[0]}
#echo ${Data2[1]}
while true; do
  sleep 5 &
  wait $!
done
