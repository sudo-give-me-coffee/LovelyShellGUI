#!/usr/bin/env bash


export PROJECT_ROOT="$(dirname "$(readlink -f "${0}")")"

function yad.getFieldsFromType(){
  [ "${DialogType}" = "new-user" ] && {
    echo ' --form --fixed --separator='"\n"
    echo ' --field= ':LBL
    echo ' --field=Nome de usuário:':IN
    echo ' --field=Digite a senha:':H
    echo ' --field=Confirme a senha:':H
    echo ' --field= ':LBL
    echo ' --width=600'
    return
  }

  [ "${DialogType}" = "login" ] && {
    echo ' --form --fixed --separator='"\n"
    echo ' --field= ':LBL
    echo ' --field=Usuário:':IN
    echo ' --field=Senha:':H
    echo ' --field= ':LBL
    echo ' --width=540'
    return
  }

  [ "${DialogType}" = "new-password" ] && {
    echo ' --form --fixed'
    echo ' --field= ':LBL
    echo ' --field=Digite a nova senha:':H
    echo ' --field=Confirme a senha:':H
    echo ' --field= ':LBL
    return
  }
  
  [ "${DialogType}" = "password" ] && {
    echo ' --form --fixed'
    echo ' --field= ':LBL
    echo ' --field=Digite a senha:':H
    echo ' --field= ':LBL
    return
  }
  
  [ "${DialogType}" = "input" ] && {
    echo ' --form --fixed'
    echo ' --field= ':LBL
    echo ' --field= ':IN
    echo ' --field= ':LBL
    return
  }
  
  [ "${DialogType}" = "scale" ] && {
    echo ' --form --fixed --separator='
            
    echo ' --field= ':LBL '_'
    echo ' --field= ':SCL 
    echo ' --field= ':LBL '_'
    return
  }
  
  [ "${DialogType}" = "double-input" ] && {
  
    local line1="$(echo -n "${DialogFirstInputLabel}"  | sed 's| | |g')"
    local line2="$(echo -n "${DialogSecondInputLabel}" | sed 's| | |g')"
    
    echo ' --form --fixed --width=520 --separator='"\n"
    echo ' --field= ':LBL
    echo " --field=${line1}":IN
    echo " --field=${line2}":IN
    echo ' --field= ':LBL
    return
  }
  
  [ "${DialogType}" = "text-area" ] && {
    echo ' --form --width=800 --height=480'
    echo ' --field= ':TXT
    echo ' --field= ':LBL
    return
  }
  
  [ "${DialogType}" = "time" ] && {
    echo ' --form --width=480 --fixed --columns=3 --align=center'
    echo ' --field= ':LBL '_'
    echo ' --field= ':NUM '25!0..23!2'
    echo ' --field= ':LBL '_'
    echo ' --field= ':LBL '_'
    echo ' --field= :':LBL '_'
    echo ' --field= ':LBL '_'
    echo ' --field= ':LBL '_'
    echo ' --field= ':NUM '8!0..59!5'
    echo ' --field= ':LBL '1_' 
    return
  }
  
  [ "${DialogType}" = "checklist" ] && {
    echo ' --list --width=800 --height=480 --checklist'
    echo ' --column=   :CHK --column=Descrição'
    echo ' --no-selection --grid-lines=horizontal --no-click'
    echo ' --regex-search --print-all --search-column=2'
    return
  }
  
  [ "${DialogType}" = "radiolist" ] && {
    echo ' --list --width=800 --height=480 --radiolist'
    echo ' --column=   :CHK --column=Descrição'
    echo ' --no-selection --grid-lines=horizontal --no-click'
    echo ' --regex-search --print-all --search-column=2'
    return
  }

  [ "${DialogType}" = "image-list" ] && {
    echo ' --list --width=800 --height=480'
    echo ' --column=:IMG --column=Descrição'
    echo ' --grid-lines=horizontal --no-click'
    echo ' --regex-search --print-all --search-column=2'
    return
  }
  
  [ "${DialogType}" = "image-checklist" ] && {
    echo ' --list --width=800 --height=480 --checklist'
    echo ' --column=   :CHK --column=:IMG --column=Descrição'
    echo ' --no-selection --grid-lines=horizontal --no-click'
    echo ' --regex-search --print-all --search-column=2'
    return
  }
  
  [ "${DialogType}" = "image-radiolist" ] && {
    echo ' --list --width=800 --height=480 --radiolist'
    echo ' --column=   :CHK --column=:IMG --column=Descrição'
    echo ' --no-selection --grid-lines=horizontal --no-click'
    echo ' --regex-search --print-all --search-column=2'
    return
  }
  
  [ "${DialogType}" = "text-grid" ] && {
    echo ' --list --width=800 --height=480 --no-headers --no-selection'
    
    local columns="${DialogTextGridColumns}"
    [ -z "${DialogTextGridColumns}" ] && columns=2
    eval $(echo "printf -- ' --column=:TEXT\n%.0s' {1..${columns}}")
    eval $(echo "printf -- '  \n%.0s' {1..${columns}}")
    
    return
  }
  
  [ "${DialogType}" = "list" ] && {
    echo ' --list --width=800 --height=480 --no-headers --column=   :TXT --separator='    
    return
  }
    
  [ "${DialogType}" = "image-display-list" ] && {
    echo ' --list --width=800 --no-selection --height=480 --no-headers --column=   :IMG --column=   :TXT --separator='    
    return
  }
  
  [ "${DialogType}" = "pulsating-progressbar" ] && {
    echo '  --progress --pulsate --auto-close --auto-kill --no-buttons --borders=32 --width=480 --progress-text= '    
    return
  }
  
  [ "${DialogType}" = "progressbar" ] && {
    echo '  --progress --auto-close --auto-kill --no-buttons --borders=32 --width=480 --progress-text= '    
    return
  }
}

