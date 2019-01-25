
# This script check framework CPU code Set

# APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"
APP_PATH="$1"



rm -f /tmp/${APP_PATH##*/}.txt
#trap 'rm -f "/tmp/${APP_PATH##*/"}' INT TERM HUP EXIT
logFile=$(mktemp /tmp/${APP_PATH##*/}.txt)


echo "Log File Path: $logFile"

if [ $2 == "true" ]; then
  find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
  do
    #//echo "{$ARCHS}"
    #

    project_name="${FRAMEWORK##*/}"
    # echo  ${project_name}
    # #echo ${project_name:12-20:20}
    # echo ${project_name/.framework/}
    project_name=${project_name/.framework/}


    frameworkPath=${FRAMEWORK}/${project_name}
    # echo ${frameworkPath}

    # 将framework 信息写入logFile
    lipo -info ${frameworkPath} >> $logFile



  done

else

  find "$APP_PATH" -name '*.framework' -maxdepth 1 -type d | while read -r  FRAMEWORK
  do
    #//echo "{$ARCHS}"
    #

    #echo "non-recursion"

    project_name="${FRAMEWORK##*/}"
    # echo  ${project_name}
    # #echo ${project_name:12-20:20}
    # echo ${project_name/.framework/}
    project_name=${project_name/.framework/}


    frameworkPath=${FRAMEWORK}/${project_name}
    # echo ${frameworkPath}

    # 将framework 信息写入logFile
    lipo -info ${frameworkPath} >> $logFile



  done

fi




echo $3


if [ $3 == "onliyHardware" ]; then
  reg='((x|X)86_64)|((i|I)386)'
  cat $logFile | while read line
  do
    # echo $line
    if [[ "$line" =~ $reg ]];then
      echo  "error: $line contain i386 or x86_64"

    fi

  done


else
  reg='i386 x86_64 armv7 arm64'

  cat $logFile | while read line
  do
    # echo $line
    if [[ "$line" =~ $reg ]];then
      echo  ""
    else
      echo  "error: $line unContain armv7 or arm64"
    fi
    
  done



fi
