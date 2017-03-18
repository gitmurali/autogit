#!/usr/bin/env bash

#--------------------------------------------------------------------
#title           :gitish.sh
#description     :This script will automate the general git operations.
#author          :Murali Prasanth N
#date            :20170308
#version         :1.0
#usage           :bash gitish.sh
#bash_version    :3.2.57(1)-release
#--------------------------------------------------------------------

#--------------------------------------------------------------------
# declare constants
#--------------------------------------------------------------------
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
export N=2 # break the iterations

#--------------------------------------------------------------------
# Colors
#--------------------------------------------------------------------
export GREEN='\033[0;32m'
export GRAY='\033[0;37m'
export LIGHTBLUE='\033[1;34m'
export LIGHTGREEN='\033[1;32m'
export WHITEBOLD='\033[1;37m'
export RED='\033[1;31m'
export NC='\033[0m' # No Color

#--------------------------------------------------------------------
# Icons
#--------------------------------------------------------------------
TICK="✅"
TICK2="✔︎"
WARN="⚠️"
ERROR="‼️"
INFO="ℹ️"
TIMER="⏳"
BEER="🍺"
SMILE="😃"

#--------------------------------------------------------------------
# Options can be removed if you don't need any of them.
#--------------------------------------------------------------------
MAIN_OPTIONS=("init" "clone" "config" "status" "log" "branch" "clean" "reset" "tag" "commit" "diff" "revert" "stash" "cherry-pick" "help" "quit")
RESET_OPTIONS=("soft" "hard" "mixed" "reset_file" "status" "back" "quit")
CONFIG_OPTIONS=("System" "User" "Project" "list" "status" "back" "quit")
TAG_OPTIONS=("create" "Create_Annotated_tag" "Tag_at_commit" "push" "list" "find" "delete" "Remote_delete" "status" "back" "quit")
STASH_OPTIONS=("save" "apply" "drop" "show" "list" "status" "back" "quit")
LOG_OPTIONS=("since" "until" "author" "grep" "merges" "lol" "oneline" "custom" "find" "status" "back" "quit")
BRANCH_OPTIONS=("rebase" "checkout" "merge" "merge_abort" "push" "diff" "delete" "delete_remote" "list_remotes" "list_tracked" "list" "status" "back" "quit")
COMMIT_OPTIONS=("add" "add_all" "unstage_all" "unstage_file" "commit" "add_commit" "status" "back" "quit")
CHERRY_PICK_OPTIONS=("branch_commit" "abort" "continue" "quit_cpick" "status" "back" "quit")

#--------------------------------------------------------------------
# initialize gitish
#--------------------------------------------------------------------
__init(){
  if [ -d $DIR ];
  then
    clear;
    export N=$((N+2))
    echo "$GREEN What now?? $TIMER"
    echo "================================================================"
    COLUMNS=1 ## To display options in one vertical column
    select option in "${MAIN_OPTIONS[@]}"
    do
      case $option in
          init)   __gitinit;;
          clone)  __gitclone;;
          config) __gitconfig;;
          status) __gitstatus;;
          log)    __gitlog;;
          branch) __gitbranch;;
          clean)  __gitclean;;
          reset)  __gitreset;;
          commit) __gitcommit;;
          diff) __gitdiff;;
          revert) __gitrevert;;
          tag)    __gittag;;
          cherry-pick) __gitCherryPick;;
          stash) __gitstash;;
          help) echo "What are you looking for? $TIMER ";read guess;$GIT help $guess;;
          quit) __quit;;
          *) __info;;
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

# init a git project
__gitinit() {
    $GIT init; # initialize a git repo.
}

# clone the repo
__gitclone() {
    while [[ $url == "" ]]; do read -p "please enter git repo url!! $TIMER  -> " url; done; $GIT clone $url; unset url;
}

# config settings system/global/user
__gitconfig() {
  clear;
  broken=0;
  echo "Where would you like to change the configuration?";
  select option in "${CONFIG_OPTIONS[@]}"
  do
    case $option in
        System) while [[ $name == "" ]]; do read -p "what do you want to add/remove to system level config? $TIMER -> " name; done; $GIT $CONFIG --system $name; unset name;;
        User) while [[ $name == "" ]]; do read -p "what do you want to add/remove to User level config? $TIMER -> " name; done; $GIT $CONFIG --global $name; unset name;;
        Project) while [[ $name == "" ]]; do read -p "what do you want to add/remove to project level config? $TIMER -> " name; done; $GIT $CONFIG $name; unset name;;
        list) nano ~/.gitconfig;;
        status) __gitstatus;;
        back) broken=1;break;;
        quit) __quit;;
        *) __info;;
    esac
  done
  __break 1;
}

# Status
__gitstatus() {
	$GIT status
}

