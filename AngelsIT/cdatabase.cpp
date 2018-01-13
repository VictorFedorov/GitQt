//---------------------------------------------------------------
#include "cdatabase.h"
#include <QGuiApplication>
#include <QSqlError>
#include <QTimer>
#include <QFile>
//---------------------------------------------------------------
CDataBase::CDataBase(QObject *parent) : QObject(parent)
{
    //в ресурсы базу данных добавлять нельзя
    QString dbFileName = qApp->applicationFilePath();
    dbFileName.append(".db");
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbFileName);
    if (!QFile::exists(dbFileName)){
        QFile dbFile(dbFileName);
        if(dbFile.open(QIODevice::WriteOnly)){
            dbFile.close();
            createTables();
        }
    }
}
//---------------------------------------------------------------
CDataBase::~CDataBase(){
    db.close();
}
//---------------------------------------------------------------
 // Создание базы
void CDataBase::createTables(){
    bool isOpen = db.open();
    if (!isOpen) {
         QString str = db.lastError().text();
         qDebug( "line:%d, %s " + str.toLatin1(), __LINE__, __PRETTY_FUNCTION__);
    }
    QString queryStr = "CREATE TABLE 't_user' ( `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `role` INTEGER NOT NULL, `paswd` TEXT )";
    QSqlQuery sqlQuery = db.exec(queryStr);
    queryStr = "CREATE TABLE `t_note` ( `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, `title` TEXT NOT NULL, `note` TEXT NOT NULL, `comment` TEXT, `state` INTEGER NOT NULL )";
    sqlQuery = db.exec(queryStr);

    QSqlQuery query(db);
    //добавим пользователей
    query.prepare("INSERT INTO t_user ( name, role, paswd) VALUES ( :name,:role,:paswd)");
    query.bindValue(":name", "user");
    query.bindValue(":role", UserRole);
    query.bindValue(":paswd", "123");
    if(query.lastError().type() != QSqlError::NoError){
        QString err = query.lastError().text();
        qDebug("line:%d, %s err is " + err.toLatin1(), __LINE__, __PRETTY_FUNCTION__);
    }else{
        query.exec();
    }
    query.prepare("INSERT INTO t_user ( name, role, paswd) VALUES ( :name,:role,:paswd)");
    query.bindValue(":name", "admin");
    query.bindValue(":role", AdminRole);
    query.bindValue(":paswd", "123");
    if(query.lastError().type() != QSqlError::NoError){
        QString err = query.lastError().text();
        qDebug("line:%d, %s err is " + err.toLatin1(), __LINE__, __PRETTY_FUNCTION__);
    }else{
        query.exec();
    }

}
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
         QString str = db.lastError().text();
         qDebug( "line:%d, %s " + str.toLatin1(), __LINE__, __PRETTY_FUNCTION__);
    }

    QTimer::singleShot(3000, this, SLOT(refreshData()));
    return isOpen;
}

