#!/bin/bash  

# The MIT License (MIT)
# 
# Copyright (c) 2016 peter.ducai@gmail.com
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

#
# Purpose : jenkins management for CentOS 7
# Usage : run without paramaters to see usage
#



if [ $(id -u) != "0" ]; then
    echo -e "${RED}"
    echo -e "###################################################"
    echo -e "# WARNING!!! NOT ROOT USER                        #"
    echo -e "# YOU NEED TO BE root TO RUN THIS SCRIPT {sudo}   #"
    echo -e "###################################################"
    echo -e "${NONE}" && tput sgr0
    exit
else
    echo "running as root.. OK"
fi


####################################################################################################
#                                                                                                  #
# GLOBAL VALUES                                                                                    #
####################################################################################################

export JENKINS_HOME="/var/lib/jenkins"
BACKUP_DIR="${HOME}/.jenkins_backup"
NOW=$(date +"%s-%d-%m-%Y")


####################################################################################################
#                                                                                                  #
# DISTRO RELATED FUNCTIONS                                                                         #
####################################################################################################


if [[ ! -d ${BACKUP_DIR} ]];then
    mkdir ${BACKUP_DIR}
fi

##############################
# determine DISTRO           #
# Arguments:                 #
#   None                     #
# Return:                    #
#   None                     #
##############################
get_distro() {

    if [ -f /etc/redhat-release ] ; then
        HOST_DISTRO='redhat'
    elif [ -f /etc/SuSE-release ] ; then
        HOST_DISTRO="suse"
    elif [ -f /etc/debian_version ] ; then
        HOST_DISTRO="debian" # including Ubuntu!
    fi
}



##############################
# remove jenkins to distro   #
# Arguments:                 #
#   None                     #
# Return:                    #
#   None                     #
##############################
remove_jenkins() {

    case "${HOST_DISTRO}" in
    redhat) yum remove jenkins
        ;;
    suse) zypper remove jenkins 
        ;;
    debian) apt-get purge jenkins jenkins-common -y
        ;;
    *) echo "DISTRO error"
        exit 1
        ;;
    esac
}


##############################
# install jenkins to distro  #
# Arguments:                 #
#   None                     #
# Return:                    #
#   None                     #
##############################
install_jenkins() {

    echo -e "removing old install"
    remove_jenkins

    case "${HOST_DISTRO}" in
    redhat)
        wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
        rpm --import http://pkg.jenkins-ci.org/redhat-stable/jenkins-ci.org.key 
        yum install jenkins
        ;;
    suse) zypper addrepo http://pkg.jenkins-ci.org/opensuse-stable/ jenkins
        zypper install jenkins
        ;;
    debian) #check if apt/source.list contains new Jenkins Repository
        REPO_CHECK=`cat /etc/apt/sources.list|grep pkg.jenkins-ci.org/debian-stable|wc -l`
        if [[ "${REPO_CHECK}" -ge "1" ]];then
            echo "${GREEN}/etc/apt/sources.list ALREADY CONTAINS http://pkg.jenkins-ci.org/debian-stable REPOSITORY ${NONE}"
        else
            echo "Adding Jenkins repo to /etc/apt/sources.list"
            wget -q -O - http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key | sudo apt-key add -
            echo "backing up /etc/apt/sources.list"
            cp /etc/apt/sources.list /etc/apt/sources.list.backup  
            echo "deb http://pkg.jenkins-ci.org/debian-stable binary/" >> /etc/apt/sources.list
        fi
        apt-get update
        apt-get install jenkins
        ;;
    *) echo "DISTRO error"
        exit 1
        ;;
    esac
}

##############################
# install jenkins to distro  #
# Arguments:                 #
#   None                     #
# Return:                    #
#   None                     #
##############################
list_backups() {
    echo "-----------------------------------------------------"
    echo -e "-${YELLOW} AVAILABLE BACKUP FILES:      ${NONE}  -"
    echo "-----------------------------------------------------"
    ls ${BACKUP_DIR} |grep backup
    echo "-----------------------------------------------------"
}

