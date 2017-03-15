#!/usr/bin/env bash
#title           :autogit.sh
#description     :This script will automate the general git operations.
#author          :Murali Prasanth N
#date            :20170308
#version         :1.0
#usage           :bash autogit.sh
#bash_version    :3.2.57(1)-release

# declare constants
GIT=git
STASH=stash
CONFIG=config
RESET=reset
BRANCH=branch
TAG=tag
PUSH=push
REMOTE=origin #Change here if your remote is different than origin
LOG=log
DIR=.git/ #to check if it's a valid git repo.
CHOOSE=$(( ( RANDOM % 10 )  + 1 ))  #generate random colors with rand.

## Options can be removed if you don't need any of them.
MAIN_OPTIONS=("init" "config" "status" "log" "branch" "clean" "reset" "tag" "commit" "diff" "revert" "rename" "stash" "cherry-pick" "help" "quit")
RESET_OPTIONS=("soft" "hard" "mixed" "reset_file" "status" "back" "quit")
CONFIG_OPTIONS=("System" "User" "Project" "list" "status" "back" "quit")
TAG_OPTIONS=("create" "Create_Annotated_tag" "Tag_at_commit" "push" "list" "find" "delete" "Remote_delete" "status" "back" "quit")
STASH_OPTIONS=("save" "apply" "drop" "show" "list" "status" "back" "quit")
LOG_OPTIONS=("since" "until" "author" "grep" "merges" "lol" "oneline" "custom" "find" "status" "back" "quit")
BRANCH_OPTIONS=("rebase" "checkout" "merge" "merge_abort" "push" "diff" "delete" "list_remotes" "list_tracked" "list" "status" "back" "quit")
COMMIT_OPTIONS=("add" "add_all" "unstage_all" "unstage_file" "commit" "add_commit" "status" "back" "quit")
CHERRY_PICK_OPTIONS=("branch_commit" "abort" "continue" "quit_cpick" "status" "back" "quit")

### initialize autogit ###
__init(){
  if [ -d $DIR ];
  then
    clear;
    echo -e "\033[32;40mWhat now?? $TIMER"
    echo "================================================================"
    COLUMNS=1 ## To display options in one vertical column
    select option in "${MAIN_OPTIONS[@]}"
    do
      case $option in
          init)   __gitinit;;
          clone)  __gitclone;;
          config) __gitconfig;;
          status) __gitstatus;;
          branch) __gitbranch;;
          reset)  __gitreset;;
          log)    __gitlog;;
          commit) __gitcommit;;
          diff) __gitdiff;;
          revert) __gitrevert;;
          rename) __gitrename;;
          tag)    __gittag;;
          clean)  __gitclean;;
          cherry-pick) __gitCherryPick;;
          stash) __gitstash;;
          help) echo "What are you looking for? $TIMER ";read guess;$GIT help $guess;;
          quit) __breakMsg;;
          *) __breakMsg;;
      esac
    done
  else
    echo -e "\033[5;31;47mOops!! not a valid git directory. This script is helpful for automating some git operations.\033[0m";
    read -p "Do you want to initialize the git project in this directory? $TIMER [y/n] " a;
    if [[ $a == "y" ]]; then
        __gitinit;
        __init;
    fi
  fi
}

# diff
__gitdiff() {
  clear;
  echo "Diff a Branch/Commit?? $TIMER";read reply;$GIT diff --color-words $reply;
}

# revert
__gitrevert() {
    echo "in revert"
}

# rename
__gitrename() {
  echo "in rename"
}

# init a git project
__gitinit() {
    $GIT init; # initialize a git repo.
}

# clone the repo
__gitclone() {
    echo "please enter git repo url!! $TIMER ";read url;$GIT clone $url;
    __init;
}

# Status
__gitstatus() {
	$GIT status
}

# clean files
__gitclean() {
    $GIT clean -n;
    echo "$WARN The above files will be removed. Remove? [y/n]"
    read ans;
    if [[  $ans == "y" ]]; then
        $GIT clean -f;
    else
        __init;
    fi
}

# reset working repo
__gitreset() {
  clear;
  echo "Reset HEAD";
  select option in "${RESET_OPTIONS[@]}"
  do
    case $option in
        soft) $GIT $RESET --soft HEAD;;# # reset's HEAD to latest commit by keeping your local and staged changes.
        hard) $GIT $RESET --hard HEAD;; # reset's HEAD to latest commit by removing local and staged changes.
        mixed) $GIT $RESET --mixed HEAD;;# reset's HEAD to latest commit by removing staged changes.
        reset_file) echo "Which file to reset to HEAD?";read reply;$GIT checkout -- $reply;;
        status) __gitstatus;;
        back) __init;;
        quit) __quit;;
        *) echo "i don't recognize";;
    esac
  done
}

