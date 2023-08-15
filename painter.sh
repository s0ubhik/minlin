ncol="\033[0m"
bold="\033[1m"
dim="\033[2m"
uline="\033[4m"
reverse="\033[7m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
purple="\033[35m"
cyan="\033[36m"
white="\033[37m"

label(){ #labelName
  printf $reverse$bold$cyan"$1$ncol\n"
}

Head(){
  printf $bold$uline"$1$ncol\n"
}

addLog(){ # symbol color text
  printf $dim$2$1$ncol$bold$2"$3$ncol"
}

addPad(){ # text
  printf "  $1" | sed -z 's/\n/\n  /g'
  printf "\n"
}

desc(){
  addPad "$1"
}

scs(){ # message
 addLog "["$ncol$bold$green"+$ncol$green$dim]" $green " $1\n"
}


bltn(){ # message
 printf " "
 addLog $bold"*" $purple " $ncol$white$1"
}

blt(){ # message
 printf " "
 addLog $bold"*" $purple " $ncol$white$1\n"
}

err(){ # message
  addLog "["$ncol$red$bold"-$ncol$dim$red]" $red " $1\n"
}

wrn(){ # message
  addLog "["$ncol$yellow$bold"!$ncol$dim$yellow]" $yellow " $1\n"
}

ask(){ #text #show #force #default
  if [ "$1" != "" ]
  then
  addLog "["$ncol$bold$blue"?$ncol$dim$blue]" $blue " $1"

  fi
  read -p "" inp

  while [ "$inp" = "" ]
  do
    if [ "$4" != "" ]
    then
      inp=$4
      break
    fi
    if [ "$3" = "True" ]
    then
      addLog "[?]" $blue " $1"
      read -p "" inp
    fi
  done
  if [ "$2" = "True" ]
  then
    printf "  $bold$cyan""==> $ncol$inp\n"
  fi
}
inp(){
  printf "$bold$blue$1$ncol"
  ask ""
}
