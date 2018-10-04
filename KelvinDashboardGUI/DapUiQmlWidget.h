#ifndef DAPUIQMLWIDGET_H
#define DAPUIQMLWIDGET_H

#include <QObject>

class DapUiQmlWidget : public QObject
{
    Q_OBJECT
public:
    explicit DapUiQmlWidget(QObject *parent = nullptr);
    
signals:
    
public slots:
};

#endif // DAPUIQMLWIDGET_H