# -*- coding: utf-8 -*-
"""
Created on Tue Jun 12 16:14:21 2018

@author: ruan_
"""

import psycopg2
import integracao
import ui

conn = psycopg2.connect("dbname=chatquixada user=postgres password=rroucahna391 host=localhost")
cur = conn.cursor()

palavra = ""
while palavra != "fim":
    cmd = ui.cmd()
    palavra = cmd[0]
    if not ui.verificarCmd(cmd):
        continue
    
    if cmd[0] == "addUser":
        if not ui.verifUserName(cur, cmd[1]):
            continue
        newUser = integracao.Usuario(cur, conn, cmd[1])
        ui.confirmacao(cmd[0])
        
    elif cmd[0] == "addGroup":
        if not ui.verifGroupName(cur, cmd[1]):
            continue
        newGroup = integracao.Grupo(cur, conn, cmd[1],cmd[2])
        ui.confirmacao(cmd[0])
        
    elif cmd[0] == "sendMsg":
        if not ui.verifUserName2(cur, cmd[1]):
            continue
        elif not ui.verifGroupName2(cur, cmd[2]):
            continue
        newMsg = integracao.Mensagem(cur, conn, cmd[1],cmd[2],cmd[3])
        ui.confirmacao(cmd[0])
        
    elif cmd[0] == "addUserInGroup":
        if not ui.verifUserName2(cur, cmd[1]):
            continue
        elif not ui.verifGroupName2(cur, cmd[2]):
            continue
        integracao.addUserInGroup(cur, conn, cmd[1],cmd[2])
        ui.confirmacao(cmd[0])
        
    elif cmd[0] == "upDateAdminGroup":
        if not ui.verifUserName2(cur, cmd[2]):
            continue
        elif not ui.verifGroupName2(cur, cmd[1]):
            continue
        integracao.upDateAdminGroup(cur, conn, cmd[1],cmd[2])
        ui.confirmacao(cmd[0])
        
    elif cmd[0] == "upDateUserName":
        if not ui.verifUserName2(cur, cmd[1]):
            continue
        elif not ui.verifUserName(cur, cmd[2]):
            continue
        integracao.upDateUserName(cur, conn, cmd[1],cmd[2])
        ui.confirmacao(cmd[0])
        
    elif cmd[0] == "upDateGroupName":
        if not ui.verifGroupName2(cur, cmd[1]):
            continue
        elif not ui.verifGroupName(cur, cmd[2]):
            continue
        integracao.upDateGroupName(cur, conn, cmd[1],cmd[2])
        ui.confirmacao(cmd[0])
        
    elif cmd[0] == "findMsgs":
        if not ui.verifUserName2(cur, cmd[1]):
            continue
        elif not ui.verifGroupName2(cur, cmd[2]):
            continue
        ui.findMsgs(integracao.findMsgs(cur, cmd[1],cmd[2]))
        
    elif cmd[0] == "readMsgsGroup":
        if not ui.verifGroupName2(cur, cmd[1]):
            continue
        res1, res2 = integracao.readMsgsGroup(cur, cmd[1])
        ui.readMsgsGroup(res1, res2)
        
    elif cmd[0] == "delUser":
        if not ui.verifUserName2(cur, cmd[1]):
            continue
        integracao.delUser(cur, conn, cmd[1])
        ui.confirmacao(cmd[0])
        
    elif cmd[0] == "delGroup":
        if not ui.verifGroupName2(cur, cmd[1]):
            continue
        integracao.delGroup(cur, conn, cmd[1])
        ui.confirmacao(cmd[0])
        
    elif cmd[0] == "delMsg":
        if not ui.verifIdMsg(cur,cmd[1]):
            continue
        integracao.delMsg(cur, conn, cmd[1])
        ui.confirmacao(cmd[0])
        
    elif cmd[0] == "viewUsers":
        ui.viewUsers(integracao.viewUsers(cur))
        
    elif cmd[0] == "viewGroups":
        ui.viewGroups(integracao.viewGroups(cur))
        
    elif cmd[0] == "viewUserInGroup":
        if not ui.verifGroupName2(cur, cmd[1]):
            continue
        ui.viewUserInGroup(integracao.viewUserInGroup(cur, cmd[1]))
        
    elif cmd[0] == "fim":
        integracao.fim(cur,conn)
        
