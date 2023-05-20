# !bin/bash/

#Rami Majadbeh 1190611
#Nasser Awwad  1191484


while [ 1 ]
do

printf "please enter the file you want to read THE Data from!\n"

read fileN

if [ ! -e $fileN ]
then
printf "The file you entered doesn't exist!\n" # to make sure the file exists
#to make sure the file is readable

elif [ ! -f $fileN ]
then
printf "THIS ISN'T AN READABLE FILE\n"

else
break

fi

done


sed 's/,//g' $fileN > temp #remove ',' from all of the contacts, to make operations easier
mv temp $fileN


echo
echo "================Welcome To Contact Management System=================="

echo
echo " Main Menu"
echo " =============================="
echo " [1] Add A New Contact"
echo " [2] List All Contacts"
echo " [3] Search For Contact"
echo " [4] Edit A Contact"
echo " [5] Delete A Contact"
echo " [0] Exit"

choice=1
while [ "$choice" -ne 0 ]
do    # when choice is zero it exists

echo "Enter Your Choice !!"

choice=
read choice

#################################################################
if(($choice == 1))
then

printf "Please Enter The Firstname !!\n"

f=0

while [ $f -eq 0 ]
do

read firstname
f=$(echo $firstname | grep -q [0-9])
f=$?

if [ $f -eq 0 ]
then
printf "INVALID NAME !! Please Re-enter it !!\n"
fi

done

#=========================================
n=0


if [ $n -eq 0 ]
then

printf "Please Enter A Phone number !!\n"
read phonenumber

a=$(echo $phonenumber | grep -q [A-Za-z])
a=$?

 

 

