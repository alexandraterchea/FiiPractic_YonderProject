Proiect Fii Practic 2026 

Acesta este proiectul meu pentru modulul de DevOps. Am incercat sa pun cap la cap tot ce am invatat.

Ce am facut:
Am ridicat doua VM-uri cu Vagrant. Am modificat fisierul hosts pe masina gazda pentru acces prin hostname. Am generat cheie pe gazda si am adaugat-o pe ambele VM-uri pt logare fara parola.

Partitia / a fost extinsa la maximul disponibil.
Am generat chei SSH pe GitLab si le-am distribuit pe ambele masini virtuale.
Root CA: Creat cy nume propriu si generat certificat *.fiipractic.lan
A fost instalat pe masina gazda pentru validare certificate in browser

Playbook Ansible care configureaza Docker, Timezone, Firewall, SELinux. 
Dockerfile: foloseste eclipse-temurin:11 pt a rula aplicatia Spring Boot

Dificultati:
Instalare GitLab: erori persistente de semnatura?
Eroarea;openjdk:not found"