# config settings system/global/user
__gitconfig() {
  clear;
  echo "Where would you like to change the configuration?";
  select option in "${CONFIG_OPTIONS[@]}"
  do
    case $option in
        System) echo "what do you want to add/remove to system level config? ";read Name;$GIT $CONFIG --system $Name;;
        User) echo "what do you want to add/remove to User level config? ";read Name;$GIT $CONFIG --global $Name;;
        Project) echo "what do you want to add/remove to Project level config? ";read Name;$GIT $CONFIG $Name;;
        list) nano ~/.gitconfig;;
        status) __gitstatus;;
        back) __init;;
        quit) __quit;;
        *) echo "i don't recognize";;
    esac
  done
}

## Branch Actions
__gitBranchAction () {
    case $@ in
        r) echo "Rebase to what? $TIMER ";read Name;$GIT rebase $Name;;
        c) echo "Checkout a new branch?? $TIMER";read Name;echo "Remote branch to checkout? $TIMER";read remoteBranch; $GIT checkout -b $Name $remoteBranch;;
        m) echo "Which branch to checkout?";read Name;echo "Which branch you want to merge?";read rBranch;$GIT checkout $Name;$GIT merge $rBranch;;
        p) echo "push branch to remote? $TIMER";read NAME;$GIT $PUSH -u $REMOTE $NAME;;
        d) echo "diff what?? $TIMER";read NAME;$GIT diff;;
        l) $GIT branch -av;;
        lr) $GIT branch -r;;
        lt) $GIT branch -vv;;
        del) echo 'Delete Branch?';read NAME;$GIT $BRANCH -d $NAME;;
        b) __init;;
        q) __quit;;
        *) echo "I don't know what that is: ";;
    esac
}

#Branch options
__gitbranch() {
  clear;
  echo "Choose one from below!!"
  select option in "${BRANCH_OPTIONS[@]}"
  do
    case $option in
        rebase) __gitBranchAction r;;
        checkout) __gitBranchAction c;;
        merge) __gitBranchAction m;;
        merge_abort) echo "Abort Merge?[y/n] $TIMER";read reply;if [[ $reply == "y" ]]; then $GIT merge --abort;fi;; # Abort merge
        push) __gitBranchAction p;;
        diff) __gitBranchAction d;;
        delete) __gitBranchAction del;;
        status) __gitstatus;;
        list) __gitBranchAction l;;
        list_remotes) __gitBranchAction lr;;
        list_tracked) __gitBranchAction lt;;
        back) __gitBranchAction b;;
        quit) __gitBranchAction q;;
        *) __breakMsg;
    esac
  done
}

## Tag actions
__gitTagAction () {
    case $@ in
        a) echo "Create Annotated tag?";read NAME;$GIT $TAG -a $NAME;;
        b) __init;;
        c) echo 'Commit SHA to TAG?';read COMMIT_SHA;echo 'Name the TAG?';read $NAME;$GIT $TAG $NAME $COMMIT_SHA;;
        d) echo 'Delete TAG?';read NAME;$GIT $TAG -d $NAME;;
        f) echo "Find TAG?";read NAME;$GIT $TAG --list | grep $NAME;;
        r) echo 'Delete Remote TAG?';read NAME;$GIT $PUSH $REMOTE --delete $NAME;;
        p) $GIT $PUSH --tags;;
        l) $GIT $TAG --list;;
        *) echo "Create the Tag?";read NAME;$GIT $TAG $NAME;;
    esac
}

## Tag options
__gittag() {
  clear;
  echo "Choose one from below!!"
  COLUMNS=1 ## To display options in one vertical column
  select option in "${TAG_OPTIONS[@]}"
  do
    case $option in
        create) __gitTagAction;;
        Create_Annotated_tag) __gitTagAction a;;
        Tag_at_commit) __gitTagAction c;;
        push) __gitTagAction p;;
        delete) __gitTagAction d;;
        Remote_delete) __gitTagAction r;;
        list) __gitTagAction l;;
        find) __gitTagAction f;;
        status) __gitstatus;;
        back) __gitTagAction b;;
        quit) __quit;;
        *) __breakMsg;
    esac
  done
}

## Stash actions
__gitStashAction() {
  case $@ in
      s)  echo "Save Changes? Name your stash : ";read guess;if [[ -z "$guess" ]];then $GIT $STASH save;else $GIT $STASH save $guess;fi;;
      a)  echo "Apply Stash Number? ";read num;if [[ -z "$num" ]];then $GIT $STASH apply;else $GIT $STASH apply stash@{$num};fi;;
      d)  echo "stash drop Number?";read num;if [[ -z "$num" ]];then $GIT $STASH drop;else $GIT $STASH drop stash@{$num};fi;;
      sh) echo "Show Stash Number?";read num;if [[ -z "$num" ]];then $GIT $STASH show -p;else $GIT $STASH show -p stash@{$num};fi;;
      l)  echo "stash list";$GIT $STASH list;;
      b)  __breakMsg;__init;;
      *)  __breakMsg;;
  esac
}

