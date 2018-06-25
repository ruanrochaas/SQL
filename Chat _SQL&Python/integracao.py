# -*- coding: utf-8 -*-
"""
Created on Tue Jun 12 16:14:23 2018

@author: ruan_
"""

class Mensagem:
    def __init__(self, cur, conn, unome, gnome, msg):
        cur.execute("select max(mid) from mensagem")
        var = cur.fetchone()[0]
        if var is None:
            ident = "1"
        else:
            ident = str(int(var) + 1)
        frase = "insert into mensagem values(" + ident +"," + findIdUser(cur, unome) + "," + findIdGroup(cur, gnome) + ",'" + msg + "')"
        cur.execute(frase)
        conn.commit()
        
class Usuario:
    def __init__(self, cur, conn, unome):
        cur.execute("select max(uid) from usuario")
        var = cur.fetchone()[0]
        if var is None:
            ident = "1"
        else:
            ident = str(int(var) + 1)
        frase = "insert into usuario values(" + ident + ",'" + unome + "')"
        cur.execute(frase)
        conn.commit()

class Grupo:
    def __init__(self, cur, conn, gnome, unome):
        cur.execute("select max(gid) from grupo")
        var = cur.fetchone()[0]
        if var is None:
            ident = "1"
        else:
            ident = str(int(var) + 1)
        idAdmin = findIdUser(cur, unome)
        frase = "insert into grupo values(" + ident + ",'" + gnome + "'," + idAdmin + ");\n" + "insert into usuarios_grupos values (" + ident + "," + idAdmin + ");"
        cur.execute(frase)
        conn.commit()

def findIdUser(cur, nome):
    cur.execute("select uid from usuario where unome='" + nome + "'")
    return str(cur.fetchone()[0])
    
def findIdGroup(cur, nome):
    cur.execute("select gid from grupo where gnome='" + nome + "'")
    return str(cur.fetchone()[0])

def addUserInGroup(cur, conn, nomeUser, nomeGrupo):
    cur.execute("insert into usuarios_grupos values(" + findIdGroup(cur, nomeGrupo) + "," + findIdUser(cur, nomeUser) + ")")
    conn.commit()

def upDateAdminGroup(cur, conn, gnome,unome):
    cur.execute("update grupo set id_admin=" + findIdUser(cur, unome) + " where gid=" + findIdGroup(cur, gnome))
    conn.commit()

def upDateUserName(cur, conn, unome, novoNome):
    cur.execute("update usuario set unome='" + novoNome + "' where uid=" + findIdUser(cur, unome))
    conn.commit()

def upDateGroupName(cur, conn, gnome, novoNome):
    cur.execute("update grupo set gnome='" + novoNome + "' where gid=" + findIdGroup(cur,   gnome))
    conn.commit()

def findMsgs(cur, unome, gnome):
    cur.execute("select mid, msg from mensagem where uid=" + findIdUser(cur, unome) + " and gid=" + findIdGroup(cur, gnome))
    rows = cur.fetchall()
    return rows

def readMsgsGroup(cur, gnome):
    cur.execute("select msg from mensagem Me where gid=" + findIdGroup(cur, gnome))
    rows = cur.fetchall()
    return cur, rows

def delUser(cur, conn, unome):
    cur.execute("delete from usuario where uid=" + findIdUser(cur, unome))
    conn.commit()

def delGroup(cur,conn,gnome):
    cur.execute("delete from grupo where gid=" + findIdGroup(cur, gnome))
    conn.commit()

def delMsg(cur, conn, idMsg):
    cur.execute("delete from mensagem where mid=" + idMsg)
    conn.commit()

def viewUsers(cur):
    cur.execute("select unome from usuario")
    rows = cur.fetchall()
    return rows
    
def viewGroups(cur):
    cur.execute("select gnome from grupo")
    rows = cur.fetchall()
    return rows
    
def viewUserInGroup(cur, gnome):
    cur.execute("select unome from usuario U, usuarios_grupos UG where U.uid=UG.uid and UG.gid=" + findIdGroup(cur, gnome))
    rows = cur.fetchall()
    return rows

def checkUserName(cur, unome):
    cur.execute("select unome from usuario")
    rows = cur.ferchall()
    for i in rows:
        if i[0] == unome:
            return True
    return False

def fim(cur, conn):
    cur.close()
    conn.close()
    
def verifUserName(cur, unome):
    cur.execute("select unome from usuario")
    rows = cur.fetchall()
    for i in rows:
        if i[0] == unome:
            return True
    return False

def verifGroupName(cur, gnome):
    cur.execute("select gnome from grupo")
    rows = cur.fetchall()
    for i in rows:
        if i[0] == gnome:
            return True
    return False

def veriIdMsg(cur, mid):
    cur.execute("select mid from mensagem")
    rows = cur.fetchall()
    for i in rows:
        if str(i[0]) == str(mid):
            return True
    return False
