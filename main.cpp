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
#include <QtGui/QApplication>
#include <QDeclarativeItem> // For using qmlRegisterType
#include <QDeclarativeView>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    // Register MissileEngine class as MissileEngine with version 1.0
    qmlRegisterType<MissileEngine>("MeeGoMissile", 1, 0, "MissileEngine");
    QDeclarativeView viewer;
    viewer.setSource(QUrl("qrc:/qml/main.qml"));
    viewer.setFixedSize(800,480);
    viewer.show();
    return app.exec();
}
