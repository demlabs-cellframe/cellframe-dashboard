#ifndef AUTOCOMPLETEVALUES_H
#define AUTOCOMPLETEVALUES_H

#include <QObject>

class AutocompleteValues : public QObject
{
    Q_OBJECT

    QStringList pubCerts;
    QStringList privCerts;
    void _getCerts();

public:
    explicit AutocompleteValues(QObject *parent = nullptr);
    QStringList getPubCerts();
    QStringList getPrivCerts();

signals:

};

#endif // AUTOCOMPLETEVALUES_H
