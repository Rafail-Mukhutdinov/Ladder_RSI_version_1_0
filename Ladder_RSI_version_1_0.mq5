#property version   "1.00"
#property description "Советник работает по принципу лесенки только "
#property description "лесенку строит по сигналам индикатора RSI "

#include <My_library\Logger.mqh>
#include "Program.mqh"


//--- выполнить инициализацию логгера
void InitLogger()
{
//--- задать уровни логирования: 
//--- DEBUG-уровень для записи сообщений в лог-файл
//--- ERROR-уровень для уведомлений
  CLogger::SetLevels(LOG_LEVEL_DEBUG,LOG_LEVEL_ERROR);
//--- задать тип уведомлений как PUSH-уведомления
  CLogger::SetNotificationMethod(NOTIFICATION_METHOD_PUSH);
//--- задать способ логирования как запись во внешний файл
  CLogger::SetLoggingMethod(LOGGING_OUTPUT_METHOD_EXTERN_FILE);
//--- задать имя лог-файлов
  CLogger::SetLogFileName("Ladder_RSI_version_1_0");
//--- задать тип ограничения на лог-файл как "новый лог-файл на каждый новый день"
  CLogger::SetLogFileLimitType(LOG_FILE_LIMIT_TYPE_ONE_DAY);
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
  InitLogger();
  //---
  CLogger::Add(LOG_LEVEL_INFO,"");
  CLogger::Add(LOG_LEVEL_INFO,"---------- OnInit() -----------");
  
  return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---
  
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
  
}
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
{
//---
  
}
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
{
//---
  
}
//+------------------------------------------------------------------+
