#include <QApplication>
#include <QSystemSemaphore>
#include <QSharedMemory>

#include "DapHalper.h"
#include "DapChainDashboardService.h"

#include "CSI.h"
#include "Config.h"

#include <unistd.h>
#include <sys/types.h>
#include <stdio.h>
#include <QFile>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>

#include "MainProcess.h"

// Путь к конфигурационному файлу
#define KELVIN_AP_CONFIGS_DIR "/opt/sap/etc"
// Конфигурационный файл
#define KELVIN_AP_CONFIG_NAME "KelvinDashboard.cfg"

sConfig*        config;
void csi(const QCoreApplication &, sConfig*);

void signalHandler(int sig, siginfo_t*, void*)
{
   switch (sig) {
   case SIGTERM:
       config->runNow=false;
       break;
   case SIGHUP:
       config->confRead=true;
       break;
   default:
       printf("Don't know what to do with %d signal, ignore it.\n",sig);
   }
}

int main(int argc, char *argv[])
{
    // Creating a semaphore for locking external resources, as well as initializing an external resource-memory
    QSystemSemaphore systemSemaphore(QString("systemSemaphore for %1").arg("KelvinDashboardService"), 1);
#ifndef Q_OS_WIN
    QSharedMemory memmoryAppBagFix(QString("memmory for %1").arg("KelvinDashboardService"));
#endif
    QSharedMemory memmoryApp(QString("memmory for %1").arg("KelvinDashboardService"));
    // Check for the existence of a running instance of the program
    bool isRunning = DapHalper::getInstance().checkExistenceRunningInstanceApp(systemSemaphore, memmoryApp, memmoryAppBagFix);
  
    if(isRunning)
    {
        return 1;
    }
    
    QCoreApplication a(argc, argv);
    a.setOrganizationName("DEMLABS");
    a.setOrganizationDomain("demlabs.com");
    a.setApplicationName("KelvinDashboardService");
    
    
    
    if(argc < 2)
    {
        
    }
    
    
    config=new sConfig;
    
    csi(a,config);
    readConfig(config);
    if(config->showCfg)
    {
      showConfig(config);
      return(0);
    }
    if(!config->procPing && !config->procSNMP && !config->procRLog)
    {
      printf("Nothing to do (all services are disabled)\n");
      return(0);
    }
    //-----
    pid_t       child=0;
    if(config->daemon){
       child=fork();
       if(child==-1)
       {
           printf("Can't start, sorry\n");
       }
       if(child){
            if(!config->quiet)
                printf("Child with PID %d created\n",child);
           return(0);
       }
       setsid();
       close(STDIN_FILENO);
    //      close(STDOUT_FILENO);
    //      close(STDERR_FILENO);
    }
    //-----
    umask(0);
    chdir("/");
    int fPID=open(config->filePID.toLocal8Bit(),O_CREAT|O_WRONLY|O_EXCL,S_IRUSR|S_IWUSR|S_IRGRP);
    if(fPID<0)
    {
       printf("Can't create new pidfile '%s', aborting start\n",config->filePID.toLocal8Bit().constData());
       exit(0);
    }
    dprintf(fPID,"%d\n",getpid());
    close(fPID);
    struct sigaction sigProcNew;
    struct sigaction sigProcOld;
    sigProcNew.sa_handler=NULL;
    sigProcNew.sa_sigaction=signalHandler;
    sigProcNew.sa_flags = SA_SIGINFO;
    sigProcNew.sa_restorer = NULL;
    sigaction(SIGHUP,&sigProcNew,&sigProcOld);
    sigaction(SIGTERM,&sigProcNew,&sigProcOld);

    MainProcess proc(config);
       int rc;
       qDebug() << "Я здесь";
       if(proc.init())
       {
           qDebug() << "Я теперь здесь";
    // take-off completed !! -------------------------------------
           rc=a.exec();
    // clear to land ---------------------------------------------
           if(!rc)
           {
               if(!config->quiet)printf("Normal daemon termination.\n");
           }
           else printf("\nDaemot terminated with problem: %d\n",rc);
       }
       else
       {
    // take-off aborted, sorry -----------------------------------
           rc=127;
           printf("Can't initialize working process.\n");
       }
       if(0>unlink(config->filePID.toLocal8Bit()))
           printf("Sorry, can't delete my own pidfile '%s', take care about it.\n",config->filePID.toLocal8Bit().constData());
       return(rc);
    
    
    
    
    
    return a.exec();
}
