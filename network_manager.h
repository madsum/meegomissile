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

#ifndef NETWORK_MANAGER_H
#define NETWORK_MANAGER_H

#include <QObject>

class MissileEngine;
class QTcpSocket;
class QTcpServer;

class NetworkManager : public QObject
{
Q_OBJECT

public:
    NetworkManager( int aPort, MissileEngine& aEngine );
    ~NetworkManager();

public:
    void ConnectToRemotePlayer(const QString& aServerIP, int aPort);
    void SendDataToRemotePlayer( QByteArray& aDataStream ) const;

public Q_SLOTS:
    void newIncomingConn();
    void readSocketData();
    void connEstablished();
    void connLost();

private:
    QTcpServer      *m_tcpServer;
    MissileEngine   &m_MisileEngine;
    QTcpSocket      *m_tcpSock;
    uint            m_RemotePort;
    QString         m_RemoteIp;
};


#endif // NETWORK_MANAGER_H

