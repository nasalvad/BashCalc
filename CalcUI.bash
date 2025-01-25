#!/bin/bash
MyExit() {
#  echo "MyExit \n"
  if [[ $1 == 2 ]]
  then
          echo "Program exit: send signal 15 to Calc.bash"
          kill -15 `cat tmppid`
     exit
  else
      exit
  fi
 }
trap 'MyExit 2' 1 2 3 6 9

#echo "CalcUI program has started, pid is $$" 
dir=`pwd`
 CalcUI(){
#  echo "In CalcUI() "
#  echo "$1 $2 $3"
 echo "$1 $2 $3" > $dir/Inst.txt
#  echo "sending signal 10 to Calc"
  kill -10 `cat tmppid`

 }

Calcfile=$dir/Calc.bash
#echo $dfile
if ! test -x $Calcfile
then
    echo "File missing: $Calcfile"
MyExit 1
fi
#start Calc process
#echo $Calcfile
./Calc.bash &
#echo "Calc.bash $!"

dfile=$dir/CalcData.txt
#echo $dfile
if ! test -r $dfile
then
    echo "File missing: $dfile"
MyExit 2
fi

Op1=0
#echo $Op1

while :
  do

 echo "Enter operation to be performed (+-*/ or Q to Quit): "
 read oper

 if [[ "$oper" == "Q" || "$oper" == "Quit" ]]
 then
      MyExit 2

 elif [[ "$oper" != "+" && "$oper" != "-" && "$oper" != "*" && "$oper" != "/" ]]
 then
 echo "Invalid input \n"
 continue
 fi

 echo "Use previous result as operand? (n/1/2): "
 read op_type

 if [[ "$op_type" != "n" && "$op_type" != "1" && "$op_type" != "2" ]]
 then
    echo "Invalid Input"
    continue
 fi

 echo "Reset data file pointer to start of data file? (y/n): "
 read op_point

 if [[ "$op_point" == "y" ]]
 then
      $Op1=0

    echo $Op1
    echo $oper
	  
 elif [[ "$op_point" != "n" ]]
 then
   echo "Invalid Input"
   continue
 fi
#to avoid problems with * characther we use M
if [[ $oper == "*" ]] 
then
# echo "changing characther for multiplication to M"
 oper="M"
fi
 CalcUI "$Op1 $oper $op_type"
 if [[ $op_type == "n" ]]
	  then
	Op1=$(expr $Op1 + 2)
 elif [[ $op_type == "1" || $op_type == "2" ]]
	  then
        Op1=$(expr $Op1 + 1)
 fi
 #echo "In CalcUI: Index to data is: $Op1"
sleep 2
echo "press <enter> or any key to continue "
read ent_cont
done
