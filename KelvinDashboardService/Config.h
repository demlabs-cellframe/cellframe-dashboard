#ifndef CONFIG_H
#define CONFIG_H

#include <QString>

struct sConfig {
   QString     fileConf        = "/etc/kelvin.conf";
   QString     fileLog;
   int         levelLog        = 1;
   QString     filePID = "/home/andrey/test.pid";
   bool        daemon          = true;
   bool        showCfg         = false;
   bool        runNow          = true;
   bool        confRead        = false;
   bool        quiet           = false;
   QString pipeName    = "/tmp/astmon-pipe";
   bool        pipeNameSet     = false;
   bool        procPing        = true;
   bool        procPingSet     = false;
   bool        procSNMP        = true;
   bool        procSNMPSet     = false;
   bool        procRLog        = true;
   bool        procRLogSet     = false;
};

#endif // CONFIG_H
