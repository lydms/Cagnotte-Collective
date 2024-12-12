// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CagnotteCollective {
    // Adresse de l'organisateur (celui qui déploie le contrat)
    address public organisateur;
   
    // Événements pour suivre les transactions
    event Depot(address indexed donneur, uint256 montant);
    event Retrait(address indexed organisateur, uint256 montant);

    // Constructeur : initialise l'organisateur
    constructor() {
        organisateur = msg.sender; // L'organisateur est celui qui déploie le contrat
    }

    // Fonction pour déposer de l'argent dans la cagnotte
    function deposer() public payable {
        require(msg.value > 0, "Le montant doit etre superieur a 0.");
        emit Depot(msg.sender, msg.value);
    }

    // Fonction pour consulter le solde total
    function solde() public view returns (uint256) {
        return address(this).balance;
    }

    // Fonction pour retirer les fonds (seulement l'organisateur)
    function retirer() public {
        require(msg.sender == organisateur, "Seul l'organisateur peut retirer les fonds.");
        uint256 montant = address(this).balance; // Total des fonds
        require(montant > 0, "Aucun fonds disponible a retirer.");
       
        // Transfert des fonds à l'organisateur
        (bool succes, ) = organisateur.call{value: montant}("");
        require(succes, "Echec du transfert.");
       
        emit Retrait(organisateur, montant);
    }
}