function update(){
	# package manager
	pm="apt";
	# update
	eval "$pm update"
}

#preinstalled applications array
apps=()

function parseEnv(){
	if [ -f .env ]; then
	for line in `cat .env`
	do
	#echo $line
	apps[${#apps[*]} + 1]=$line
	done
	fi
}

parseEnv


for v in ${apps[@]};do
apt-get install $v  -y 2>&1 1>/dev/null
echo -e "\e[32m installed $v \e[0m"
done

echo ${apps[0]}

export EDITOR=vim
export HISTTIMEFORMAT="%m/%d/%y %T "


#cat <<EOF
#'aaa'
#EOF

for (( i=2;i<=$#;i++ )); do
	eval echo  "\${$i}"         
done

if [[  $1 =~ ^-[^rf] ]]; then
    echo "usage: rm [-rf] files"
    exit 1
fi
