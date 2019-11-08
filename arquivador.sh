#!/bin/bash

function readWord(){
	counter=0
	wordPosition=0
	while IFS= read -r line; do
		for word in ${line}; do
			echo "word ${counter}: ${word}"
			echo "word size `printf "%s" "${word}" | wc -c`"
			wordSize=`printf "%s" "${word}" | wc -c`
			
			if [ ${wordSize} -gt 3 ]; then
				echo "counter: $counter - pos: $wordPosition"
				wordArray["bigger",${wordPosition},${counter}]=${word}
				echo -ne "${wordArray[${wordPosition},${counter}]} " >> biggerWords
				let wordPosition++
			else
				wordArray["smaller",${wordPosition},${counter}]=${word}
				echo -ne "${wordArray["smaller",${wordPosition},${counter}]} " >> smallerWords
			fi	
			
			echo ""
			let counter++
		done
	done < inputFile
}

function classify(){
	biggerWordsCounter=0
	counter=0
	wordPosition=0
	
	rm finalCompressedFile
	rm mediumCompressedFile
	rm compressedFile
	
	while IFS= read -r line; do
		for word in ${line}; do
			wordSize=`printf "%s" "${word}" | wc -c`
			if [ ${wordSize} -gt 3 ]; then
				let biggerWordsCounter++
			fi
		done
	done < inputFile
	echo -ne "(0)(${biggerWordsCounter})" >> finalCompressedFile
	
	while IFS= read -r line; do
		for word in ${line}; do
			echo "word ${counter}: ${word}"
			echo "word size `printf "%s" "${word}" | wc -c`"
			wordSize=`printf "%s" "${word}" | wc -c`
			
			if [ ${wordSize} -gt 3 ]; then
				echo "counter: $counter - pos: $wordPosition"
				wordArray["bigger",${wordPosition},${counter}]=${word}
				echo -ne "${wordArray[${wordPosition},${counter}]}," >> mediumCompressedFile
				let wordPosition++
			fi	
			
			echo ""
			let counter++
		done
	done < inputFile
	
	counter=0
	while IFS= read -r line; do
		for word in ${line}; do
			auxiliarArray[${counter}]=${word}
		done
		for i in ${counter}; do
			
		done
	done < mediumCompressedFile
	
}

function addToCompressedFile(){
	while IFS= read -r line; do
		for word in ${line}; do
			echo "word ${counter}: ${word}"
			echo "word size `printf "%s" "${word}" | wc -c`"
			wordSize=`printf "%s" "${word}" | wc -c`
			
			if [ ${wordSize} -gt 3 ]; then
				echo "counter: $counter - pos: $wordPosition"
				wordArray["bigger",${wordPosition},${counter}]=${word}
				echo -ne "${wordArray[${wordPosition},${counter}]} " >> compressedFile
				let wordPosition++
			else
				wordArray["smaller",${wordPosition},${counter}]=${word}
				echo -ne "${wordArray["smaller",${wordPosition},${counter}]} " >> compressedFile
			fi	
			
			echo ""
			let counter++
		done
	done < inputFile
}




#readWord
classify
echo "ARRAY ${wordArray[4,5]}"