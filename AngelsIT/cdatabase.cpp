//---------------------------------------------------------------
#include "cdatabase.h"
#include <QGuiApplication>
#include <QSqlError>
//---------------------------------------------------------------
CDataBase::CDataBase(QObject *parent) : QObject(parent)
{
    //в ресурсы базу данных добавлять нельзя
//    QString path = qApp->applicationDirPath() + "/base.db";
    QString path = "D:\\work\\github\\GitQt\\AngelsIT\\base.db";

    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(path);

}
//---------------------------------------------------------------
CDataBase::~CDataBase(){
}
//---------------------------------------------------------------

//---------------------------------------------------------------

bool CDataBase::connectToDataBase(QString username, QString password, QString host, QString database){
//    db.setHostName(host);
//    db.setDatabaseName(database);
//    db.setUserName(username);
//    db.setPassword(password);
//    db.setHostName("localhost");
//    db.setDatabaseName("my_schema");
//    db.setUserName("root");
//    db.setPassword("12345678");
//    db.setPort(3306);
    bool isOpen = db.open();
//    QSqlError err =  db.lastError();
//    QString errStr;
//    errStr = err.databaseText();
//    errStr = err.driverText();
//    qDebug(errStr.toLatin1());
//    errStr = err.text();
//    (ok == true) ? (qDebug("ok")) : (qDebug("not ok"));

    if (!isOpen) {
          db.lastError().text();
    }

    return isOpen;
}

//---------------------------------------------------------------
////---------------------------------------------------------------
//// Открытие базы данных
//bool CDataBase::openDataBase(){

//}
////---------------------------------------------------------------
//// Восстановление базы данных
//bool CDataBase::restoreDataBase(){

//}
//---------------------------------------------------------------
// Закрытие базы данных
void CDataBase::closeDataBase(){
    db.close();
}
//---------------------------------------------------------------
//// Создание базы таблицы в базе данных
//bool CDataBase::createTable(){

//}
////---------------------------------------------------------------
//// Добавление записей в таблицу
//bool CDataBase::inserIntoTable(const QVariantList &data){

//}
////---------------------------------------------------------------
//// Добавление записей в таблицу
//bool CDataBase::inserIntoTable(const QString &fname, const QString &sname, const QString &nik){

//}
////---------------------------------------------------------------
//// Удаление записи из таблицы по её id
//bool CDataBase::removeRecord(const int id){

//}
//---------------------------------------------------------------
void CDataBase::login(QString userName,QString userPas){
    qDebug(__PRETTY_FUNCTION__);
    if(connectToDataBase(userName, userPas)){
        // 1. send signal to qml !!!
        QString queryStr = "SELECT * FROM t_user where t_user.name='" + userName + "'";
        QSqlQuery query = db.exec(queryStr);
        int sizeQuery = query.size();
        QString resStr;
        //пароль можно хэшировать и хранить хэш в БД, потом сравнивать только хэши
        if (query.next()){
            if(query.value("paswd").toString() == userPas){
                curUser.userName = query.value("name").toString();
                curUser.userId = query.value("id").toInt();
                curUser.role = (ERole)query.value("role").toInt();
                // 2. Запросить и отобразить список заявок
                 refreshDbData();

                emit loginDb(QVariant(true));
            } else{
                emit loginDb(QVariant(false));
            }
        }else{
            emit loginDb(QVariant(false));
        }
    }else{
        emit loginDb(QVariant(false));
    }
}
//---------------------------------------------------------------
void CDataBase::refreshDbData(){
    if(!db.isOpen()){
        return;
    }
    QString queryStr = "SELECT * FROM t_note";
    QSqlQuery query = db.exec(queryStr);
    int sizeQuery = query.size();
    while(query.next()){
        TDbNote curNote;
        curNote.id = query.value("id").toInt();
        curNote.title = query.value("title").toString();
        curNote.note = query.value("note").toString();
        curNote.comment = query.value("comment").toString();
        curNote.state = (EState)query.value("state").toInt();
        listNote.append(curNote);
    }
    QStringList strList;
    for (int i = 0; i < listNote.size(); ++i) {
        strList << QString::number (listNote.at(i).id);
        strList << listNote.at(i).title;
        strList << listNote.at(i).note;
        strList << listNote.at(i).comment;
        strList << QString::number (listNote.at(i).state);
      }
    emit refreshDb(QVariant(strList));
}
