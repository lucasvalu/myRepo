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
	rm ${1}Compressed
	biggerWordsCounter=0
	counter=0
	wordPosition=0
	
	while IFS= read -r line; do
		for word in ${line}; do
			wordSize=`printf "%s" "${word}" | wc -c`
			if [ ${wordSize} -gt 3 ]; then
				let biggerWordsCounter++
			fi
		done
	done < ${1}
	echo -ne "(0)(${biggerWordsCounter})" >> ${1}Compressed
	
	while IFS= read -r line; do
		for word in ${line}; do
			#echo "word ${counter}: ${word}"
			#echo "word size `printf "%s" "${word}" | wc -c`"
			wordSize=`printf "%s" "${word}" | wc -c`
			
			if [ ${wordSize} -gt 3 ]; then
				#echo "counter: $counter - pos: $wordPosition"
				wordArray["bigger",${wordPosition},${counter}]=${word}
				echo "${wordArray[${wordPosition},${counter}]} " >> mediumCompressedFile
				let wordPosition++
			fi	
			let counter++
		done
	done < ${1}
	
	
	secondCounter=0
	thirdCounter=0
	auxCounter=0
	wordCounter=0
	found="false"
	while IFS= read -r line; do
		for word in ${line}; do
			mediumWordArray[${secondCounter}]="${word}"
			mediumWordArrayRRN[${secondCounter}]="(255)(0)(${secondCounter})"
			let secondCounter++
		done
	done < mediumCompressedFile
	
	while IFS= read -r line; do
		for word in ${line}; do
			found="false"
			while [[ ${found} == "false"  ]];do
				echo "current word is: ${word}" >> logFile
				echo "being compared to: ${mediumWordArray[${auxCounter}]}" >> logFile
				
				if [[ ${word} == "${mediumWordArray[${auxCounter}]}" ]]; then
					echo -ne "${mediumWordArray[${auxCounter}]}" >> test
					echo -ne "${mediumWordArray[${auxCounter}]}," >> ${1}Compressed
					echo -ne "${mediumWordArrayRRN[${auxCounter}]} " >> rrnCompressedFile
					let wordCounter++
					echo "MATCH!!!" >> logFile
					echo "" >> logFile
					auxCounter=1
					found="true"
				else
					let auxCounter++
				fi
			done
		done
		
		
	done < mediumCompressedFile
	cat rrnCompressedFile >> ${1}Compressed
	
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

function main(){


	if [[ ${1} == "-c" ]]; then
		classify ${2}
	fi
	removeTemporaryFiles ${2}
}

function removeTemporaryFiles(){
	rm mediumCompressedFile
	rm test
	rm rrnCompressedFile
	rm logFile
}

main ${1} ${2}