## Log actions
__gitLogAction() {
  case $@ in
      s)  while [[ $guess == "" ]]; do read -p "Logs since? $TIMER -> " guess; done; $GIT $LOG --since=$guess; unset guess;;
      u)  while [[ $guess == "" ]]; do read -p "Logs until? $TIMER -> " guess; done; $GIT $LOG --until=$guess; unset guess;;
      a)  while [[ $guess == "" ]]; do read -p "Logs by Author? $TIMER -> " guess; done; $GIT $LOG --author=$guess; unset guess;;
      g)  while [[ $guess == "" ]]; do read -p "logs by search? $TIMER -> " guess; done; $GIT $LOG --grep=$guess; unset guess;;
      m)  while [[ $guess == "" ]]; do read -p "Logs for merges? $TIMER -> " guess; done; $GIT $LOG --oneline --decorate --graph --merges; unset guess;;
      lol) $GIT $LOG --graph --decorate --all --oneline;;
      f) while [[ $guess == "" ]]; do read -p "Find what? $TIMER -> " guess; done; $GIT $LOG --oneline -v | grep $txt; unset guess;;
      o)  while [[ $num == "" ]]; do read -p "How many lines to limit? $TIMER -> " num; done; $GIT $LOG --oneline -$num; unset num;;
      cust) while [[ $guess == "" ]]; do read -p "please enter options? $TIMER -> " guess; done; $GIT $LOG $options; unset guess;;
      *)  __info;;
  esac
}

## Log options
__gitlog() {
  clear;
  broken=0;
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
        back) broken=1;break;;
        quit) __quit;;
        *) __info;;
    esac
  done
  __break 1;
}

## Branch Actions
__gitBranchAction () {
    case $@ in
        r) while [[ $guess == "" ]]; do read -p "Rebase to what? $TIMER -> " guess; done; $GIT rebase $guess; unset guess;;
        c) echo "Checkout a new branch?? $TIMER -> ";read Name;echo "Remote branch to checkout? $TIMER -> ";read remoteBranch; $GIT checkout -b $Name $remoteBranch;;
        m) echo "Which branch to checkout? $TIMER -> ";read Name;echo "Which branch you want to merge? $TIMER -> ";read rBranch;$GIT checkout $Name;$GIT merge $rBranch;;
        p) while [[ $guess == "" ]]; do read -p "push branch to remote? $TIMER -> " guess; done; $GIT $PUSH -u $REMOTE $guess; unset guess;;
        d) echo "diff what?? $TIMER -> ";read NAME;$GIT diff;;
        l) $GIT branch -av;;
        lr) $GIT branch -r;;
        lt) $GIT branch -vv;;
        del) while [[ $guess == "" ]]; do read -p "Delete Branch? $TIMER -> "; guess; done; $GIT $BRANCH -d $guess; unset guess;;
        delr) while [[ $guess == "" ]]; do read -p "Delete remote Branch? $TIMER -> "; guess; done; $GIT $PUSH $REMOTE --delete $guess; unset guess;;
        *) __info;;
    esac
}

#Branch options
__gitbranch() {
  clear;
  broken=0;
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
        delete_remote) __gitBranchAction delr;;
        status) __gitstatus;;
        list) __gitBranchAction l;;
        list_remotes) __gitBranchAction lr;;
        list_tracked) __gitBranchAction lt;;
        back) broken=1;break;;
        quit)  __quit;;
        *) __info;;
    esac
  done
  __break 1;
}

# clean files
__gitclean() {
    $GIT clean -n
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
  broken=0;
  echo "Reset HEAD";
  select option in "${RESET_OPTIONS[@]}"
  do
    case $option in
        soft) $GIT $RESET --soft HEAD;;# # reset's HEAD to latest commit by keeping your local and staged changes.
        hard) $GIT $RESET --hard HEAD;; # reset's HEAD to latest commit by removing local and staged changes.
        mixed) $GIT $RESET --mixed HEAD;;# reset's HEAD to latest commit by removing staged changes.
        reset_file) while [[ $guess == "" ]]; do read -p "Which file to reset to HEAD? $TIMER -> " guess; done; $GIT checkout -- $guess; unset guess;;
        status) __gitstatus;;
        back) broken=1;break;;
        quit) __quit;;
        *) __info;;
    esac
  done
  __break 1;
}

## Tag actions
__gitTagAction () {
    case $@ in
        a) while [[ $guess == "" ]]; do read -p "Create Annotated tag? $TIMER -> " guess; done; $GIT $TAG -a $guess; unset guess;;
        c) echo 'Commit SHA to TAG?';read COMMIT_SHA;echo 'Name the TAG?';read $NAME;$GIT $TAG $NAME $COMMIT_SHA;;
        d) while [[ $guess == "" ]]; do read -p "Delete TAG? $TIMER -> " guess; done; $GIT $TAG -d $guess; unset guess;;
        f) while [[ $guess == "" ]]; do read -p "Find TAG? $TIMER -> " guess; done; $GIT $TAG --list | grep $guess; unset guess;;
        r) while [[ $guess == "" ]]; do read -p "Delete Remote TAG? $TIMER -> " guess; done; $GIT $PUSH $REMOTE --delete $guess; unset guess;;
        p) $GIT $PUSH --tags;;
        l) $GIT $TAG --list;;
        *) while [[ $guess == "" ]]; do read -p "Create the Tag? $TIMER -> " guess; done; $GIT $TAG $guess; unset guess;;
    esac
}

