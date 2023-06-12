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

        int             m_handler_RSI; //! Переменная для хранения переменной хендлера индикатора RSI

        double          iRSIBuffer[]; //! индикаторный буфер

        bool            m_martingeil;

public:
        // Метод заполняет данные значениями
        void            OnInit();
        // Метод обрабатывает логику по тикам
        void            OnTick();
        // Метод находит количество открытых позиций и возвращает разворотное колличество лотов для переворота позиции
        double          Lot_Sum();

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
                                        LOG(LOG_LEVEL_DEBUG, "Сигнал на покупку");
                                        prog_trade.Buy(0.1, Symbol());
                                }
                        }
                }

                // Если значение индикатора стало больше 70
                if (NormalizeDouble(iRSIBuffer[1], 2) > 70)
                {
                        LOG(LOG_LEVEL_INFO, "Значение индикатора стало больше 70");
                        if (NormalizeDouble(iRSIBuffer[2], 2) > NormalizeDouble(iRSIBuffer[1], 2))
                        {
                                if((NormalizeDouble(iRSIBuffer[2], 2) > prog_value_indicator.max_value) || (prog_value_indicator.max_value == 0)){
                                   prog_value_indicator.max_value = NormalizeDouble(iRSIBuffer[2], 2);
                                   prog_value_indicator.min_value = 0;
                                   LOG(LOG_LEVEL_DEBUG, "Сигнал на продажу"); 
                                   prog_trade.Sell(0.1, Symbol());    
                                }
                        }
                }
        }
}


double CProgram::Lot_Sum()
{
        
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