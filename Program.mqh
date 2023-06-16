//###<Experts/Лесенка/Лесенка_RSI/Ladder_RSI_version_1_0/Ladder_RSI_version_1_0.mq5>

#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"

#include <My_library\Logger.mqh>
#include <My_library/standard_metod.mqh>
#include "Logic.mqh"
#include "struct.mqh"
#include <Trade\Trade.mqh>

class CProgram
{
private:
        CStandard_metod prog_standart;
        Value_Indicator prog_value_indicator;
        CTrade          prog_trade;
        Position_Value  prog_position;

        int             m_handler_RSI; //! Переменная для хранения переменной хендлера индикатора RSI

        double          iRSIBuffer[]; //! индикаторный буфер

        bool            m_martingeil;

public:
        // Метод заполняет данные значениями
        void            OnInit();
        // Метод обрабатывает логику по тикам
        void            OnTick();
        // Метод получает по открытой позиции
        void            Info_Position();

};

void CProgram::OnInit()
{
        // Разворачиваю буфер массивов данных
        ArraySetAsSeries(iRSIBuffer, true);
        //! Получаем хендлер индикатора RSI
        m_handler_RSI = iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE);
        LOG(LOG_LEVEL_INFO, "Мы получили хендл индикатора RSI под номером: " + (string)m_handler_RSI);
        //--- привязка массива к индикаторному буферу
        SetIndexBuffer(0, iRSIBuffer, INDICATOR_DATA);
}

void CProgram::OnTick()
{

        // Если у нас новый бар
        if (prog_standart.New_Bar())
        {
                // Получаем значение нашей открытой позиции
                Info_Position(); 
                LOG(LOG_LEVEL_INFO, "У нас новый бар");
                // Заполняем массив значениями индикатора
                FillArrayFromBuffer(iRSIBuffer, m_handler_RSI, 100);
                // LOG(LOG_LEVEL_INFO, "Значение [1] = " + (string)NormalizeDouble(iRSIBuffer[1], 2));
                //  Если значение индикатора опустилось ниже 30
                if (NormalizeDouble(iRSIBuffer[1], 2) < 30)
                {
                        LOG(LOG_LEVEL_INFO, "Значение индикатора стало меньше 30");
                        // Если второе значение стало больше первого появился холм
                        if (NormalizeDouble(iRSIBuffer[2], 2) < NormalizeDouble(iRSIBuffer[1], 2))
                        {
                                // если наше сохраненое значение опустилось ниже нашего сохраненого значения
                                if ((NormalizeDouble(iRSIBuffer[2], 2) < prog_value_indicator.min_value) || (prog_value_indicator.min_value == 0))
                                {

                                        prog_value_indicator.min_value = NormalizeDouble(iRSIBuffer[2], 2);
                                        prog_value_indicator.max_value = 0;
                                        // Если у нас позиция продажи а сигнал на покупку
                                        if(prog_position.type == POSITION_TYPE_SELL || prog_position.volume == 0)
                                        {
                                                LOG(LOG_LEVEL_DEBUG, "Сигнал на покупку");
                                                prog_trade.Buy(prog_position.volume + 0.1, Symbol());
                                        }else
                                        {
                                                prog_trade.Buy(0.1, Symbol());
                                        }

                                }
                        }
                }

                // Если значение индикатора стало больше 70
                if (NormalizeDouble(iRSIBuffer[1], 2) > 70)
                {
                        LOG(LOG_LEVEL_INFO, "Значение индикатора стало больше 70");
                        // Если второе значение индикатора больше первого на верхнем уровне 
                        if (NormalizeDouble(iRSIBuffer[2], 2) > NormalizeDouble(iRSIBuffer[1], 2))
                        {
                                // Если второе значение больше нашего до этого сохраненого значения индикатора или наше значение индикатора равно нулю         
                                if((NormalizeDouble(iRSIBuffer[2], 2) > prog_value_indicator.max_value) || (prog_value_indicator.max_value == 0))
                                {
    
                                   prog_value_indicator.max_value = NormalizeDouble(iRSIBuffer[2], 2);                  // Присваеваем нашему верхнее значение индикатора максимальное значение
                                   prog_value_indicator.min_value = 0;                                                  // Обнуляем наше минимальное значение        

                                   // Если у нас сигнал на продажу а позиция покупок
                                   if(prog_position.type == POSITION_TYPE_BUY || prog_position.volume == 0)
                                   {
                                        LOG(LOG_LEVEL_DEBUG, "Сигнал на продажу"); 
                                        // Разворачиваем нашу позицию
                                        prog_trade.Sell(prog_position.volume + 0.1, Symbol()); 
                                   }else
                                   {
                                        // Появился сигнал на продажу увеличиваем позицию
                                        prog_trade.Sell(0.1, Symbol());          
                                   }
   
                                }
                        }
                }
        }
}


void CProgram::Info_Position()
{
   if(PositionSelect(Symbol())) 
     { 
        prog_position.volume           = PositionGetDouble(POSITION_VOLUME);                                             // Получаем объем                
        prog_position.price         = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN), Digits());          // Получаем цену позиции
        prog_position.ticket        = PositionGetInteger(POSITION_TICKET);
        prog_position.type          = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE); 
        /*
        LOG(LOG_LEVEL_INFO, "Тикет: " + (string)(_PositionStruct.ticket) +
                            " Позиция: " + EnumToString(_PositionStruct.type) + 
                            " Цена: " + (string)_PositionStruct.prise + 
                            " Лот: " + (string)_PositionStruct.lot + 
                            " Стоплос: " + (string)_PositionStruct.stoploss +
                            " Тейкпрофит: " + (string)_PositionStruct.takeprofit);*/
                      
     }else{
        prog_position.volume        = 0;                                            // Получаем объем                
        prog_position.price         = 0;                                         // Получаем цену позиции
        prog_position.ticket        = 0;
        prog_position.type          = 0; 
   }
}

//+------------------------------------------------------------------+
//| Заполняем индикаторный буфер из индикатора iRSI                  |
//+------------------------------------------------------------------+
bool FillArrayFromBuffer(double &rsi_buffer[], // индикаторный буфер значений Relative Strength Index
                         int ind_handle,       // хэндл индикатора iRSI
                         int amount            // количество копируемых значений
)
{
        //--- сбросим код ошибки
        ResetLastError();
        //--- заполняем часть массива iRSIBuffer значениями из индикаторного буфера под индексом 0
        if (CopyBuffer(ind_handle, 0, 0, amount, rsi_buffer) < 0)
        {
                //--- если копирование не удалось, сообщим код ошибки
                PrintFormat("Не удалось скопировать данные из индикатора iRSI, код ошибки %d", GetLastError());
                //--- завершим с нулевым результатом - это означает, что индикатор будет считаться нерассчитанным
                return (false);
        }
        //--- все получилось
        return (true);
}