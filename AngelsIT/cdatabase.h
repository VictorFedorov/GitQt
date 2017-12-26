#ifndef CDATABASE_H
#define CDATABASE_H
#include <QSqlDatabase>

#include <QObject>

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
    void login(bool); //удачно/неудачно подключились к БД
private:
    // Сам объект базы данных, с которым будет производиться работа
    QSqlDatabase    db;
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
signals:

};

#endif // CDATABASE_H
