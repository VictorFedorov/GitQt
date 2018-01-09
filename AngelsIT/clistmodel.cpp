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

    return listNote.size();
}
//----------------------------------------------------------------------------------------------------------
QVariant CListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    const CDataBase::TDbNote curNote = listNote.at(index.row());
    switch (role) {
    case ColorRole:{
        QString color;
        switch(curNote.state){
            case CDataBase::StateNew:{
              color = "white";
              break;
            }
            case CDataBase::StateWork:{
              color = "#FF4720";
              break;
            }
            case CDataBase::StateDone:{
              color = "#90CC29";
              break;
            }
        }
        return QVariant(color);
    }
    case TextRole:{
        return listNote.at(index.row()).title;
        }
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
        listNote.clear();
        beginInsertRows(QModelIndex(), 0, countNotes-1);
        for(int i=0; i < countNotes ; i++){
            CDataBase::TDbNote curNote;
            bool ok;
            curNote.id = strList[5*i].toInt(&ok, 10);
            if (!ok){
                continue;
            }
            curNote.title = strList[5*i+1];

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
        beginInsertRows(QModelIndex(), listNote.size(), listNote.size());
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
    //    strList[0]; // id элемента, останется неизменным
    //    strList[1]; // название элемента, оно останется неизменным
    //    strList[2]; // содержание, оно тоже останется неизменным
    CDataBase::TDbNote curNote = listNote.takeAt(curItemInd);
    curNote.comment = strList.at(3);
    bool ok;
    curNote.state = (CDataBase::EState)strList[4].toInt(&ok, 10);
    if (!ok){
        qWarning("%s err convert state", __PRETTY_FUNCTION__);
    }
    listNote.insert(curItemInd, curNote);
}
//----------------------------------------------------------------------------------------------------------
void CListModel::repaintElement(){
    qDebug("%s curElem.ind = %d", __PRETTY_FUNCTION__, curItemInd);
    QModelIndex index = createIndex(curItemInd, curItemInd, static_cast<void *>(0));
    emit dataChanged(index, index);
}
