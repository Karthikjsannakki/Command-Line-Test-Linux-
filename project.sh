#!/bin/bash
passdata=(`cat user_credentials.csv | cut -d ";" -f2`)
userdata=(`cat user_credentials.csv | cut -d ";" -f1`)

function sign_in()
{
		clear
		echo -e     "************************************************************************************\n\n"
		echo -e     "                            \e[1m\e[31mHello! WelCome Back\e[0m                                 "
		echo -e "\n\n************************************************************************************"
		echo -e     "                                \e[1m\e[32mLOGIN-PAGE\e[0m                                      "
		echo -e     "************************************************************************************\n\n"

		echo -e "\e[1m\e[36mPlease Enter Your\n\e[0m"
		read -p "Username: " username
		read -p "Password: " -s password
		flag=0
		for i in `seq 0 ${#userdata[@]}`
		do
				if [ "${userdata[$i]}" == "$username" ]
				then
						if [ "${passdata[$i]}" == "$password" ]
						then
								flag=1
						fi
				fi
		done
		if [ $flag -eq 1 ]
		then
				echo -e "\n\n\e[1m\e[33mSigned in Sucessfully\e[0m\n"
				read -n 1 -s -r -p "Press any key to continue"
				test_menu
		else
				echo -e "\n\n\e[1m\e[91mInvalid Credentials\e[0m\n"
				read -n 1 -s -r -p "Press y to Try again..." y
				if [ "$y" = "y" ]
				then
						clear
						sign_in
				else
						exit
				fi
		fi

}

function sign_up()
{
		clear
		echo -e     "************************************************************************************\n\n"
		echo -e     "                               \e[1m\e[31mWelcome! User\e[0m                                 "
		echo -e "\n\n************************************************************************************"
		echo -e     "                             \e[1m\e[32mREGISTRATION PAGE\e[0m                                      "
		echo -e     "************************************************************************************\n\n"
		echo -e "\e[1m\e[36mPlease Enter Your\e[0m\n"
		read -p "Username: " username
		for i in ${userdata[@]}
		do
				if [ "$i" == "$username" ]
				then
						echo -e "\n\n\e[1m\e[33mUser already exist!!!\nPlease Choose different name/Signin\n\e[0m"
						read -n 1 -s -r -p "Press y to Continue..." opt
						echo
						if [ "$opt" == "y" ]
						then
								bash project.sh
						else
								exit
						fi


				fi

		done
		read -p "Password: " -s password
		alnum=`echo $password | tr -d [:alnum:]`
		digit=`echo $password | tr -dc [:digit:]`
		alpha=`echo $password | tr -dc [:alpha:]`
		if [ "${#password}" -ge 8 -a "${#alnum}" -ge 1 -a "${#digit}" -ge 1 -a "${#alpha}" -ge 1 ]
		then
				echo
				read -p "Please re-enter your password: " -s repassword

				if [ "$password" == "$repassword" ]
				then
						echo -e "\n\n\e[1m\e[33mRegistration Successful\e[0m\n"
						data=`echo "$username";echo "$password"`
						credentials=`echo $data | tr ' ' ';'`
						echo $credentials >> user_credentials.csv
						read -n 1 -s -r -p "Now Press any key for Sign-in Option"
						bash project.sh

				else
						echo -e "\n\n\e[1m\e[91mPassword Doesnt match\n\e[0m"
						read -n 1 -s -r -p "Press any key to continue"
						sign_up

				fi
		else
				echo -e "\n\e[1minfo:\e[0m\n1. Password must contain 8 characters\n2. Atleast 1 Special character\n3. Atleast 1 Number/digit\n"
				read -n 1 -s -r -p "Press any key to Try again..."
				sign_up

		fi

}

