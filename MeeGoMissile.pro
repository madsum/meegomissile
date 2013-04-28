# declarative module is requred to use QDeclarativeItem and similar classes
QT += declarative network phonon

# It tells Qt not to define the moc keywords signals, slots, emit, foreach
# Now simply replace all the moc keywords with corresponding Q_SIGNALS, Q_SLOTS, Q_EMIT, Q_FOREACH
CONFIG += no_keywords

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
           missile_engine.cpp \
           network_manager.cpp

HEADERS += \
   missile_engine.h \
   network_manager.h

RESOURCES += \
    gfx.qrc \
    qml.qrc \
    sfx.qrc

OTHER_FILES += \
    qml/Button.qml \
    qml/CheckBox.qml \
    qml/GameMP.qml \
    qml/GamePanel.qml \
    qml/GameSP.qml \
    qml/LBullet.qml \
    qml/LineEdit.qml \
    qml/main.qml \
    qml/MenuNewGame.qml \
    qml/Menu.qml \
    qml/MenuSettings.qml \
    qml/PButton.qml \
    qml/RBullet.qml \
    qml/Score.qml
