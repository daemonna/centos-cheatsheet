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
# Purpose : user management for CentOS 7
# Usage : run without paramaters to see usage
#



# TERMINAL COLORS -----------------------------------------------------------------

NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
BLACK='\033[30m'
BLUE='\033[34m'
VIOLET='\033[35m'
CYAN='\033[36m'
GREY='\033[37m'

function print_banner {
echo "---------------------------------------------------------------------------------"
echo "                                   __  .__   "
echo " __ __  ______ ___________   _____/  |_|  |  "
echo "|  |  \/  ___// __ \_  __ \_/ ___\   __\  |  "
echo "|  |  /\___ \\  ___/|  | \/\  \___|  | |  |__"
echo "|____//____  >\___  >__|    \___  >__| |____/"
echo "           \/     \/            \/           "
echo "---------------------------------------------------------------------------------"
echo "User control script for CentOS 7.x https://github.com/daemonna/centos-cheatsheet"
echo "---------------------------------------------------------------------------------"
}


useradd -Z user_u -s $shell -m -d $homedir -g $group $user
cd $homedir
su $user
ssh-keygen -t ecdsa -q -N ""
semanage login -a -s user_u
semanage fcontext -a -t ssh_home_t /home/$user/.ssh/
restorecon -v /home/$user/.ssh/


# MAIN ######################################################################



case "$1" in
start)
        tc_start
        ;;
printtree) print_tree
        ;;
printtc) print_tc_tree
        ;;
generatetc) generate_file $2
	;;
stop)   tc_remove
        ;;        
restart) tc_remove
        tc_start
        ;;

status)
        echo -e "${GREEN}= IPSET =========================================${NONE}";
        ipset -L;
        echo -e "${GREEN}= IPTABLES ======================================${NONE}";
        iptables -L -n -v --line-numbers;
	tc_print_counters
        ;;

version)
        print_banner
        ;;

*)
        echo "usage: $0 (start|printtree|printtc|generatetc <generated.file>|stop|restart|status|version)"
        exit 1
esac

exit $?
