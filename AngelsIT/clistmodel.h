#ifndef CLISTMODEL_H
#define CLISTMODEL_H

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

        Q_INVOKABLE void add();
        Q_INVOKABLE void curItemView(int curInd);
        Q_INVOKABLE void del(int curInd);

    private:
        QStringList m_data;
};

#endif // CLISTMODEL_H
