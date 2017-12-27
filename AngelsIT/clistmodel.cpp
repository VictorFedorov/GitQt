//----------------------------------------------------------------------------------------------------------
#include "clistmodel.h"
#include <QGuiApplication>
//----------------------------------------------------------------------------------------------------------
CListModel::CListModel(QObject *parent):
    QAbstractListModel(parent)
{
    printf("asd");
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
        for(int i=0; i < strList.size()/5 ; i+=5){

            CDataBase::TDbNote curNote;
            bool ok;
            curNote.id = strList[i].toInt(&ok, 10);
            if (!ok){
                continue;
            }
            curNote.title = strList[i+1];
            m_data.append(curNote.title);
            curNote.note = strList[i+2];
            curNote.comment = strList[i+3];
            curNote.state = (CDataBase::EState)strList[i+4].toInt(&ok, 10);
            if (!ok){
                continue;
            }
            listNote.append(curNote);
        }
    }else{
        // add in the end
        beginInsertRows(QModelIndex(), m_data.size(), m_data.size());

        CDataBase::TDbNote curNote;
        bool ok;
        curNote.id = strList[0].toInt(&ok, 10);
        curNote.title = strList[1];
        curNote.note = strList[2];
        curNote.comment = strList[3];
        if (ok){
            curNote.state = (CDataBase::EState)strList[4].toInt(&ok, 10);
        }
        if (ok){
            listNote.append(curNote);
        }
        m_data.append(curNote.title);
    }

    endInsertRows();

 }
//----------------------------------------------------------------------------------------------------------
void CListModel::curItemView(int curInd){
    m_data[curInd];
    QString("Current index: %1").arg(curInd);
    QModelIndex index = createIndex(curInd, curInd, static_cast<void *>(0));

    // передать в qml данные о записи?
    emit dataChanged(index, index);
}
//----------------------------------------------------------------------------------------------------------
void CListModel::del(int curInd){
   beginRemoveRows(QModelIndex(),curInd,curInd);
   m_data.removeAt(curInd);
   endRemoveRows();
}
//----------------------------------------------------------------------------------------------------------
