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

#ifndef MISSILE_ENGINE_H
#define MISSILE_ENGINE_H

#include <QObject>
#include <QVariant>
#include <QtDeclarative/QDeclarativeExtensionPlugin>
#include <QDeclarativeItem>
#include <phonon/MediaObject>
#include <phonon/AudioOutput>

class NetworkManager;

class MissileEngine : public QDeclarativeItem
{
    Q_OBJECT

public:
    explicit MissileEngine(QDeclarativeItem *parent = 0);
    ~MissileEngine();
    void receivedRemoteMissile(int remote_x, bool isFired);
    void receivedRemoteConnection(const QString& remoteIP, const int remotePort);
    void socketDisconnected();

Q_SIGNALS:
    //! Notification signals to QML views
    //! Emitted when remote received remote player x-axis movement
    //! isFire==true, when remote missile is fired.
    void remoteMissileFired(int remote_x, bool isFired);
    //! Emiited when socket received remote connection from other end.
    void remoteConnectionRequestedBy(const QString& remoteIP, const int remotePort);
    //! Emiited when socket tcp connection gets disconnected.
    void connectionDisconnected();

public Q_SLOTS:
    //! Called from QML views
    void fireMissile(int x_pos, bool isFired);
    void ConnectToRemotePlayer(const QString& aServerIP,
                               const QString& aPort);
    void playSound(int wav);

private:
    NetworkManager* m_NetworkMgr;
    Phonon::MediaObject *music;
    Phonon::MediaObject *sfx0;
    Phonon::MediaObject *sfx1;
};

class MissileEnginePlugin : public QDeclarativeExtensionPlugin
{
    Q_OBJECT

public:
    // Pure virtual method from QDeclarativeExtensionPlugin
    void registerTypes( const char * uri );
};

#endif // MISSILE_ENGINE_H
