#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

#include <clistmodel.h>
#include "csignalhdl.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Material");


    qmlRegisterType<CListModel>("io.clistmodel", 1, 0, "CListModel");


    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    QObject* root = engine.rootObjects()[0];
    CSignalHdl* sigHdl = new CSignalHdl(root);
    //QObject::connect(root, SIGNAL(qmlSignal(QString)), sigHdl, SLOT(cppSlot(QString)));

    /*
QObject* ob = root->findChild<QObject*>("flatButton");
QObject::connect(ob, SIGNAL(qmlSignalFlatButton(QString)),
handlerSignals, SLOT(cppSlot(QString)));
     */


    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