function yad.sanitizeOutput(){
  [ "${DialogType}" = "new-password" ] && {
    DIALOG_OUTPUT=$(echo "$DIALOG_OUTPUT" | sed 's|..$||g;s|^.||g')
    
    local half=$(($(echo -n "$DIALOG_OUTPUT" | wc -c)/2))
    
    local password1=$(echo "$DIALOG_OUTPUT" | cut -c 1-half)
    local password2=$(echo "$DIALOG_OUTPUT" | cut -c $((2+half))-)
    
    [ ! "${password1}" = "${password2}" ] && {
      show "As senhas digitadas não são iguais"
      return
    }
    
    DIALOG_OUTPUT="${password1}"
    
    return
  }
  
  [ "${DialogType}" = "input" ] && {
    DIALOG_OUTPUT=$(echo "$DIALOG_OUTPUT" | sed 's|..$||g;s|^.||g')        
    return
  }
  
  [ "${DialogType}" = "password" ] && {
    DIALOG_OUTPUT=$(echo "$DIALOG_OUTPUT" | sed 's|..$||g;s|^.||g')        
    return
  }
  
  [ "${DialogType}" = "text-area" ] && {
    DIALOG_OUTPUT=$(echo "$DIALOG_OUTPUT" | sed 's|..$||g;s|\\n|\n|g')    
    return
  }
  
  [ "${DialogType}" = "time" ] && {
    DIALOG_OUTPUT=$(echo "$DIALOG_OUTPUT" | sed 's|^.||g;s|..$||g;s/||||||/\n/g')    
    return
  }
    
  [ "${DialogType}" = "login" ] && {
    DIALOG_OUTPUT=$(echo "$DIALOG_OUTPUT" | sed '1d')    
    return
  }
  
  [ "${DialogType}" = "double-input" ] && {
    DIALOG_OUTPUT=$(echo "$DIALOG_OUTPUT" | sed '1d')    
    return
  }
  
  [ "${DialogType}" = "new-user" ] && {
    DIALOG_OUTPUT=$(echo "$DIALOG_OUTPUT")
    
    local user=$(echo "$DIALOG_OUTPUT" | sed -n 2p)
    
    local password1=$(echo "$DIALOG_OUTPUT" | sed -n 3p)
    local password2=$(echo "$DIALOG_OUTPUT" | sed -n 4p)
    
    [ ! "${password1}" = "${password2}" ] && {
      show "${user},${password1},${password2}"
      return
    }
    
    DIALOG_OUTPUT="${user}\n${password1}"
    
    return
  }
  
  [ "${DialogType}" = "image-display-list" ] && {
    DIALOG_OUTPUT=""
    return
  }
  
  [ "${DialogType}" = "text-grid" ] && {
    DIALOG_OUTPUT=""
    return
  }
  
  DIALOG_OUTPUT=$(echo "$DIALOG_OUTPUT" | sed "s/||/ /1;s/|$//g;s/^TRUE/TRUE /g;s/^TRUE |/TRUE  /1;s/^FALSE|/FALSE /1")
}