## Stash options
__gitstash() {
  clear;
  echo "Choose one from below!!"
  select option in "${STASH_OPTIONS[@]}"
  do
    case $option in
        save) __gitStashAction s;;
        apply) __gitStashAction a;;
        drop) __gitStashAction d;;
        show) __gitStashAction sh;;
        list) __gitStashAction l;;
        status) __gitstatus;;
        back) __gitStashAction b;;
        quit) __quit;;
        *) __breakMsg;
    esac
  done
}

## Log actions
__gitLogAction() {
  case $@ in
      s)  echo "Logs since? ";read guess;if [[ -z "$guess" ]];then $GIT $LOG --since=date;else $GIT $LOG --since=$guess;fi;;
      u)  echo "Logs until? ";read guess;if [[ -z "$guess" ]];then $GIT $LOG --until=date;else $GIT $LOG --until=$guess;fi;;
      a)  echo "Logs by Author? ";read guess;if [[ -z "$guess" ]];then $GIT $LOG --author;else $GIT $LOG --author=$guess;fi;;
      g)  echo "logs by search? ";read guess;if [[ -z "$guess" ]];then $GIT $LOG;else $GIT $LOG --grep=$guess;fi;;
      m)  echo "Logs for merges";$GIT $LOG --oneline --decorate --graph --merges;;
      lol) $GIT lol;;
      f) echo "Find what?";read txt;$GIT $LOG --oneline -v | grep $txt;;
      o)  echo "How many lines to limit? ";read num;$GIT $LOG --oneline -$num;;
      cust) echo "please enter options? "; read options; $GIT $LOG $options;;
      *)  __breakMsg;;
  esac
}

## Log options
__gitlog() {
  clear;
  echo "Choose one from below!!"
  select option in "${LOG_OPTIONS[@]}"
  do
    case $option in
        since) __gitLogAction s;;
        until) __gitLogAction u;;
        author) __gitLogAction a;;
        grep) __gitLogAction g;;
        merges) __gitLogAction m;;
        lol) __gitLogAction lol;;
        oneline) __gitLogAction o;;
        custom) __gitLogAction cust;;
        find) __gitLogAction f;;
        status) __gitstatus;;
        back) __breakMsg;;
        quit) __quit;;
        *) __breakMsg;
    esac
  done
}

# Cherry-pick options
__gitCherryPick() {
  clear;
  echo "Cherry-pick $TIMER";
  select option in "${CHERRY_PICK_OPTIONS[@]}"
  do
    case $option in
        branch_commit) echo "select branch/commit to cherry-pick? $TIMER ";read reply;$GIT cherry-pick $reply;;
        abort) echo "Abort cherry-pick?[y/n] $TIMER";read reply;if [[ $reply == "y" ]]; then $GIT cherry-pick --abort;fi;; # Abort cherry-pick
        continue) $GIT cherry-pick --continue;; # Continue cherry-pick
        quit_cpick) $GIT cherry-pick --quit;; # quit cherry-pick
        status) __gitstatus;;
        back) __init;break;;
        quit) __quit;;
        *) echo "I don't recognize";break;;
    esac
  done
}

# Commit actions
__gitcommit() {
  clear;
  echo "commit what? $TIMER";
  select option in "${COMMIT_OPTIONS[@]}"
  do
    case $option in
        add) echo "Add files to staged? (seperate filepaths with spaces) $TIMER ";read reply$GIT add $reply;; # Add files to stage
        add_all) $GIT add .;; # Add all files to stage
        unstage_all) $GIT $RESET HEAD;; # Unstage all files
        unstage_file) echo "Which files to unstage? $TIMER";read reply;$GIT $RESET HEAD $reply;; # Unstage specific files
        commit) echo "please type your message to commit?";read reply;$GIT commit -m $reply;; # commit changes
        add_commit) echo "Add files and then commit?";read reply;$GIT commit -am $reply;; # Adds files to stage and then commit;
        status) __gitstatus;;
        back) __init;break;;
        quit) __quit;;
        *) echo "I don't recognize";break;;
    esac
  done
}

__breakMsg (){
    clear;
    echo "GoodBye $BEER";
    break;
}

__quit() {
  clear;
  echo "GoodBye $BEER";
  break 2;
}

alias gitish=__init
