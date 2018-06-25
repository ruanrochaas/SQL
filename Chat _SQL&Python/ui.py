# -*- coding: utf-8 -*-
"""
Created on Tue Jun 12 16:18:26 2018

@author: ruan_
"""

import integracao

def cmd():
    comando = input("Digite o comando ou help: ")
    cmd = []
    cmd.append(comando)
    if comando == "addUser":
        comando2 = input ("Digite o nome do usuário: ")
        cmd.append(comando2)
        
    elif comando == "addGroup":
        comando2 = input("Digite o nome do grupo: ")
        cmd.append(comando2)
        comando3 = input("Digite o nome do administrador do grupo: ")
        cmd.append(comando3)
        
    elif comando == "sendMsg":
        comando2 = input("Digite o nome do usuário: ")
        cmd.append(comando2)
        comando3 = input("Digite o nome do grupo: ")
        cmd.append(comando3)
        comando4 = input("Digite a mensagem: ")
        cmd.append(comando4)
        
    elif comando == "addUserInGroup":
        comando2 = input("Digite o nome do usuário: ")
        cmd.append(comando2)
        comando3 = input("Digite o nome do grupo: ")
        cmd.append(comando3)
        
    elif comando == "upDateAdminGroup":
        comando2 = input("Digite o nome do grupo: ")
        cmd.append(comando2)
        comando3 = input("Digite o nome do novo administrador: ")
        cmd.append(comando3)
        
    elif comando == "upDateUserName":
        comando2 = input("Digite o atual nome do usuário: ")
        cmd.append(comando2)
        comando3 = input("Digite o novo nome do usuário: ")
        cmd.append(comando3)
        
    elif comando == "upDateGroupName":
        comando2 = input("Digite o atual nome do grupo: ")
        cmd.append(comando2)
        comando3 = input("Digite o novo nome do grupo: ")
        cmd.append(comando3)
        
    elif comando == "findMsgs":
        comando2 = input("Digite o nome do usuário: ")
        cmd.append(comando2)
        comando3 = input("Digite o nome do grupo: ")
        cmd.append(comando3)
        
    elif comando == "readMsgsGroup":
        comando2 = input("Digite o nome do grupo: ")
        cmd.append(comando2)
        
    elif comando == "delUser":
        comando2 = input("Digite o nome do usuário: ")
        cmd.append(comando2)
        
    elif comando == "delGroup":
        comando2 = input("Digite o nome do grupo: ")
        cmd.append(comando2)
        
    elif comando == "delMsg":
        comando2 = input("Digite o id da mensagem: ")
        cmd.append(comando2)
        
    elif comando == "viewUserInGroup":
        comando2 = input("Digite o nome do grupo: ")
        cmd.append(comando2)
        
    return cmd

def verificarCmd(cmd):
    listaComandos = ["addUser","readMsgsGroup","delUser","delGroup","delMsg","viewUserInGroup","addGroup","addUserInGroup","upDateAdminGroup","upDateUserName","upDateGroupName","findMsgs","sendMsg","viewUsers","viewGroups","help","fim"]
    helpTexto = "\nLista de Comandos\naddUser\naddGroup\nsendMsg\naddUserInGroup\nupDateAdminGroup\nupDateUserName\nupDateGroupName\nfindMsgs\nreadMsgsGroup\ndelUser\ndelGroup\ndelMsg\nviewUsers\nviewGroups\nviewUserInGroup\nfim"
    if cmd[0] == "":
        print("Favor digitar um comando.")
        return False
    elif cmd[0] not in listaComandos:
        print("Comando inexistente.")
        return False
    elif cmd[0] == "help":
        print(helpTexto)
        return False
    elif (cmd[0] == "addUser" or cmd[0] == "readMsgsGroup" or cmd[0] == "delUser" or cmd[0] == "delGroup" or cmd[0] == "delMsg" or cmd[0] == "viewUserInGroup") and len(cmd) < 2:
        print("Dados insuficientes. Favor digite todos os dados necessários.")
        return False
    elif (cmd[0] == "addGroup" or cmd[0] == "addUserInGroup" or cmd[0] == "upDateAdminGroup" or cmd[0] == "upDateUserName" or cmd[0] == "upDateGroupName" or cmd[0] == "findMsgs") and len(cmd) < 3:
        print("Dados insuficientes. Favor digite todos os dados necessários.")
        return False
    elif cmd[0] == "sendMsg" and len(cmd) < 4:
        print("Dados insuficientes. Favor digite todos os dados necessários.")
        return False
    else:
        return True

def verifUserName(cur, unome):
    if integracao.verifUserName(cur, unome):
        print("Nome de usuário já existe.")
        return False
    return True

def verifGroupName(cur, gnome):
    if integracao.verifGroupName(cur, gnome):
        print("Nome de Groupo já existe.")
        return False
    return True

def verifUserName2(cur, unome):
    if not integracao.verifUserName(cur, unome):
        print("Nome de usuário inexistente.")
        return False
    return True
    
def verifGroupName2(cur, gnome):
    if not integracao.verifGroupName(cur, gnome):
        print("Nome de Groupo inexistente.")
        return False
    return True

def verifIdMsg(cur, mid):
    if not integracao.veriIdMsg(cur, mid):
        print("Id de mensagem inexistente.")
        return False
    return True

def findMsgs(rows):
    print("")
    for i in rows:
        print(i[0], i[1])

def readMsgsGroup(cur, rows):
    print("")
    for i in rows:
        cur.execute("select unome from usuario Us, mensagem Me where Us.uid=Me.uid and Me.msg='" + i[0] + "'")
        nome = cur.fetchone()[0]
        print(nome + " diz: " + i[0])

def viewUsers(rows):
    print("")
    for i in rows:
        print(i[0])

def viewGroups(rows):
    print("")
    for i in rows:
        print(i[0])

def viewUserInGroup(rows):
    print("")
    for i in rows:
        print(i[0])

def confirmacao(cmd):
    if cmd == "addUser":
        print("Usuário cadastrado com sucesso.")
    elif cmd == "addGroup":
        print("Grupo cadastrado com sucesso.")
    elif cmd == "sendMsg":
        print("Mensagem enviada.")
    elif cmd == "addUserInGroup":
        print("Usuário adicionado ao grupo.")
    elif cmd == "upDateAdminGroup":
        print("Administrador alterado.")
    elif cmd == "upDateUserName":
        print("Nome de usuário alterado com sucesso.")
    elif cmd == "upDateGroupName":
        print("Nome de grupo alterado com sucesso.")
    elif cmd == "delUser":
        print("Usuário excluído")
    elif cmd == "delGroup":
        print("Grupo excluído")
    elif cmd == "delMsg":
        print("Mensagem excluída")
        
