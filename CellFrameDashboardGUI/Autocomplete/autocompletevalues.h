#ifndef AUTOCOMPLETEVALUES_H
#define AUTOCOMPLETEVALUES_H

#include <QObject>

class AutocompleteValues : public QObject
{
    Q_OBJECT

    QStringList certs;
    void _getCerts();

public:
    explicit AutocompleteValues(QObject *parent = nullptr);
    QStringList getCerts();

signals:

};

#endif // AUTOCOMPLETEVALUES_H
