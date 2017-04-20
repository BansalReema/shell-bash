#/bin/sh
#read file
file="$2"
echo "$1"
echo "$2"
echo "$3"
if [ -z "$file" ]
then
	exit
fi

if [ -f "$file" ]
then
  echo "$file found."

  while IFS='=' read -r key value
  do
    key=$(echo $key | tr '.' '_')
    eval "${key}='${value}'"
  done < "$file"

  outputdir=$( echo "$3" |cut -d'/' -f 2 )
  echo $outputdir
  outputfile=$( echo "$3" |cut -d'/' -f 3 )
  echo $outputfile

  if [ ! -d "outputdir" ]; then
    #Control will enter here if $outputdir doesn't exist.
	  sudo mkdir -p "$outputdir"
  fi

  sed "1,/\[\[.[a-z]*/s/\[\[.[a-z]*/${title}/g" "$1" > update
  sed 's/\]\]/''/g' update > newone
  sed "1,/\[\[.[a-z]*/s/\[\[.[a-z]*/${environment}/g" newone > "$outputfile"
  cat "$outputfile"
  sudo mv ./"$outputfile" ./"$outputdir"
  rm -rf update newone
else
  echo "$file not found."
fi