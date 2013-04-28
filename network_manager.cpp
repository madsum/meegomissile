/****************************************************************************
**
** Copyright (C) 2010 Masum Islam
** Contact: madsum@gmail.com
**
** This file is part of the MeeGoMissile
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
****************************************************************************/

#include "network_manager.h"
#include "missile_engine.h"

#include <QDebug>
#include <QtNetwork>

#define READ_BLOCK_SIZE 1024

NetworkManager::NetworkManager(int aPort, MissileEngine& aEngine) :
    m_MisileEngine(aEngine),
    m_tcpSock(NULL)
{
    m_tcpServer = new QTcpServer(this);

    if (!m_tcpServer->listen(QHostAddress::Any,aPort))
    {
        qDebug()<<"listening of m_tcpServer is failure.";
    }
    else
    {
        qDebug()<<"Player listening on port: "<<aPort;
    }

    // Slots for receiving incoming new connection
    connect(m_tcpServer, SIGNAL(newConnection()), this,
            SLOT(newIncomingConn()));

}

NetworkManager::~NetworkManager()
{
    m_tcpSock->disconnectFromHost();
    m_tcpSock->close();
    m_tcpServer->close();
    delete m_tcpSock;
    delete m_tcpServer;
}

// SLOT for reading socket data sent by remote client
void NetworkManager::readSocketData()
{
    int remote_x;
    bool isFired;
    QDataStream in ( m_tcpSock );
    in >> remote_x;
    in >> isFired;
    m_MisileEngine.receivedRemoteMissile(remote_x,isFired);
}

void NetworkManager::connEstablished()
{
    qDebug()<<__PRETTY_FUNCTION__<<"-> Connection to remote player established.";
    // Notify the UI component
    m_MisileEngine.receivedRemoteConnection(m_RemoteIp,m_RemotePort);
}

void NetworkManager::connLost()
{
    qDebug()<<__PRETTY_FUNCTION__<<"-> Connection to remote player lost.";
    m_MisileEngine.socketDisconnected();
}


void NetworkManager::ConnectToRemotePlayer(const QString& aServerIP, int aPort)
{
    // Cleanup previous tcp socket instance
    if(m_tcpSock)
    {
        m_tcpSock->close();
        delete m_tcpSock;
    }
    // Create tcp socket and connect to the remote counter part
    m_tcpSock = new QTcpSocket(this);
    m_tcpSock->connectToHost( aServerIP, aPort);
    connect(m_tcpSock, SIGNAL(connected()), this, SLOT(connEstablished()) );
    connect(m_tcpSock, SIGNAL(disconnected()), this, SLOT(connLost()));
    connect(m_tcpSock, SIGNAL(readyRead()), this, SLOT(readSocketData()) );
    m_RemotePort = aPort;
    m_RemoteIp = aServerIP;
}

void NetworkManager::newIncomingConn()
{
    if (m_tcpSock && m_tcpSock->isOpen())
    {
        m_tcpSock->close();
        delete m_tcpSock;
    }
    m_tcpSock = m_tcpServer->nextPendingConnection();
    m_MisileEngine.receivedRemoteConnection(m_tcpSock->peerAddress().toString(),
                                            m_tcpSock->peerPort());
    qDebug()<<__PRETTY_FUNCTION__<<"-> Server got new connection: "<<
              m_tcpSock->peerAddress().toString();
    connect(m_tcpSock, SIGNAL(connected()), this, SLOT(connEstablished()) );
    connect(m_tcpSock, SIGNAL(disconnected()), this, SLOT(connLost()));
    connect(m_tcpSock, SIGNAL(readyRead()), this, SLOT(readSocketData()) );
}

void NetworkManager::SendDataToRemotePlayer( QByteArray& aByteArray ) const
{
    if (m_tcpSock && m_tcpSock->isOpen())
    {
        m_tcpSock->write(aByteArray);
    }
}
