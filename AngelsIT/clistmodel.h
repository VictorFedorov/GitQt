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

        Q_INVOKABLE void add(QStringList strList);
        Q_INVOKABLE void curItemView(int curInd);
        Q_INVOKABLE void del(int curInd);
        Q_INVOKABLE int getId(int curInd);
        Q_INVOKABLE QVariant getItem(int curInd);
        Q_INVOKABLE void editItem(QStringList strList);

    private:
        QList<CDataBase::TDbNote> listNote;

        //CDataBase::TDbNote note;
        QStringList m_data;
        int curItemInd;
};

#endif // CLISTMODEL_H
