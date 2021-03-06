#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>

#include <QDebug>
#include <QPluginLoader>


#include <clistmodel.h>
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

    // подключение сигналов для формы входа
    QObject* loginIdObj = root->findChild<QObject*>("loginId");

    if(loginIdObj!=nullptr){
    QObject::connect(loginIdObj, SIGNAL(loginSignal(QString, QString)),
                     db, SLOT(login(QString, QString)));

    QObject::connect(db, SIGNAL(loginDb(QVariant, QVariant)),
                         loginIdObj, SLOT(loginDb(QVariant, QVariant)));
}
    QObject::connect(db, SIGNAL(refreshDb(QVariant)),
                         root, SLOT(refreshDb(QVariant)));


    // сигнал удаления записи
    QObject* delButton = root->findChild<QObject*>("delButton");
    if(delButton != nullptr){
        QObject::connect(delButton, SIGNAL(delElem(int)),
                         db, SLOT(delElem(int)));
    }
    // сигнал добавления записи
    QObject* itemDialogObj = root->findChild<QObject*>("newItemDialog");
    if(delButton != nullptr){
        QObject::connect(itemDialogObj, SIGNAL(addNewElem(QString, QString, QString, int)),
                         db, SLOT(addNewElem(QString, QString, QString, int)));
        QObject::connect(itemDialogObj, SIGNAL(editElem(int, QString, QString, QString, int)),
                         db, SLOT(editElem(int, QString, QString, QString, int)));
    }


    // сигнал удаления записи
    QObject* refreshButton = root->findChild<QObject*>("refreshButton");
    if(delButton != nullptr){
        QObject::connect(refreshButton, SIGNAL(refreshData()),
                         db, SLOT(refreshData()));
    }
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