function read_answer()
{
		for ((j=10; j>=0 ;j--))
		do
				echo -e "\r\e[7mTime Remaining:\e[0m \e[5m\e[31m$j\e[0m Seconds | \e[92mEnter Your Option Here:\e[0m \c"
				read -n 1 -t 1 opt
				if [ ${#opt} -eq 1 ]
				then
						echo $opt >> useranswers.txt
						sleep 1
						return
				fi
		done
		sleep 1
		if [ ${#opt} -eq 0 ]
		then
				echo NotAnswered >> useranswers.txt
		fi

}

function test_screen()
{
		count=0
		sed -i '1,$d' useranswers.txt
		for i in `seq 1 10`
		do
				clear

				echo -e     "************************************************************************************\n\n"
				echo -e     "                               \e[1mALL THE BEST\e[0m                                 "
				echo -e "\n\n************************************************************************************"
				echo -e     "                               \e[1m\e[36mQUIZ-2021\e[0m                                      "
				echo -e     "************************************************************************************\n\n"
				count=$((count+6))
				cat question.txt | head -n $count | tail -6
				echo
				read_answer
		done
		clear

		echo -e     "************************************************************************************\n\n"
		echo -e     "                               \e[1mALL THE BEST\e[0m                                 "
		echo -e "\n\n************************************************************************************"
		echo -e     "                                \e[1m\e[36mQUIZ-2021\e[0m                                      "
		echo -e     "************************************************************************************\n\n"
		echo -e "\e[1m\e[33mYour Test is Completed!!!\e[0m\n"
		read -n 1 -s -r -p "Press y to Continue with Test-Menu/Press v to View Score with Answers" y
		if [ "$y" == "y" ]
		then
				test_menu
		elif [ "$y" == "v" ]
		then
				view_test_screen
		else
				bash project.sh
		fi
}

function test_menu()
{
		clear
		echo -e     "************************************************************************************\n\n"
		echo -e     "                                 \e[1m\e[31mWelcome\e[0m                                 "
		echo -e "\n\n************************************************************************************"
		echo -e     "                            \e[1m\e[32m\e[5mQUIZ CONTEST-2021\e[0m                                      "
		echo -e     "************************************************************************************\n\n"
		echo -e "\n\e[1m\e[36mPlease Choose the below option:\e[0m\n\n"
		echo -e "\n1 - Take a Test\n2 - View Your Test Score and Key Answers\n3 - SignOut\n"
		read -n 1 -s -r -p "Please Choose Your Option: " option1
		case $option1 in
				1) test_screen;;
				2) view_test_screen;;
				3) echo -e "\n\n\e[1m\e[33mYou're Signed out...See ya\n\e[0m" 
						exit ;;
				*) echo -e "\n\n\e[1m\e[33mPlease Choose from above option only...\n\e[0m"

		esac
		read -n 1 -s -r -p "Press any key to continue"
		test_menu
}

function view_test_screen()
{
		clear
		Score=0
		count=6
		solution=(`cat solutions.txt`)
		Useranswers=(`cat useranswers.txt`)

		for i in `seq 0 9`
		do
				if [ "${solution[i]}" == "${Useranswers[i]}" ]
				then
						Score=$((Score+1))
				fi
		done
		testdata=`echo "Username:$username"; echo "Score:$Score"`
		echo $testdata >> testlog.txt
		echo -e "**************************************************************************************\n\n"
		echo -e "                           \e[1m\e[31mYour Quiz Score:\e[0m\e[5m\e[7m$Score/10\e[0m                             "
		echo -e "\n\n***************************************************************************************\n"

		for i in `seq 0 9`
		do
				echo
				cat question.txt | head -n $count | tail -6
				echo
				echo -e "\e[92mCorrect Answer:\e[0m ${solution[i]} \e[93mYour Answer:\e[0m ${Useranswers[i]}"
				echo -e "\e[1m-----------------------------------------------------------------------------\e[0m"
				count=$((count+6))

		done

		echo -e "**************************************************************************************\n\n"
		echo -e "                           \e[1m\e[31mYour Quiz Score:\e[0m\e[5m\e[7m$Score/10\e[0m                             "
		echo -e "\n\n***************************************************************************************\n"
		read -n 1 -s -r -p "Press any key to Test-Menu"
		test_menu

}
while [ 1 ]
do
		clear
		echo -e     "************************************************************************************\n\n"
		echo -e     "                                 \e[1m\e[31mWelcome\e[0m                                 "
		echo -e "\n\n************************************************************************************"
		echo -e     "                            \e[1m\e[32m\e[5mQUIZ CONTEST-2021\e[0m                                      "
		echo -e     "************************************************************************************\n\n"

		echo -e "\n\e[1m\e[36mPlease Choose the below option:\e[0m\n\n"
		echo -e "\n1 - Signin\n2 - Signup\n3 - Exit\n"
		read -n 1 -s -r -p "Please Enter your Option here: " option
		case $option in
				1) sign_in;;
				2) sign_up;;
				3) echo -e "\n\n\e[1m\e[33mYou Choosed Exit option...See ya\n\e[0m"
					exit ;;
				*) echo -e "\n\e[1m\e[31mPlease choose from above option only...\e[0m\n"
		esac
		read -n 1 -s -r -p "Press any key to continue..." 
done
