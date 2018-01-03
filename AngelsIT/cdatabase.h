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
    void loginDb(QVariant); //удачно/неудачно подключились к БД
    void refreshDb(QVariant); //отобразить обновленные данные БД
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
        StateNew,
        StateDone
    };
    struct TDbNote{
        int id;
        QString title;
        QString note;
        QString comment;
        EState  state;
    };
private:
    QList<TDbNote> listNote;
private:
    /* Внутренние методы для работы с базой данных
     * */
    bool openDataBase();        // Открытие базы данных
    bool restoreDataBase();     // Восстановление базы данных
    void closeDataBase();       // Закрытие базы данных
    bool createTable();         // Создание базы таблицы в базе данных

public slots:
//    bool inserIntoTable(const QVariantList &data);      // Добавление записей в таблицу
//    bool inserIntoTable(const QString &fname, const QString &sname, const QString &nik);
//    bool removeRecord(const int id); // Удаление записи из таблицы по её id
    Q_INVOKABLE bool connectToDataBase(QString username, QString password, QString host="localhost", QString database="my_schema");
public slots:
    Q_INVOKABLE void login(QString userName, QString userPas);
    void refreshDbData();
    void delElem(int idElem);
signals:

};

#endif // CDATABASE_H
