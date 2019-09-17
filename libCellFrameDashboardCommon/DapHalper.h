/****************************************************************************
**
** This file is part of the libCellFrameDashboardClient library.
** 
** The class provides common functionality.
**
****************************************************************************/

#ifndef DAPHALPER_H
#define DAPHALPER_H

#include <QObject>
#include <QSystemSemaphore>
#include <QSharedMemory>

class DapHalper : public QObject
{
    Q_OBJECT
    
    /// Standart constructor.
    explicit DapHalper(QObject *parent = nullptr);
    
public:
    // Realization of a singleton
    DapHalper(const DapHalper&) = delete;
    DapHalper& operator= (const DapHalper &) = delete;
    /// Get an instance of a class.
    /// @return Instance of a class.
    static DapHalper &getInstance();
    
    /// Check for the existence of a running instance of the program.
    /// @param systemSemaphore Semaphore for blocking shared resource.
    /// @param memmoryApp Shared memory.
    /// @param memmoryAppBagFix Shared memory for Linux system features.
    /// @return If the application is running, it returns three, otherwise false.
    bool checkExistenceRunningInstanceApp(QSystemSemaphore& systemSemaphore, QSharedMemory &memmoryApp, QSharedMemory &memmoryAppBagFix);
};

#endif // DAPHALPER_H
