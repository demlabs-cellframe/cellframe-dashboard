#ifndef DAPABSTRACTMODULE_H
#define DAPABSTRACTMODULE_H

#include <QObject>
#include <QTimer>

class DapAbstractModule : public QObject
{
    Q_OBJECT
public:

    explicit DapAbstractModule(QObject *parent = nullptr);

    void setStatusProcessing(bool status);
    bool getStatusProcessing();

    void setName(QString name);
    QString getName();

private:
    bool m_statusProcessing;
    QString m_name;


signals:
    void initDone(bool status);


};

#endif // DAPABSTRACTMODULE_H
