#!/bin/bash

#	DECLARATIONS	#
argsmod=$(git status | grep -A1 'modified:' | sed 's/^.*: //' | tr -d '\n')
argsdel=$(git status | grep -A1 'deleted:' | sed 's/^.*: //' | tr -d '\n')
argsadd=$(git status | grep -A1 '"git add <file>..." to include' | tail -1 | tr -d '\n'| sed -e 's/^[ \t]*//')
comment=""

echo "Comment:"
read comment

#	COMMIT GEN	#
if [ -n $argsmofidy ];then
	p_argsmod="> updating: $argsmod | "
fi

p_comment="> comment: $comment | "

if [ -n $argsadd ];then
        git add .
	p_argsadd="> added: $argsadd | "
fi
if [ -n $argsdel ];then
	git add .
	p_argsdel="> removed: $argsdel | "
fi
git commit -m "$p_argsmod $p_comment $p_argsadd $p_argsdel"

#	PUSH		#
echo "push now ? (yes/a)"
read temp
if [ -z $temp ];then
	echo "waiting to push..."
	exit 0
elif [ $temp == "yes" ];then
	git push
	echo "=============================="
	echo "| git folder has been pushed |"
	echo "=============================="
	exit 0
else
	echo "waiting to push..."
	exit 0
fi
