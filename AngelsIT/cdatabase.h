#ifndef CDATABASE_H
#define CDATABASE_H
#include <QSqlDatabase>
#include <QSqlQuery>

#include <QObject>
#include <QVariant>

class CDataBase : public QObject
{
    Q_OBJECT
public:
    explicit CDataBase(QObject *parent = nullptr);
    ~CDataBase();
       /* Методы для непосредственной работы с классом
        * Подключение к базе данных и вставка записей в таблицу
        * */
signals:
    // Сигнал для передачи данных в qml-интерфейс
    void loginDb(QVariant, QVariant); //удачно/неудачно подключились к БД; пользователь/администратор
    void refreshDb(QVariant); //отобразить обновленные данные БД
    void deleteItem(QVariant); //
private:
    // Сам объект базы данных, с которым будет производиться работа
    QSqlDatabase    db;
    QSqlQuery sqlQuery;
public:
    // role of users
    enum ERole{
        UserRole,
        AdminRole
    };
    struct TDbUser{
        int userId;
        QString userName;
        ERole role;
    } curUser;
    // state of job
    enum EState{
        FirstState,
        StateNew,
        StateWork,
        StateDone
    };
    struct TDbNote{
        int id;
        QString title;
        QString note;
        QString comment;
        EState  state;
        bool operator ==(const TDbNote &val){
            if(this->id != val.id){
                return false;
            }
            if(this->title != val.title){
                return false;
            }
            if(this->note != val.note){
                return false;
            }
            if(this->comment != val.comment){
                return false;
            }
            if(this->state != val.state){
                return false;
            }
            return true;
        }
        bool operator !=(const TDbNote &val){
            return !operator ==(val);
        }
    };
private:
    QList<TDbNote> listNote;
private:
    /* Внутренние методы для работы с базой данных
     * */
    //bool openDataBase();        // Открытие базы данных
    void closeDataBase();       // Закрытие базы данных
    void createTables();         // Создание базы

public slots:
    Q_INVOKABLE bool connectToDataBase(QString username, QString password, QString host="localhost", QString database="my_schema");
public slots:
    Q_INVOKABLE void login(QString userName, QString userPas);
    void refreshDbData();
    void delElem(int idElem);
    void addNewElem(QString, QString, QString, int);
    void editElem(int id, QString, QString, QString, int);
    void refreshData();
signals:

};

#endif // CDATABASE_H