## Tag options
__gittag() {
  clear;
  broken=0;
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
        back) broken=1;break;;
        quit) __quit;;
        *) __info;;
    esac
  done
  __break 1;
}

# Commit actions
__gitcommit() {
  clear;
  broken=0;
  echo "commit what? $TIMER -> ";
  select option in "${COMMIT_OPTIONS[@]}"
  do
    case $option in
        add) while [[ $guess == "" ]]; do read -p "Add files to staged? (seperate filepaths with spaces) $TIMER -> " guess; done; $GIT add $guess; unset guess;; # Add files to stage
        add_all) $GIT add .;; # Add all files to stage
        unstage_all) $GIT $RESET HEAD;; # Unstage all files
        unstage_file) while [[ $guess == "" ]]; do read -p "Which files to unstage? $TIMER -> " guess; done; $GIT $RESET HEAD $guess; unset guess;; # Unstage specific files
        commit) while [[ $guess == "" ]]; do read -p "please type your message to commit? $TIMER -> " guess; done; $GIT commit -m $guess; unset guess;; # commit changes
        add_commit) echo "Add files and then commit?";read reply;$GIT commit -am $reply;; # Adds files to stage and then commit;
        status) __gitstatus;;
        back) broken=1;break;;
        quit) __quit;;
        *) __info;;
    esac
  done
  __break 1;
}

# diff
__gitdiff() {
  clear;
  while [[ $guess == "" ]]; do read -p "Diff a Branch/Commit?? $TIMER -> " guess; done; $GIT diff --color-words $guess; unset guess; # diff
}

# revert
__gitrevert() {
  clear;
  echo "Choose one from below!!"
  select option in "Merge" "commit" "back" "quit"
  do
    case $option in
        Merge) echo "$WARN Revert a merge? Which commit to revert $TIMER -> ";read COMMIT_SHA;echo "Revert message? $TIMER -> ";read MSG;$GIT revert $COMMIT_SHA -m 1 $MSG;; #revert a merge
        commit) while [[ $guess == "" ]]; do read -p "$WARN Revert a commit?? $TIMER -> " guess; done; $GIT revert $guess; unset guess;; # revert
        back) broken=1;break;;
        quit) __quit;;
        *) __info;;
    esac
  done
  __break 1;
}

## Stash actions
__gitStashAction() {
  case $@ in
      s)  while [[ $guess == "" ]]; do read -p "Save Changes? Name your stash : $TIMER -> " guess; done; $GIT $STASH save $guess; unset guess;; # stash files
      a)  echo "Apply Stash Number? ";read num;if [[ -z "$num" ]];then $GIT $STASH apply;else $GIT $STASH apply stash@{$num};fi;;
      d)  echo "stash drop Number?";read num;if [[ -z "$num" ]];then $GIT $STASH drop;else $GIT $STASH drop stash@{$num};fi;;
      sh) echo "Show Stash Number?";read num;if [[ -z "$num" ]];then $GIT $STASH show -p;else $GIT $STASH show -p stash@{$num};fi;;
      l)  echo "stash list";$GIT $STASH list;;
      *)  __info;;
  esac
}

## Stash options
__gitstash() {
  clear;
  broken=0
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
        back) broken=1;break;;
        quit) __quit;;
        *) __info;;
    esac
  done
  __break 1;
}

# Cherry-pick options
__gitCherryPick() {
  clear;
  broken=0
  echo "Cherry-pick $TIMER";
  select option in "${CHERRY_PICK_OPTIONS[@]}"
  do
    case $option in
        branch_commit) echo "select branch/commit to cherry-pick? $TIMER ";read reply;$GIT cherry-pick $reply;;
        abort) echo "Abort cherry-pick?[y/n] $TIMER";read reply;if [[ $reply == "y" ]]; then $GIT cherry-pick --abort;fi;; # Abort cherry-pick
        continue) $GIT cherry-pick --continue;; # Continue cherry-pick
        quit_cpick) $GIT cherry-pick --quit;; # quit cherry-pick
        status) __gitstatus;;
        back) broken=1;break;;
        quit) __quit;;
        *) __info;;
    esac
  done
  __break 1;
}

__info() {
  echo "please choose an option listed above";
}

__break() {
  if [[ $1 == 1 ]]; then
      __init;
  fi
}
__quit() {
  clear;
  export N=$((N+2))
  echo "GoodBye $SMILE";
  break $N;
}

__init;
