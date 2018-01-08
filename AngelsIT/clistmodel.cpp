//----------------------------------------------------------------------------------------------------------
#include "clistmodel.h"
#include <QGuiApplication>
#include <QDebug>
//----------------------------------------------------------------------------------------------------------
CListModel::CListModel(QObject *parent):
    QAbstractListModel(parent)
{
    curItemInd = -1;
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
    int countNotes = (strList.size()) / 5;
    if(countNotes > 1){
        listNote.clear();m_data.clear();
        beginInsertRows(QModelIndex(), 0, countNotes-1);
        for(int i=0; i < countNotes ; i++){
            CDataBase::TDbNote curNote;
            bool ok;
            curNote.id = strList[5*i].toInt(&ok, 10);
            if (!ok){
                continue;
            }
            curNote.title = strList[5*i+1];
            m_data.append(curNote.title);
            curNote.note = strList[5*i+2];
            curNote.comment = strList[5*i+3];
            curNote.state = (CDataBase::EState)strList[5*i+4].toInt(&ok, 10);
            if (!ok){
                continue;
            }
            listNote.append(curNote);
        }
        endInsertRows();
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

        endInsertRows();
    }


 }
//----------------------------------------------------------------------------------------------------------
void CListModel::curItemView(int curInd){
    curItemInd = curInd;
    QModelIndex index = createIndex(curInd, curInd, static_cast<void *>(0));

    // передать в qml данные о записи
    emit dataChanged(index, index);
}
//----------------------------------------------------------------------------------------------------------
void CListModel::del(int curInd){
   listNote.removeAt(curInd);
   beginRemoveRows(QModelIndex(),curInd,curInd);
   m_data.removeAt(curInd);
   endRemoveRows();
}
//----------------------------------------------------------------------------------------------------------
int CListModel::getId(int curInd){
    printf("%d", curInd) ;
    return listNote.at(curInd).id;
}

//----------------------------------------------------------------------------------------------------------
QVariant CListModel::getItem(int curInd){
    printf("%d", curInd) ;
    QStringList strList;
    CDataBase::TDbNote curNote = listNote.at(curInd);
    strList.append(QString::number(curNote.id));
    strList.append(curNote.title);
    strList.append(curNote.note);
    strList.append(curNote.comment);
    strList.append(QString::number(curNote.state));
    return QVariant(strList);
}
//----------------------------------------------------------------------------------------------------------
void CListModel::editItem(QStringList strList){
    qDebug("%s ", __PRETTY_FUNCTION__);
//    strList[0]; // название элемента, оно останется неизменным
//    strList[1]; // содержание, оно тоже останется неизменным
    CDataBase::TDbNote curNote = listNote.takeAt(curItemInd);
    curNote.comment = strList.at(2);
    bool ok;
    curNote.state = (CDataBase::EState)strList[3].toInt(&ok, 10);
    if (!ok){
        qWarning("%s err convert state", __PRETTY_FUNCTION__);
    }
    listNote.insert(curItemInd, curNote);
}
