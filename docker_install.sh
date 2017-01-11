#!/bin/bash

check_user() {
    while true
    do
        read -p "$1" check
        case ${check: -$2} in
            [Yy]*)
                return 0
                ;;
            [Nn]*)
                return 1
                ;;
            *)
                ;;
        esac
        echo "y or n please." >&2
    done
}


docker_yum_repo="[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg"
docker_yum_repo_path="/etc/yum.repos.d/docker.repo"
docker_image_path="/var/lib/docker"


install() {
    echo "Update packages..."
    sudo yum update
    if [ $? -eq 0 ]
    then
        echo "Done!"
    else
        echo "Fail..." >&2
        return $?
    fi

    if [ ! -f $docker_yum_repo_path ]
    then
        echo "Add docker yum repository"
        sudo echo $docker_yum_repo > $docker_yum_repo_path
        if [ $? -eq 0 ]
        then
            echo "Done!"
        else
            echo "Fail..." >&2
            return $?
        fi
    fi

    echo "Now installing docker..."
    sudo yum -y install docker-engine 1> /dev/null
    if [ $? -eq 0 ]
    then
        echo "Done!"
    else
        echo "Fail..." >&2
        return $?
    fi

    echo "Enable docker sevice..."
    sudo systemctl enable docker.service
    if [ $? -eq 0 ]
    then
        echo "Done!"
    else
        echo "Fail..." >&2
        return $?
    fi

    echo "Start docker service..."
    sudo systemctl start docker
    if [ $? -eq 0 ]
    then
        echo "Done!"
    else
        echo "Fail..." >&2
        return $?
    fi

    if check_user "Test for checking docker install? (Y/n):" "Y"
    then
        sudo docker run --rm hello-world
        if [ $? -eq 0 ]
        then
            echo "Done!"
        else
            echo "Fail..." >&2
            return $?
        fi
    fi
}


uninstall() {
    echo "Now uninstalling docker..."
    sudo yum -y remove docker-engine docker-engine-selinux
    if [ $? -eq 0 ]
    then
        echo "Done!"
    else
        echo "Fail..." >&2
        return $?
    fi

    if check_user "Remove image files? (y/N):" "N"
    then
        sudo rm -rf docker_image_path
        if [ $? -eq 0 ]
        then
            echo "Done!"
        else
            echo "Fail..." >&2
            return $?
        fi
    fi
}

action() {
    case "$1" in
        "install")
            install
            ;;
        "uninstall")
            uninstall
            ;;
        "help")
            help_message
            ;;
        *)
            help_message >&2
            ;;
    esac
}

help_message() {
    echo "Usage: ./docker_install.sh {install|uninstall|help}"
}

case "$#" in
    1)
        action $@
        ;;
    *)
        help_message >&2
        ;;
esac

