
lines=()
index=0
known_hosts_arr=()
function parseEnv(){
	if [ -f known_hosts ]; then
	#cat known_hosts |awk  '{print $1}' > h
	#rm h -f

	while read line;do
		#$line=` echo $line |awk  '{print $1}'`
		lines[${#lines[*]}]="$line"
		known_hosts_arr[${#known_hosts_arr[*]}]=`echo $line|awk '{print $1}'`
		#echo $line
	done < known_hosts

	else
		echo no file know_hosts found
		exit
	fi
}

parseEnv

function saveCurrentTtySettings(){
	old_stty_settings=`stty -g`
}
function recoverCurrentTtySettings(){
	stty "$old_stty_settings"
}
function moveCursorToOrigin(){
	echo -en "\e[0;0H"
}

function clearScreen(){
	echo -e "\e[2J"
}

function repaint(){
	echo -en "\e[2J\e[0;0H"
}


function up(){
	echo -n ${lines[$index]}
	echo -en "\r" #carrige return
	let index=index-1
	[ $index -lt 0 ]&& let index=0
	echo -en "\e[1A" #up
	oneline
}

function down(){
	echo -n ${lines[$index]}
	echo -en "\r" #carrige return
	let index=index+1
	echo -en "\e[1B" #down
	oneline
}
function oneline(){
	echo -en "\e[31m" #red font color
	echo -n ${lines[$index]}
	echo -en "\r"
	echo -en "\e[m" #reset font style
}


function printLines(){
	for (( i=0;i<=${#lines[@]};i++ ));do
		echo  ${lines[$i]}         
	done
}

function page(){
	repaint
	printLines
}

function sshConnect(){
	recoverCurrentTtySettings&&repaint
	#eval ssh ${know_hosts[$index]}
	echo connecting  ${known_hosts_arr[$index]} 
	ssh ${known_hosts_arr[$index]} 
}

####################################################################################################

saveCurrentTtySettings
stty -echo
page
moveCursorToOrigin

while true
	do
	dd if=/dev/tty bs=1 count=1 of=keypress  &>/dev/null

	keypress=`cat keypress`
	case "$keypress" in
	 [j] ) down;;
	 [k] ) up;;
	 [q] ) recoverCurrentTtySettings&&repaint&& exit;;
	 * )  break ;;
	esac
done

sshConnect