//---------------------------------------------------------------
// Закрытие базы данных
void CDataBase::closeDataBase(){
    db.close();
}
//---------------------------------------------------------------
void CDataBase::login(QString userName,QString userPas){
    qDebug(__PRETTY_FUNCTION__);
    if(connectToDataBase(userName, userPas)){
        // 1. send signal to qml !!!
        QSqlQuery query(db);
        query.prepare("SELECT * FROM t_user where t_user.name=:userName");
        query.bindValue(":userName", userName);
        query.exec();
        QString resStr;
        //пароль можно хэшировать и хранить хэш в БД, потом сравнивать только хэши
        if (query.next()){
            if(query.value("paswd").toString() == userPas){
                curUser.userName = query.value("name").toString();
                curUser.userId = query.value("id").toInt();
                curUser.role = (ERole)query.value("role").toInt();
                // 2. Запросить и отобразить список заявок
                 refreshDbData();
                emit loginDb(QVariant(true), QVariant((int)curUser.role));
            } else{
                emit loginDb(QVariant(false), QVariant(false));
            }
        }else{
            emit loginDb(QVariant(false), QVariant(false));
        }
    }else{
        emit loginDb(QVariant(false), QVariant(false));
    }
}
//---------------------------------------------------------------
// обновить данные из БД
void CDataBase::refreshDbData(){
    if(!db.isOpen()){
        return;
    }
    listNote.clear();
    QString queryStr = "SELECT * FROM t_note";
    QSqlQuery query(db);
    query.exec("SELECT * FROM t_note");
    // add sql err !!!
    if(query.lastError().type() != QSqlError::NoError){
        QString err = query.lastError().text();
        qDebug("line:%d, %s err is " + err.toLatin1(), __LINE__, __PRETTY_FUNCTION__);
    }else{
        while(query.next()){
            TDbNote curNote;
            curNote.id = query.value("id").toInt();
            curNote.title = query.value("title").toString();
            curNote.note = query.value("note").toString();
            curNote.comment = query.value("comment").toString();
            curNote.state = (EState)query.value("state").toInt();
            listNote.append(curNote);
        }
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
//---------------------------------------------------------------
// удалить элемент по его id
void CDataBase::delElem(int idElem){
//    qDebug(__PRETTY_FUNCTION__);
    if(!db.isOpen()){
        return;
    }
    QSqlQuery query(db);
    query.prepare("DELETE FROM t_note WHERE t_note.id = :id");
    query.bindValue(":id", idElem);
    query.exec();
    if(query.lastError().type() != QSqlError::NoError){
        QString err = query.lastError().text();
        qDebug("err is %s", qPrintable(err));
    }
}
//---------------------------------------------------------------
//добавление элемента из формы (из модели представления)
void CDataBase::addNewElem(QString elemCaption, QString elemText, QString elemComment, int elemState){
    qDebug(__PRETTY_FUNCTION__);
    if(!db.isOpen()){
        return;
    }
    QSqlQuery query(db);
    query.prepare("INSERT INTO t_note (title, note, comment, state) VALUES (:title, :note, :comment, :state)");
    query.bindValue(":title", elemCaption);
    query.bindValue(":note", elemText);
    query.bindValue(":comment", elemComment);
    query.bindValue(":state", elemState);
    query.exec();

    if(query.lastError().type() != QSqlError::NoError){
        QString err = query.lastError().text();
        //qDebug("err is %s", err.toLatin1());
    }else{
        // сделать запрос  в БД и обновить listNode
        query.prepare("SELECT * FROM t_note WHERE t_note.title=:title and t_note.note=:note");

        query.bindValue(":title", elemCaption);
        query.bindValue(":note", elemText);
        query.exec();
        if(query.next()){
            TDbNote curNote;
            curNote.id = query.value("id").toInt();
            curNote.title = query.value("title").toString();
            curNote.note = query.value("note").toString();
            curNote.comment = query.value("comment").toString();
            curNote.state = (EState)query.value("state").toInt();
            listNote.append(curNote);
            // ?? emit 
            QStringList strList;
                strList << QString::number (curNote.id);
                strList << curNote.title;
                strList << curNote.note;
                strList << curNote.comment;
                strList << QString::number (curNote.state);
            emit refreshDb(QVariant(strList));
        }
    }
}
//---------------------------------------------------------------
//изменение параметров элемента из формы (из модели представления)
void CDataBase::editElem(int id, QString elemCaption, QString elemText, QString elemComment, int elemState){
    qDebug(__PRETTY_FUNCTION__);
    if(!db.isOpen()){
        return;
    }

    TDbNote *note=nullptr;

    for(auto curNote : listNote){
        if(curNote.id == id ){
            note = &curNote;
            break;
        }
    }
    if(note == nullptr){
        qWarning("%s , err can not find edited item", __PRETTY_FUNCTION__);
        return;
    }

    QSqlQuery query(db);
    query.prepare("UPDATE t_note SET comment=:comment, state=:state WHERE id=:id");
    query.bindValue(":comment", elemComment);
    query.bindValue(":state", elemState);
    query.bindValue(":id", note->id);
    if(query.lastError().type() != QSqlError::NoError){
        QString err = query.lastError().text();
        qDebug("err is ");
    }else{
        query.exec();
    }
}
//---------------------------------------------------------------
//обновление параметров из БД 
void CDataBase::refreshData(){
    QTimer::singleShot(5000, this, SLOT(refreshData()));
    qDebug(__PRETTY_FUNCTION__);
    if(!db.isOpen()){
        return;
    }
    // обрабатывать только измененные элементы
    QSqlQuery query(db);
    query.exec("SELECT * FROM t_note");
    // add sql err !!!
    QStringList strList;
    while(query.next()){
        TDbNote curNote;
        curNote.id = query.value("id").toInt();
        curNote.title = query.value("title").toString();
        curNote.note = query.value("note").toString();
        curNote.comment = query.value("comment").toString();
        curNote.state = (EState)query.value("state").toInt();
        bool isInsert = true;
        for(auto curNoteInList : listNote){
            if(curNoteInList.id == curNote.id){
                isInsert = false;
                if(curNoteInList != curNote){
                    isInsert = false;
                    int curNoteInListInd = listNote.indexOf(curNoteInList);
                    curNoteInList.title = curNote.title;
                    curNoteInList.note = curNote.note;
                    curNoteInList.comment = curNote.comment;
                    curNoteInList.state = curNote.state;
                    listNote.takeAt(curNoteInListInd);
                    listNote.insert(curNoteInListInd, curNoteInList);
                    //add in list
                    strList << QString::number (curNote.id);
                    strList << curNote.title;
                    strList << curNote.note;
                    strList << curNote.comment;
                    strList << QString::number (curNote.state);
                }
                break;
           }
        }
        if (isInsert){
            listNote.append(curNote);
            //add in list
            strList << QString::number (curNote.id);
            strList << curNote.title;
            strList << curNote.note;
            strList << curNote.comment;
            strList << QString::number (curNote.state);
        }
    }
    if (strList.count() > 0){
        emit refreshDb(QVariant(strList));
    }
}
//
