#!/bin/sh

NAME="$1"
. ./girlLove.txt
#./girlLove.sh GFNAME
#declaration="下面将要展示的页面是我新学的HTML语言, 为了写这个程序,我专门花时间学了这门语言 \n 怎么样,有什么奖励没呢?"

declaration="$NAME 我会守护你一辈子的!"
pos_stdy="$(($(stty size|cut -d' ' -f1) / 3 * 2))"
pos_stdx="$(($(stty size|cut -d' ' -f2) / 2))"



total_stdy="$(($(stty size|cut -d' ' -f1)))"
total_stdx="$(($(stty size|cut -d' ' -f2)))"
info="$NAME 这就是送你的礼物了 选择1－4并按下回车开始答题吧"
head="$NAME 当前的答题进度:"

######################## function ====================
# wait
waiting()
{
   i=1
   while [ $i -gt 0 ]
   do
      for j in '-' '\\' '|' '/'
      do
         echo -ne "\033[1m\033[$(($(stty size|cut -d' ' -f1) / 3 * 2));$(($(stty size|cut -d' ' -f2) / 2 - ${#declaration} - 6))H$j$j$j$j$j$j\033[4m\033[32m${declaration}"
         echo -ne "\033[24m\033[?25l$j$j$j$j$j$j"
         usleep 100000
      done
      ((i++))
   done
}

# usage: print_qa string
print_qa()
{
   if [ $# -eq 0 ]; then
      return 1
   fi
   #len=`expr length "$1"`
   len=`expr ${#1} / 2`
   if [ $# -lt 2 ]; then
      pos="\e[${pos_stdy};$((${pos_stdx} - ${len}))H"
   elif [ $2 = "-" ]; then
      pos="\e[$((${pos_stdy} - $3));$((${pos_stdx} - ${len}))H"
   elif [ $2 = "+" ]; then
      pos="\e[$((${pos_stdy} + $3));$((${pos_stdx} - ${len}))H"
   elif [ $2 = "lu" ]; then
      pos="\e[$((${pos_stdy} - $3));$((${pos_stdx} - $4))H"
   elif [ $2 = "ld" ]; then
      pos="\e[$((${pos_stdy} + $3));$((${pos_stdx} - $4))H"
   fi

   echo -ne "${pos}$1"
}


############################### print ====================================
clear
print_qa "*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
printf "\r\e[${total_stdy};$(((${total_stdx} - ${#info}*2)/2))H${info}"
offset=14
seq=0
while [ ${seq} -lt ${#poetry[@]} ]
do
   sleep 0
   isanswer=0
   if [ $seq -lt ${#question[@]} ]; then
      print_qa "${bakans[$seq]}" + 3
      print_qa "问:${question[$seq]}" ld 2 $offset
      print_qa "答:" ld 4 $offset
      read ans
      echo -e "\033[3A\r\033[K"
      echo -e "\033[K"
      echo -e "\033[K"
      echo -e "\033[K"
      if [ "$ans" != "${answer[$seq]}" ]; then
         print_qa "---------------------------------------" + 5
         print_qa "${tips[$seq]}" + 7
         sleep 1
         echo -e "\r\033[K"
         echo -e "\033[3A\r\033[K"
         continue
      fi
   fi

   seq=`expr ${seq} + 1`
   curseq=`expr ${#poetry[@]} - ${seq}`
   print_qa "${poetry[${curseq}]}" lu $seq $offset
   
   total=$[${total_stdx} - ${#head}*2]
   per=$[${seq}*${total}/${#poetry[@]}]
   shengyu=$[${total} - ${per}]
   echo $shengyu
   printf "\r\e[${total_stdy};0H${head}\e[42m%${per}s\e[46m%${shengyu}s\e[00m" "" "";
done

echo

printf "\r\e[41m%s" ""
clear
waiting

#firefox -new-window nvyou.hta
#exit
