#ifndef CLISTMODEL_H
#define CLISTMODEL_H

#include "cdatabase.h"
#include <QAbstractListModel>
#include <QStringList>
class CListModel : public QAbstractListModel
{
    Q_OBJECT

    public:
        enum Roles {
            ColorRole = Qt::UserRole + 1,
            TextRole
        };

        CListModel(QObject *parent = 0);

        virtual int rowCount(const QModelIndex &parent) const;
        virtual QVariant data(const QModelIndex &index, int role) const;
        virtual QHash<int, QByteArray> roleNames() const;
        //добавить элемент, вызывается из формы
        Q_INVOKABLE void add(QStringList strList);
        Q_INVOKABLE void curItemView(int curInd);
        //удалить элемент, вызывается из формы
        Q_INVOKABLE void del(int curInd);
        Q_INVOKABLE void delItem(int curId);
        //возвращает id элемента (по индексу на форме), вызывается из формы
        Q_INVOKABLE int getId(int curInd);
        //возвращает описание элемента, поля по порядку, вызывается из формы
        Q_INVOKABLE QVariant getItem(int curInd);
        //редактировать текущий элемент, на входе новые значения
        Q_INVOKABLE void editItem(QStringList strList);


    private:
        //список заявок
        QList<CDataBase::TDbNote> listNote;
        //номер (порядковый в представлении) заявки
        int curItemInd;
};

#endif // CLISTMODEL_H
