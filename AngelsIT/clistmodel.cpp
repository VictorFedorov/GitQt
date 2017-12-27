//----------------------------------------------------------------------------------------------------------
#include "clistmodel.h"
//----------------------------------------------------------------------------------------------------------
CListModel::CListModel(QObject *parent):
    QAbstractListModel(parent)
{
}
//----------------------------------------------------------------------------------------------------------
int CListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    return m_data.size();
}
//----------------------------------------------------------------------------------------------------------
QVariant CListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    switch (role) {
    case ColorRole:
        return QVariant(index.row() < 3 ? "orange" : "skyblue");
    case TextRole:
        return m_data.at(index.row());
    default:
        return QVariant();
    }
}
//----------------------------------------------------------------------------------------------------------
QHash<int, QByteArray> CListModel::roleNames() const
{
    QHash<int, QByteArray> roles = QAbstractListModel::roleNames();
    roles[ColorRole] = "color";
    roles[TextRole] = "text";

    return roles;
}
//----------------------------------------------------------------------------------------------------------
void CListModel::add(QStringList strList)
{
    int countNotes = (strList.size() -1) / 5;
    if(countNotes > 0){
        beginInsertRows(QModelIndex(), m_data.size(), m_data.size() + countNotes);
        for(int i=0; i < strList.size(); i+=5){
            m_data.append(strList[i+1]);
        }
    }else{
        // add in the end
        beginInsertRows(QModelIndex(), m_data.size(), m_data.size());
        m_data.append(strList[1]);
    }

    endInsertRows();

 }
//----------------------------------------------------------------------------------------------------------
void CListModel::curItemView(int curInd){
   // m_data[curInd] = QString("Current index: %1").arg(curInd);

    QModelIndex index = createIndex(curInd, curInd, static_cast<void *>(0));
    emit dataChanged(index, index);
}
//----------------------------------------------------------------------------------------------------------
void CListModel::del(int curInd){
   beginRemoveRows(QModelIndex(),curInd,curInd);
   m_data.removeAt(curInd);
   endRemoveRows();
}
//----------------------------------------------------------------------------------------------------------