while [ $a -eq 0 -o ${#phonenumber} -gt 10 -o ${#phonenumber} -lt 9 ] #reads the first phone number and checks wether its valid or not
do

printf "INVALID NUMBER !! Please Re-enter it !!\n"

read phonenumber

a=$(echo $phonenumber | grep -q [A-Za-z])
a=$?

done

var1="$phonenumber"
n=$((n+1))

fi

while [ 5 ]
do


printf "WOULD LIKE TO ENTER ANOTHER PHONE NUMBER? (YES or NO)\n" # reads the other phone numbers if wanted by user and enters them
read v


if [ $v = "no" ]
then

break

elif [ $v = "yes" ]
then


printf "ENTER PHONE NUMBER !!\n"
read phonenumber

a=$(echo $phonenumber | grep -q [A-Za-z])
a=$?


while [ $a -eq 0 -o ${#phonenumber} -gt 10 -o ${#phonenumber} -lt 9 ]
do

printf "INVALID NUMBER !! Please Re-enter it !!\n"

read phonenumber

a=$(echo $phonenumber | grep -q [A-Za-z])
a=$?

done

var1+=";${phonenumber}"

else
printf "what you entered is inavlid\n"

fi
done

#=================================================

printf "WOULD YOU LIKE TO ENTER AN E-mail ?? (YES or NO)\n"


read le #e-mail is optional so user is asked if you wants to enter one

if [ $le = "yes" ]
then
x=1

  while [ $x -eq 1 ]
   do
   echo ENTER AN EMAIL !!
   read email
   x=$(echo $email | grep "^.\+@.\+\.com$") #here the e-mail is entered and checked wether its valid or not and must be reentered until it is right
   x=$?


if [ $x -eq 1 ]
then
printf "the E-mail you entered was wrong. Please re-enter it\n"

else
break

fi

done

else

email="NULL"

fi

 

#=======================================================

printf "WOULD YOU LIKE TO ENTER THE LAST NAME?? (YES OR NO)\n"

read ll

if [ $ll = "yes" ] #lastname is optional
then

printf "PLEASE ENTER THE LAST NAME\n"

l=0

while [ $l -eq 0 ] #if it's not valid we re-enter it
do


read lastname
l=$(echo $lastname | grep -q [0-9])
l=$?

if [ $l -eq 0 ]

then
printf "the last name you entered isn't VALID, please re-enter it\n"
fi

done

else

lastname="NULL"

fi

echo "$firstname $lastname $var1 $email" >> $fileN
#################################################################2
elif(($choice == 2))
then

cat $fileN > temp.txt

echo "Based On The First Name Or The Last Name?"

read ans

if [ "$ans" = "first" ] #sorted based on firstname
then

sort -k 1 temp.txt > b.txt #-k sorts by column

printf "contacts sorted based on Firstname\n"

elif [ "$ans" = "last" ] #sorted based on Lastname
then

sort -k 2 temp.txt > b.txt
printf "contacts sorted based on lastname\n"

fi

 

var=
printf "would you like to show Firstname? YES OR NO\n"

read first

if [ $first = "yes" ] #firstname
then

var+="1 "

fi

printf "Would you to show the Lastname\n"
read second
if [ $second = "yes" ] #lastname
then
var+="2 "

fi

printf "Would you to show the Phone numbers\n"
read third
if [ $third = "yes" ] #phone number
then

var+="3 "
fi

printf "Would you to show the E-mail\n"
read fourth
if [ $fourth = "yes" ] #e-mails
then

var+="4"

fi

printf "contacts is shown below\n"

var=$(echo $var | tr ' ' ',')

 

if [ -z $var ] #if no fields are picked
then

echo
printf "No Picked Fields\n"

else

cut -d' ' -f$var b.txt #print it to user

fi

#################################################################3
elif (($choice == 3))
then

echo "" > temp5.txt #create a new file

num=
file=

read search #type the fields you want to search for

num=$(echo $search | tr ' ' '\n' | wc -l)

i=1

while [ $num -ge $i ] #if multiple fields
do

split=$(echo $search | cut -d' ' -f$i) # we cut them and search for each for them in a loop, but when searching for each one we create a contact file based on the search result.


if [ $i -eq 1 ] #to create a new file and put the found items into
then

grep "$split" $fileN > temp5.txt

[ -s temp5.txt ]
if [ $? == 1 ]
then
echo Nothing Is Found !!
fi


elif [ $i -gt 1 ] #same as above but for multiple fields
then


file=$(cat temp5.txt | grep "$split") #always minimize the search to the wanted lines
echo $file > temp5.txt

fi


i=$((i+1))
done

if [ $num -eq 1 ] #print the result
then
cat temp5.txt

else

echo $file


fi

######################################################################
elif(($choice == 4))
then

flag=1
FINAL=
echo "What Is The First Name Of The Contact?"    # ASK THE USER ABOUT THE FIRST NAME OF THE CONTACT

read name1

NAME=$(cat $fileN | grep "^\b$name1\b")
number=$(echo "$NAME" | wc -l)    # TO DETERMINE THE NUMBER OF OCCURANCES

if [ "$number" == 1 ]
then
words=$(echo "$NAME" | wc -w)
if [ "$words" == 0 ]
then
flag=0
echo "No Contact Exists With This Name"

else
grep -v "$name1" $fileN > temp.txt
cat temp.txt > $fileN
FINAL=$(echo $NAME)

fi

else
echo There are Many Contacts With This Name    # IF THERE ARE MANY CONTACTS WITH THIS FIRST NAME
echo Enter The Last Name Please !!

read last

LAST=$(echo "$NAME" | grep "\b$last\b")
number=$(echo "$LAST" | wc -l)


if [ "$number" == 1 ]
then

words=$(echo "$LAST" | wc -w)
if [ "$words" == 0 ]
then
flag=0
echo "No Contact Exists With This Full Name"

else
grep -v "$LAST" $fileN > temp.txt
cat temp.txt > $fileN
FINAL=$(echo $LAST)
fi

else
echo There are Many Contacts With This Full Name
echo Enter The Phone Number Please !!    # ENTER PHONE NUMBER

read phone
PHONE=$(echo "$LAST" | grep "\b$phone\b")

words=$(echo "$PHONE" | wc -w)
if [ "$words" == 0 ]
then
flag=0
echo "No Contact Exists With This Phone Number"
else

grep -v "$PHONE" $fileN > temp.txt
cat temp.txt > $fileN
FINAL=$(echo $PHONE)
fi

fi

fi

if [ "$flag" == 1 ]
then
# I PUT THEM IN VARIABLES TO EDIT THEN BELOW
temp=$(echo $FINAL | tr ' ' '\n')
firstname1=$(echo $temp | cut -d' ' -f1)
lastname1=$(echo $temp| cut -d' ' -f2)
PhoneNumber1=$(echo $temp| cut -d' ' -f3)
Email1=$(echo $temp | cut -d' ' -f4)

n=1
while [ "$n" -ne 0 ]
do

echo
echo Row Details:
echo $FINAL
echo

echo "What Do You Want To Change"
echo "[1] First Name"
echo "[2] Last Name"
echo "[3] Phone Number"
echo "[4] Email"
echo "[0] Quit"

n=
read n


case "$n"
in
# EDIT THE FIELDS
1)
echo Enter New First Name !!
read fn
firstname1=$(echo $fn)
FINAL=$(echo "$firstname1 $lastname1 $PhoneNumber1 $Email1");;

2)
echo Enter New Last Name !!
read fn
lastname1=$(echo $fn)
FINAL=$(echo "$firstname1 $lastname1 $PhoneNumber1 $Email1");;

3)
echo $PhoneNumber1 | tr ';' '\n' > temp.txt
check=$(cat temp.txt | wc -l )
echo Number Of Phone Numbers is $check

if [ $check == 1 ]
then

echo ENTER THE NEW NUMBER !!

else

echo WHICH NUMBER DO YOU WANT TO CHANGE ??
read num
line=$(sed -n "${num}p" temp.txt)
line1=$(grep -v "$line" temp.txt)
echo CHANGE IT TO:
fi



read phonenumber

a=$(echo $phonenumber | grep -q [A-Za-z])
a=$?

while [ $a -eq 0 -o ${#phonenumber} -gt 10 -o ${#phonenumber} -lt 9 ]
do
 
printf "INVALID NUMBER, please Re-enter it\n"  
 
read phonenumber

a=$(echo $phonenumber | grep -q [A-Za-z])
a=$?

done

if [ $check == 1 ]
then
PhoneNumber1=$(echo "$phonenumber")
else
PhoneNumber1=$(echo "$phonenumber;$line1")

fi
FINAL=$(echo "$firstname1 $lastname1 $PhoneNumber1 $Email1");;    

4)
echo Enter New Email !!
x=1
while [ $x -eq 1 ]
do

read email
x=$(echo $email | grep  "^.\+@.\+\.com$")   #here the e-mail is entered and checked wether its valid or not and must be reentered until it is right
x=$?

if [ $x -eq 1 ]
then
printf "the E-mail you entered was wrong. Please re-enter it\n"

else
x=0
Email1=$(echo $email)
fi

done

FINAL=$(echo "$firstname1 $lastname1 $PhoneNumber1 $Email1");;

0) echo Done of Editing
echo $FINAL
;;

*)echo Incorrect Index;;
esac

