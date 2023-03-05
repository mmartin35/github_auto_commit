#!/bin/bash
/bin/clear

_get_git_status() {
	argsmod=$(git status | grep -A1 'modified:' | sed 's/^.*: //' | tr -d '\n')
	argsdel=$(git status | grep -A1 'deleted:' | sed 's/^.*: //' | tr -d '\n')
	argsadd=$(git status | grep -A1 '"git add <file>..." to include' | tail -1 | tr -d '\n'| sed -e 's/^[ \t]*//')
}

_insert_comment() {
	echo "Write down a comment if needed (if not, just press enter)"
	read comment
}

_check_empty_args() {

if [ -n $argsmofidy ];then
	p_argsmod=">UD: $argsmod "
fi

if [ -n $argsadd ];then
        git add .
	p_argsadd=">ADD: $argsadd "
fi

if [ -n $argsdel ];then
	git add .
	p_argsdel=">RM: $argsdel "
fi

p_comment="> comment: $comment "
}

_format_and_push() {
git commit -m "$p_argsmod $p_comment $p_argsadd $p_argsdel"
echo "which branch to push ?"
read branch_name
if [ -z $branch_name ];then
	branch_name="main"
fi
git push -u origin $branch_name
echo "| git commit has been pushed |"
}

echo "Push the current repository on github ? (y/a)"
read status
if [ -z $status ];then
	echo "aborted"
	exit 84
fi
if [ $status == "y" ];then
	_get_git_status
	_insert_comment
	_check_empty_args
	_format_and_push
	exit 0
else
	echo "aborted"
	exit 84
fi
