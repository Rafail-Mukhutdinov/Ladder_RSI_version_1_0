//###<Experts/Лесенка/Лесенка_RSI/Ladder_RSI_version_1_0/Ladder_RSI_version_1_0.mq5>

struct Value_Indicator
{
    Value_Indicator(): max_value(0), min_value(0) {}
    double max_value;
    double min_value;   
};

struct Position_Value
{
    Position_Value():   price(0),
                        volume(0),
                        ticket(0),
                        type(0){} 
    double price;
    double volume;
    ulong  ticket;
    ENUM_POSITION_TYPE type;

};
