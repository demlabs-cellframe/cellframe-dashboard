#include "CSI.h"

void csi(const QCoreApplication &a, sConfig* conf)
{
   QCommandLineParser  csi;    csi.addHelpOption();
   csi.setApplicationDescription("Astra Monitor daemon");
   QCommandLineOption fgr({{"f","foreground"},"do not became a daemon, run in foreground, increase loglevel"});
   QCommandLineOption pid({{"p","pid"},"set file name to store pid, \ndefault is: "+conf->filePID,"pid-file"});
   QCommandLineOption cnf({{"c","config"},"use this config instead of default\ndefault is: "+conf->fileConf,"config file"});
   QCommandLineOption log({{"l","log"},"use this log instead of mentioned in config file","log file"});
   QCommandLineOption shc({{"s","showconfig"},"show configuration and exit"});    QCommandLineOption p_P({{"P","procping"},"process ping requests from config DB","proc ping"});
   QCommandLineOption p_S({{"S","procsnmp"},"process snmp requests from config DB","proc snmp"});
   QCommandLineOption p_L({{"L","procrlog"},"process rsyslog requests from config DB","proc log"});
   QCommandLineOption pip({{"R","pipename"},"named pipe where rsyslog is writing","rsyslog pipe"});
   
   QCommandLineOption qit({{"q","quiet"},"be quiet"});
     csi.addOption(pid);
     csi.addOption(fgr);
     csi.addOption(cnf);
  //    csi.addOption(log);
     csi.addOption(p_P);
     csi.addOption(p_S);
     csi.addOption(p_L);
     csi.addOption(pip);
     csi.addOption(shc);
     csi.addOption(qit);
     csi.process(a);
     if(csi.isSet(cnf))conf->fileConf=csi.value(cnf);
     if(csi.isSet(pid))conf->filePID=csi.value(pid);
     if(csi.isSet(p_P)){conf->procPing=csi.value(p_P).toInt();conf->procPingSet=true;}
     if(csi.isSet(p_S)){conf->procSNMP=csi.value(p_S).toInt();conf->procSNMPSet=true;}
     if(csi.isSet(p_L)){conf->procRLog=csi.value(p_L).toInt();conf->procRLogSet=true;}
     if(csi.isSet(pip)){conf->pipeName=csi.value(pip);conf->pipeNameSet=true;}
     conf->showCfg=csi.isSet(shc);
     conf->daemon=!csi.isSet(fgr);
     conf->quiet=csi.isSet(qit);
  }

void readConfig(sConfig* conf)
{
   QSettings* config;
   config=new QSettings(conf->fileConf,QSettings::IniFormat);
   if(!conf->procPingSet && config->value("procPING").isValid())conf->procPing=config->value("procPING").toBool();
   if(!conf->procSNMPSet && config->value("procSNMP").isValid())conf->procSNMP=config->value("procSNMP").toBool();
   if(!conf->procRLogSet && config->value("procRLog").isValid())conf->procRLog=config->value("procRLog").toBool();
   if(!conf->pipeNameSet && config->value("PipeName").isValid())conf->pipeName=config->value("PipeName").toString();
//    if(!conf->fileLog.length())conf->fileLog=config->value("Logfile").toString();
   if(!conf->filePID.length())conf->filePID=config->value("PIDfile").toString();
}

void showConfig(sConfig* conf)
{
   printf("---------- files and pathes:\n");
   printf("configuration file: %s\n",conf->fileConf.toLocal8Bit().constData());
   printf("pid file:           %s\n",conf->filePID.toLocal8Bit().constData());
//    printf("log file:           %s\n",conf->fileLog.toLocal8Bit().constData());
   printf("---------- Configured services:\n");
   printf("process PING's:     %s\n",conf->procPing?"true":"false");
   printf("process SNMP's:     %s\n",conf->procSNMP?"true":"false");
   printf("process RSyslog:    %s\n",conf->procRLog?"true":"false");
   printf("RSyslog pipe:       %s\n",conf->pipeName.toLocal8Bit().constData());
}
