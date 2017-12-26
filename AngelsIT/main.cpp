#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>

#include <QDebug>
#include <QPluginLoader>


#include <clistmodel.h>
#include "csignalhdl.h"
#include "cdatabase.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Material");

    qmlRegisterType<CListModel>("io.clistmodel", 1, 0, "CListModel");

    QQmlApplicationEngine engine;

    CDataBase* db = new CDataBase;

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    QObject* root = engine.rootObjects()[0];

    QObject* ob = root->findChild<QObject*>("loginId");

    QObject::connect(ob, SIGNAL(qmlSignal(QString, QString)),
                     db, SLOT(login(QString, QString)));

    QObject::connect(db, SIGNAL(logonBad()),
                         ob, SLOT(getNewText()));


    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
