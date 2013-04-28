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

#include "missile_engine.h"
#include "network_manager.h"
#include <QStringList>
#include <QtPlugin>
#include <QDeclarativeItem> // For using qmlRegisterType
#include <QDebug>

MissileEngine::MissileEngine(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
{
    //! ToDo: Need to make UI interface to get listening port for the
    //!  socket.
    m_NetworkMgr = new NetworkManager(2000,*this);
    music = Phonon::createPlayer(Phonon::MusicCategory, Phonon::MediaSource(":/sfx/music.mp3"));
    sfx0 = Phonon::createPlayer(Phonon::MusicCategory, Phonon::MediaSource(":/sfx/hit.wav"));
    sfx1 = Phonon::createPlayer(Phonon::MusicCategory, Phonon::MediaSource(":/sfx/fire.wav"));
    playSound(1);
}

MissileEngine::~MissileEngine()
{
    delete m_NetworkMgr;
    delete music;
    delete sfx0;
    delete sfx1;
}

void MissileEngine::receivedRemoteMissile(int remote_x, bool isFired)
{
    Q_EMIT remoteMissileFired(remote_x, isFired);
}

void MissileEngine::fireMissile(int x_pos, bool isFired)
{
    QByteArray block;
    QDataStream out(&block, QIODevice::ReadWrite);
    out<<x_pos;
    out<<isFired;
    m_NetworkMgr->SendDataToRemotePlayer(block);
}

void MissileEngine::ConnectToRemotePlayer(const QString& aServerIP, const QString& aPort)
{
    m_NetworkMgr->ConnectToRemotePlayer(aServerIP, aPort.toInt());
    qDebug()<<Q_FUNC_INFO<<" IP: "<<aServerIP<<" Port: "<<aPort;
}

void MissileEngine::receivedRemoteConnection(const QString& remoteIP,
                                                   const int remotePort)
{
    Q_EMIT remoteConnectionRequestedBy(remoteIP,remotePort);
}

void MissileEngine::socketDisconnected()
{
    Q_EMIT connectionDisconnected();
}

void MissileEngine::playSound(int wav)
{
    switch(wav)
    {
    case 1:
        music->play();
        break;
    case 2:
        //qDebug() << "State: " << sfx0->state();
        sfx0->seek(0);
        sfx0->play();
        break;
    case 3:
        sfx1->seek(0);
        sfx1->play();
        break;
    }
}

void MissileEnginePlugin::registerTypes(const char *uri)
{
    Q_UNUSED(uri)
    // MissileEngine is registered to QML system with the specified version number.
    // MissileEngine becomes the QML element name. In order to use MissileEngine class,
    // use "import MeeGoCalculator 1.0"
    qmlRegisterType<MissileEngine>("MeeGoMissile", 1, 0, "MissileEngine");
}

// meegocalculatorplugin = name of the plugin library, this is declared in .pro like
// TARGET = meegocalculatorplugin.
// MissileEnginePlugin = name of the class which register MissileEngine class
Q_EXPORT_PLUGIN2(missleplugin, MissileEnginePlugin)
