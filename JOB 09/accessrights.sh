#!/bin/bash

# Spécifiez le chemin du fichier CSV
csv_file="/mnt/c/Users/maxim/Downloads/Shell_Userlist.csv"

# Fonction pour créer un utilisateur et attribuer des permissions
create_user_and_assign_permissions() {
    local id="$1"
    local prenom="$2"
    local nom="$3"
    local mdp="$4"
    local role="$5"

    if id "$prenom" &>/dev/null; then
        echo "L'utilisateur $prenom existe déjà."
    else
        # Créez l'utilisateur en spécifiant le nom complet avec des guillemets
        sudo useradd -m -p "$(echo "$mdp" | openssl passwd -1 -stdin)" -c "$prenom $nom" "$prenom"

        if [ "$role" == "Admin" ]; then
            # Ajoutez l'utilisateur au groupe "sudo" pour lui accorder des privilèges de superutilisateur
            sudo usermod -aG sudo "$prenom"

            # Assurez-vous que le groupe "superutilisateur" existe (s'il n'existe pas, il sera créé)
            sudo groupadd -f superutilisateur

            # Ajoutez l'utilisateur au groupe "superutilisateur"
            sudo usermod -aG superutilisateur "$prenom"

            echo "$prenom a été mis à jour en super utilisateur et ajouté au groupe sudo."
        else
            echo "$prenom ne sera pas mis à jour en super utilisateur."
        fi
    fi
}

# Affiche le contenu du fichier CSV en utilisant column
cat "$csv_file" | column -t -s ","

# Parcours du fichier CSV (à partir de la deuxième ligne) et création d'utilisateurs
tail -n +2 "$csv_file" | while IFS=',' read -r id prenom nom mdp role; do
    echo "Lecture : id=$id, prenom=$prenom, nom=$nom, mdp=$mdp, role=$role"
    create_user_and_assign_permissions "$id" "$prenom" "$nom" "$mdp" "$role"
    echo "Fin de la création de l'utilisateur $prenom"
done

# Affiche les utilisateurs du groupe "superutilisateur"
echo "Utilisateurs du groupe superutilisateur :"
getent group superutilisateur | cut -d ':' -f 4 | tr ',' ' '
