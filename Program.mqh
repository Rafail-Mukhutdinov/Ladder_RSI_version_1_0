//###<Experts/Лесенка/Лесенка_RSI/Ladder_RSI_version_1_0/Ladder_RSI_version_1_0.mq5>

#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <My_library\Logger.mqh>
#include <My_library/standard_metod.mqh>
#include "Logic.mqh"
#include "struct.mqh"


class CProgram
{
private:
        CStandard_metod prog_standart;        

        int m_handler_RSI;                      //! Переменная для хранения переменной хендлера индикатора RSI

public:
        // Метод заполняет данные значениями 
        void  OnInit();
        // Метод обрабатывает логику по тикам 
        void  OnTick();


};


void CProgram::OnInit(){
    //! Получаем хендлер индикатора RSI

    m_handler_RSI = iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE);
    LOG(LOG_LEVEL_INFO, "Мы получили хендл индикатора RSI под номером: " + m_handler_RSI);

}

void CProgram::OnTick(){

        // Если у нас новый бар
        if(prog_standart.New_Bar()){
          LOG(LOG_LEVEL_INFO,"У нас новый бар");                        
        }
}