done

echo $FINAL >> $fileN

fi
######################################################################
elif(($choice == 5)) # DELETE A CONTACT
then

flag=1
FINAL=
echo "What Is The First Name Of The Contact?"
# DETERMINE WHICH CONTACT
read name1

NAME=$(cat $fileN | grep "^\b$name1\b")
number=$(echo "$NAME" | wc -l)
if [ "$number" == 1 ]
then
words=$(echo "$NAME" | wc -w)

if [ "$words" == 0 ]
then
flag=0
echo "No Contact Exists With This Name"

else
FINAL=$(echo $NAME)
fi

else
echo There are Many Contacts With This Name
echo Enter The Last Name Please !!

read last

LAST=$(echo "$NAME" | grep "\b$last\b")
number=$(echo "$LAST" | wc -l)

if [ "$number" == 1 ]
then

words=$(echo "$LAST" | wc -w)
if [ "$words" == 0 ]
then
flag=0
echo "No Contact Exists With This Full Name"

else
FINAL=$(echo $LAST)
fi

else
echo There are Many Contacts With This Full Name
echo Enter The Phone Number Please !!

read phone
PHONE=$(echo "$LAST" | grep "\b$phone\b")

words=$(echo "$PHONE" | wc -w)
if [ "$words" == 0 ]
then
flag=0
echo "No Contact Exists With This Phone Number"
else

FINAL=$(echo $PHONE)

fi
fi
fi

if [ "$flag" == 1 ]
then
echo $FINAL
grep -v "$FINAL" $fileN > temp.txt
cat temp.txt > $fileN
echo THE CONTACT IS DELETED SUCCESSFULLY
fi

##########################################################


fi
done
