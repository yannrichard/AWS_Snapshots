#!/bin/bash

### Variables 
#COLORS
green='\033[0;32m'
red='\033[0;31m'
blue='\033[0;34m'
NC='\033[0m'
#Region="eu-west-1"
export AWS_DEFAULT_OUTPUT="table"


### FUNCTIONS ###

############################
## Ask User ONE Day 
AskOne (){
echo -n "Enter your Account ID :  "
read AccountID

echo -n "Enter the Region where are located the snapshots :  "
read Region

echo -n "Enter the day of creation of the snapshots (YYYY-MM-DD) :  "
read DateSnap
echo ""
echo "Please wait for the snapshot list to be generated..."
echo ""
}

############################
## Ask User Multiple days
AskMulti (){
echo -n "Enter your Account ID :  "
read AccountID

echo -n "Enter the Region where are located the snapshots :  "
read Region

echo -n "Enter multiple dates of snapshot creation separated by an extra space (YYYY-MM-DD YYYY-MM-DD YYYY-MM-DD YYYY-MM-DD) :  "
read DateMulti
echo ""
echo "Please wait for the snapshot list to be generated..."
echo ""
}

############################
## Ask User TIME RANGE
AskRange (){
echo -n "Enter your Account ID :  "
read AccountID

echo -n "Enter the Region where are located the snapshots :  "
read Region

echo -n "Time range begins on (YYYY-MM-DD) :  "
read DateStart
echo ""
echo -n "Time range ends on (YYYY-MM-DD) :  "
read DateStop
echo ""
echo "Please wait for the snapshot list to be generated..."
echo ""
}


############################
## Describe the selected Snapshots for ONE day
DescribeOne (){
aws ec2 describe-snapshots --region $Region  | grep -B 4 -A 4 "$DateSnap" | grep -A 7 $AccountID
}

############################
## Describe the selected Snapshots for MULTIPLE days
DescribeMulti (){
for i in $DateMulti; do aws ec2 describe-snapshots --region $Region  | grep -B 4 -A 4 "$i" | grep -A 7 $AccountID; done
}

############################
## Describe the selected Snapshots for a TIME-RANGE
DescribeRange (){
aws ec2 describe-snapshots --region $Region  | grep -E -B 4 -A 4 '$DateStart|$DateStop' | grep -A 7 $AccountID
}




############################
## Delete the selected Snapshots for ONE day
DeleteOne(){
aws ec2 describe-snapshots --region $Region  | grep -B 4 -A 4 "$DateSnap" | grep -A 7 $AccountID | grep -Eio "snap-[0-9;a-z]+" | awk '{print "Deleting-> " $1; system("aws ec2 delete-snapshot --snapshot-id " $1)}'
}

############################
## Delete the selected Snapshots for MULTIPLE days
DeleteMulti (){
for i in $DateMulti; do aws ec2 describe-snapshots --region $Region  | grep -B 4 -A 4 "$i" | grep -A 7 $AccountID | grep -Eio "snap-[0-9;a-z]+" | awk '{print "Deleting-> " $1; system("aws ec2 delete-snapshot --snapshot-id " $1)}'; done
}

############################
## Delete the selected Snapshots for a TIME-RANGE
DeleteRange(){
aws ec2 describe-snapshots --region $Region  | grep -E -B 4 -A 4 '$DateStart|$DateStop' | grep -A 7 $AccountID | grep -Eio "snap-[0-9;a-z]+" | awk '{print "Deleting-> " $1; system("aws ec2 delete-snapshot --snapshot-id " $1)}'
}



############################
## Main Menu
MainMenu() {
echo ""
echo "$(date)"
echo "-------------------------------"   
echo -e   "  ${red}Select an Option${NC}"
echo "-------------------------------"
echo ""
echo "1. One day snapshot deletion"
echo "2. Multiple days snapshot deletion"
echo "3. Time-Range snapshot deletion !!! NOT WORKING"
echo ""
echo ""
return 2;
}

############################
## Read the Main menu
read_MainMenu(){
echo "Please select options 1-2-3"
read option
case $option in
      1) 
         echo ""
         AskOne
         DescribeOne
         menuOne
         read_optionsOne
			echo ""
      	;;
      2) 
         echo ""
         AskMulti
         DescribeMulti
         menuMulti
         read_optionsMulti
			echo ""
      	;;
		3)
         echo ""
			AskRange
			DescribeRange
			menuRange
			read_optionsRange
			echo ""
      	;;
		*)
			echo "Error: Invalid option..."	
			read -p "Press [Enter] key to continue..." readEnterKey
			;;
    esac
}

############################
## Menu for confirmation
menuOne() {
echo ""
echo "$(date)"
echo "-------------------------------"   
echo -e   "  ${red}Please confirm the deletion${NC}"
echo "-------------------------------"
echo ""
echo "1. Confirm the snapshots deletion"
echo "2. Cancel"
return 2;
}

############################
## Read the confirmation menu
read_optionsOne(){
echo "Please select options 1 ~ 2"
read option
case $option in
      1) 
         echo ""
			echo "Please wait for the snapshots to be deleted..."
			echo ""
			DeleteOne
      	;;
		2)
			return 1
			;;
		*)
			echo "Error: Invalid option..."	
			read -p "Press [Enter] key to continue..." readEnterKey
			;;
    esac
}


############################
## Menu for confirmation
menuMulti() {
echo ""
echo "$(date)"
echo "-------------------------------"   
echo -e   "  ${red}Please confirm the deletion${NC}"
echo "-------------------------------"
echo ""
echo "1. Confirm the snapshots deletion"
echo "2. Cancel"
return 2;
}

############################
## Read the confirmation menu
read_optionsMulti(){
echo "Please select options 1 ~ 2"
read option
case $option in
      1) 
         echo ""
			echo "Please wait for the snapshots to be deleted..."
			echo ""
			DeleteMulti
      	;;
		2)
			return 1
			;;
		*)
			echo "Error: Invalid option..."	
			read -p "Press [Enter] key to continue..." readEnterKey
			;;
    esac
}


############################
## Menu for confirmation
menuRange() {
echo ""
echo "$(date)"
echo "-------------------------------"   
echo -e   "  ${red}Please confirm the deletion${NC}"
echo "-------------------------------"
echo ""
echo "1. Confirm the snapshots deletion"
echo "2. Cancel"
return 2;
}

############################
## Read the confirmation menu
read_optionsRange(){
echo "Please select options 1 ~ 2"
read option
case $option in
      1) 
         echo ""
			echo "Please wait for the snapshots to be deleted..."
			echo ""
			DeleteRange
      	;;
		2)
			return 1
			;;
		*)
			echo "Error: Invalid option..."	
			read -p "Press [Enter] key to continue..." readEnterKey
			;;
    esac
}


### Exec ###
clear
MainMenu
read_MainMenu