function show(){

  local  oldPWD="${PWD}" 
  local  dialog_title=""
  local  dialog_description=""
  local  file_folder_dialog_switches=""
  
  cd "${PROJECT_ROOT}"
  
  export DIALOG_OUTPUT=""

  [ "${DialogType}" = "file-open" ]          &&  file_folder_dialog_switches="--file --add-preview"
  [ "${DialogType}" = "multiple-file-open" ] &&  file_folder_dialog_switches="--file --multiple --add-preview --separator=\n"
  [ "${DialogType}" = "file-save" ]          &&  file_folder_dialog_switches="--file --save"
  [ "${DialogType}" = "directory-picker" ]   &&  file_folder_dialog_switches="--file --directory --add-preview"
  
  [ -n "${file_folder_dialog_switches}" ] && {
    dialog_title=${AppTitle}
    [ -n "${DialogTitle}" ]       && dialog_title="${dialog_title} - ${DialogTitle}"
    
    DIALOG_OUTPUT=$(yad --borders=32 --center ${file_folder_dialog_switches} --borders=16 --width=740 --height=430 --fixed \
                    --filename="${PROJECT_ROOT}" --title="${dialog_title}" --window-icon="${AppIcon}")    
    local out=${?}
                                               
    DIALOG_RESULT="/bin/false"
    [ "${?}" = "0" ] && DIALOG_RESULT="/bin/true"
    return ${out}

  }
  
  [ "${DialogType}" = "font-picker" ] && {
    dialog_title=${AppTitle}
    [ -n "${DialogTitle}" ]       && dialog_title="${dialog_title} - ${DialogTitle}"
    
    DIALOG_OUTPUT=$(yad yad --font --borders=32 --fixed --center --center --width=640 --title="${dialog_title}" --window-icon="${AppIcon}")    
    local out=${?}
                                               
    DIALOG_RESULT="/bin/false"
    [ "${?}" = "0" ] && DIALOG_RESULT="/bin/true"
    return ${out}

  }
  
  local dialog_error="${1}"
  local image="--pic="
  
  local data=""
  
  [ -n "${DialogTitle}" ]       && dialog_title="<big><b>${DialogTitle}</b></big>"
  [ -n "${DialogDescription}" ] && dialog_description="\n${DialogDescription}"  
  [ -n "${dialog_error}" ]      && dialog_description="\n${DialogDescription}\n<small>\n(Erro: ${dialog_error})</small>"
  [ -n "${DialogIcon}" ]        && image="--image="
  
  [ -n "${dialog_description}" ] && {
    [ "${DialogType}" = "checklist" ]             && dialog_description="${dialog_description}\n"
    [ "${DialogType}" = "radiolist" ]             && dialog_description="${dialog_description}\n"
    [ "${DialogType}" = "image-checklist" ]       && dialog_description="${dialog_description}\n"
    [ "${DialogType}" = "image-radiolist" ]       && dialog_description="${dialog_description}\n"
    [ "${DialogType}" = "text-grid" ]             && dialog_description="${dialog_description}\n"
    [ "${DialogType}" = "list" ]                  && dialog_description="${dialog_description}\n"
    [ "${DialogType}" = "image-list" ]            && dialog_description="${dialog_description}\n"
    [ "${DialogType}" = "image-display-list" ]    && dialog_description="${dialog_description}\n"
    [ "${DialogType}" = "progressbar" ]           && dialog_description="${dialog_description}\n"
    [ "${DialogType}" = "pulsating-progressbar" ] && dialog_description="${dialog_description}\n"
  }
      
  DIALOG_OUTPUT=$(while read -t 1 -r data; do echo "$data"; done | yad --width=480 $(yad.getFieldsFromType) \
                        --text="${dialog_title}${dialog_description}" \
                        --title="${AppTitle}" --window-icon="${AppIcon}" --borders=32  \
                        --center --image-on-top ${image}"${DialogIcon}" "${DialogItemList[@]}")
                                               
  
  local out=${?}
                                               
  export DIALOG_RESULT="/bin/false"
  [ "${out}" = "0" ] && DIALOG_RESULT="/bin/true"
  
  yad.sanitizeOutput 2> /dev/null

  cd "${oldPWD}"

  return ${out}
}

[ "${1}" = "--lovely-gui-standalone" ] && {
  show 
  echo "${DIALOG_OUTPUT}"
  exit ${?}
}
