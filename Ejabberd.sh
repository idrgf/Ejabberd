#!/bin/bash

#Menu selection du choix
echo "séléctionnez votre choix: "

##########################  FONCTIONS  ##########################

function Install_Ejabberd () {
    #Vérfier si wget est installé, 0=true et 1=false
    which wget
    if [ $? = 0 ]; then

        #On télécharge le fichier URL et le renomme afin d'installer Ejabberd
        wget -O ejabberd.deb "https://www.process-one.net/downloads/downloads-action.php?file=/21.07/ejabberd_21.07-0_amd64.deb"
        
        #On autorise les droits d'execution utilisateur
        chmod +x ejabberd.deb

        cd .

        #On télécharge les dépendances
        apt install glibc-source
        
        #On installe Ejabberd
        apt install ejabberd
        
        #On démarre Ejabberd
        /etc/init.d/ejabberd start

    else
        #Si wget n'est pas installé
        read -p "wget n'est pas installé.\n Tapez [1] pour l'installer sinon tapez n'importe quelle touche." wg

        if [[ $wg -eq 1 ]]; then
            apt-get install wget
        else
        exit 1
        fi
    fi

    
}

function Create_User () {
    #On demande un nom et un mot de passe
    read -p "veillez entrer un nom " user
    read -p "veillez entrer un mdp " password
    
    #On entre dans le dossier bin
    cd /opt/ejabberd-21.07/bin
    
    #On y ajoute le nom et le mot de passe
    ./ejabberdctl register $user localhost $password
    
    #On re démarre Ejabberd 
    /etc/init.d/ejabberd restart
}

function Desinstall_Ejabberd () {
    #On supprime ejabberd
    sudo apt-get remove --purge ejabberd
}


##########################  ON APPELLE NOS FONCTIONS  ##########################

#Boucle infini
while true
    do
        echo "1- Installer Ejabberd tapez -------> [1]"
        echo "2- Créer des utilisateurs tapez ---> [2]"
        echo "3- Désinstaller Ejabberd tapez ----> [3]"
        read CHOICE

    #Afin d'éviter des if à répétition nous utilisons dans ce cas #case
    #    pour appeler nos fonctions selon la réponse choisie.
    #(*) On sort de la boucle pour toute autre touche appuyé
    case $CHOICE in
        1) Install_Ejabberd;;
        2) Create_User;;
        3) Desinstall_Ejabberd;;
        *) break;;
    esac
done