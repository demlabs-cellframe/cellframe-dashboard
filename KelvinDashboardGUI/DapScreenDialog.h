#ifndef DAPSCREENDIALOG_H
#define DAPSCREENDIALOG_H

#include <QObject>

class DapScreenDialog : public QObject
{
    Q_OBJECT
public:
    explicit DapScreenDialog(QObject *parent = nullptr);
    
signals:
    
public slots:
};

#endif // DAPSCREENDIALOG_H