##############################
# install jenkins to distro  #
# Arguments:                 #
#   None                     #
# Return:                    #
#   None                     #
##############################
backup_current() {
    echo "-BACKUP START----------------------------------------"
    
    #cp $JENKINS_HOME/config.xml ${BACKUP_DIR}/${NOW}_config.xml
    #tar zcvf ${BACKUP_DIR}/${NOW}_plugins.tar.gz ${JENKINS_HOME}/plugins/
    
    for f in $(ls ${JENKINS_HOME}/jobs)
    do
        echo -e "excluding workspace from ${f}"  
        excludes="${excludes} --exclude=${JENKINS_HOME}/jobs/${f}/workspace"   
    done
    echo -e "tar -zcf /jenkins_${NOW}_full-backup.tgz ${JENKINS_HOME} ${excludes}"
    tar -zcf ${BACKUP_DIR}/jenkins_${NOW}_full-backup.tgz ${JENKINS_HOME} ${excludes}
}

##############################
# install jenkins to distro  #
# Arguments:                 #
#   None                     #
# Return:                    #
#   None                     #
##############################
restore() {
    echo "-----------------------------------------------------"
    if [[ -z $1 ]];then
        echo -e "restore not specified.. "
        list_backups
        exit 1
    else
        echo -e "RESTORING BACKUP ${BACKUP_DIR}/$1"
        echo -e "tar -xf ${BACKUP_DIR}/$1"
        tar -xf ${BACKUP_DIR}/$1
    fi
}

list_jobs() {
    echo -e "--------------------------------------------------"
    echo -e "JOBS:"
    for f in $(ls ${JENKINS_HOME}/jobs)
    do
        echo -e "${f}"
    done
    echo -e "--------------------------------------------------"
}


##############################
# install jenkins to distro  #
# Arguments:                 #
#   None                     #
# Return:                    #
#   None                     #
##############################
set_auto_backup() {
    echo -e "set up cron date:"
    echo -e "* * * * * *"
    echo -e "| | | | | | "
    echo -e "| | | | | +-- Year              (range: 1900-3000)"
    echo -e "| | | | +---- Day of the Week   (range: 1-7, 1 standing for Monday)"
    echo -e "| | | +------ Month of the Year (range: 1-12)"
    echo -e "| | +-------- Day of the Month  (range: 1-31)"
    echo -e "| +---------- Hour              (range: 0-23)"
    echo -e "+------------ Minute            (range: 0-59)"
    echo -e "Default value is set to:"
    echo -e "0 0 * * * *                         Daily at midnight"
    echo -e "enter new value [0 0 * * * *]"
    read crontime
    if [[ -z ${crontime} ]];then
        crontime="0 0 1 * *"
        echo -e "no value specified, setting cron to do monthly backups"
        echo "${crontime} tar -zcvf ${BACKUP_DIR}/jenkins_${NOW}_full-backup.tgz ${JENKINS_HOME}" >> /var/spool/cron/crontabs/root
    else 
        echo "${crontime} tar -zcvf ${BACKUP_DIR}/jenkins_${NOW}_full-backup.tgz ${JENKINS_HOME}" >> /var/spool/cron/crontabs/root
    fi
    
    echo "monthly backup set in Cron.."
}
 

print_banner() {
    echo -e "Jenkins installer 0.1 (${HOST_DISTRO})"
}

print_usage() {
    echo -e "USAGE:"
    echo -e "--help"
    echo -e "--install-jenkins"
    echo -e "--remove-jenkins"
    echo -e "--list-backups"
    echo -e "--backup"
    echo -e "--restore"
    echo -e "--set-auto-backup"
}

#########################################################################################
#                                                                                       #
# MAIN FUNCTION                                                                         #
#########################################################################################


get_distro
print_banner

if [[ $# -lt 1 ]];then
    print_usage
fi

for i in "$@"
do
case $i in
    --help) print_usage
        ;;
    --install-jenkins) install_jenkins
        ;;
    --remove-jenkins) remove_jenkins
        ;;
    --list-backups) list_backups
        ;;
    --backup) backup_current
        ;;
    --restore) restore
        ;;
    --list-jobs) list_jobs
        ;;
    *) echo "invalid option ${i}!!!" 
        print_usage
        exit 1
        ;;
esac
done


exit $?
