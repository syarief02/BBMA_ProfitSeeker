#define VERSION "1.00" // Define the version of the EA
#property version VERSION // Set the version property for the EA
#property link "https://m.me/EABudakUbat" // Link to the author's contact
#property description "This is BBMA_ProfitSeeker" // Description of the EA
#property description "Recommended timeframe M5, choose ranging pair." // Additional description
#property description "Recommended using a cent account for 100 USD capital" // Additional description
#property description "Join our Telegram channel: t.me/EABudakUbat" // Additional description
#property description "Facebook: m.me/EABudakUbat" // Additional description
#property description "+60194961568 (Budak Ubat)" // Additional description
#property icon "\\Images\\bupurple.ico" // Path to the EA icon
#property strict // Enable strict compilation mode

#include <WinUser32.mqh> // Include Windows User32 library for Windows-specific functions
#include <stdlib.mqh> // Include standard library for general functions

#define COPYRIGHT "Copyright © 2024, BuBat's Trading" // Define copyright information
#property copyright COPYRIGHT // Set the copyright property for the EA

// Expert information
#define EXPERT_NAME "[https://t.me/SyariefAzman] " // Define the expert name
extern string EA_Name = EXPERT_NAME; // EA name for display purposes
string Owner = "BUDAK UBAT";         // Owner's name for display purposes
string Contact = "WHATSAPP/TELEGRAM: +60194961568"; // Contact information for support

// EA BBMA Oma Ally
input int BBPeriod = 20;        // Periode Bollinger Bands
input double BBDeviation = 2.0; // Deviasi Bollinger Bands
input int MAPeriod = 50;        // Periode Moving Average
input double LotSize = 0.1;     // Ukuran lot
input int Slippage = 3;           // Maximum slippage allowed when placing orders (default is 3)

double upperBand, lowerBand, maValue;
string desc;
int OnInit()
  {
   UpdateChartComment(); // Call function to initialize and display the chart comment
   return INIT_SUCCEEDED; // Return success status for initialization
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
// Hitung Bollinger Bands dan Moving Average
   upperBand = iBands(NULL, 0, BBPeriod, BBDeviation, 0, PRICE_CLOSE, MODE_UPPER, 0);
   lowerBand = iBands(NULL, 0, BBPeriod, BBDeviation, 0, PRICE_CLOSE, MODE_LOWER, 0);
   maValue = iMA(NULL, 0, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, 0);
// Cek apakah ada posisi terbuka
   bool hasOpenPosition = false;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol() == Symbol() && (OrderType() == OP_BUY || OrderType() == OP_SELL))
           {
            hasOpenPosition = true;
            break; // Keluar dari loop jika ada posisi terbuka
           }
        }
     }
// Dapatkan jarak minimum untuk SL
   double minDistance = MarketInfo(Symbol(), MODE_STOPLEVEL) * Point;
// Logika pembelian
   if(!hasOpenPosition && Close[1] < lowerBand && Close[0] > lowerBand && Close[0] > maValue)
     {
      double tpBuy = upperBand; // Set TP untuk posisi beli berdasarkan upper band
      double slBuy = Bid - (tpBuy - Bid); // Set SL pada jarak yang sama di bawah harga Bid
      // Pastikan harga SL dan TP valid
      if(tpBuy > Ask + minDistance && slBuy < Bid - minDistance && CheckVolumeValue(LotSize, desc))
        {
         int buyTicket = OrderSend(Symbol(), OP_BUY, LotSize, Ask, Slippage, slBuy, tpBuy, "BBMA Buy", 0, 0, clrGreen);
         if(buyTicket < 0)
           {
            Print("Error opening buy order: ", GetLastError());
           }
        }
      // No else statement to avoid printing error if conditions are not met
     }
// Logika penjualan
   if(!hasOpenPosition && Close[1] > upperBand && Close[0] < upperBand && Close[0] < maValue)
     {
      double tpSell = lowerBand; // Set TP untuk posisi jual berdasarkan lower band
      double slSell = Ask + (Ask - tpSell); // Set SL pada jarak yang sama di atas harga Ask
      // Pastikan harga SL dan TP valid
      if(tpSell < Bid - minDistance && slSell > Ask + minDistance && CheckVolumeValue(LotSize, desc))
        {
         int sellTicket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, Slippage, slSell, tpSell, "BBMA Sell", 0, 0, clrRed);
         if(sellTicket < 0)
           {
            Print("Error opening sell order: ", GetLastError());
           }
        }
      // No else statement to avoid printing error if conditions are not met
     }
   UpdateChartComment(); // Update the chart comment with current information
  }

//+------------------------------------------------------------------+
//| Update chart comment                                             |
//+------------------------------------------------------------------+
void UpdateChartComment()
  {
   double tpBuy = 0, slBuy = 0, tpSell = 0, slSell = 0;
// Calculate current TP and SL for buy and sell orders
   if(OrdersTotal() > 0)
     {
      for(int i = 0; i < OrdersTotal(); i++)
        {
         if(OrderSelect(i, SELECT_BY_POS))
           {
            if(OrderType() == OP_BUY)
              {
               tpBuy = OrderTakeProfit();
               slBuy = OrderStopLoss();
              }
            else
               if(OrderType() == OP_SELL)
                 {
                  tpSell = OrderTakeProfit();
                  slSell = OrderStopLoss();
                 }
           }
        }
     }
// Create a formatted string for the chart comment
   string comment = StringFormat(
                       "BBMA Profit Seeker EA\n" // Title of the EA
                       "Author: %s\n" // Author's name
                       "Owner: %s\n" // Owner's name
                       "Contact: %s\n" // Contact information
                       "Current Upper Band: %.5f\n" // Current upper Bollinger Band value
                       "Current Lower Band: %.5f\n" // Current lower Bollinger Band value
                       "Current MA: %.5f\n" // Current moving average value
                       "Lot Size: %.2f\n" // Current lot size
                       "Current Buy TP: %.2f\n" // Current buy take profit
                       "Current Buy SL: %.2f\n" // Current buy stop loss
                       "Current Sell TP: %.2f\n" // Current sell take profit
                       "Current Sell SL: %.2f\n" // Current sell stop loss
                       "Date: %s\n" // Current date
                       "Time: %s\n", // Current time
                       "Budak Ubat", Owner, Contact, upperBand, lowerBand, maValue, LotSize,
                       tpBuy, slBuy, tpSell, slSell,
                       TimeToString(TimeCurrent(), TIME_DATE), // Get current date
                       TimeToString(TimeCurrent(), TIME_MINUTES) // Get current time
                    );
// Display the prepared comment on the chart
   Comment(comment);
  }

//+------------------------------------------------------------------+
//| Check the correctness of the order volume                        |
//+------------------------------------------------------------------+
bool CheckVolumeValue(double volume, string &description)
  {
//--- minimal allowed volume for trade operations
   double min_volume = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
   if(volume < min_volume)
     {
      description = StringFormat("Volume is less than the minimal allowed SYMBOL_VOLUME_MIN=%.2f", min_volume);
      return(false);
     }
//--- maximal allowed volume of trade operations
   double max_volume = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
   if(volume > max_volume)
     {
      description = StringFormat("Volume is greater than the maximal allowed SYMBOL_VOLUME_MAX=%.2f", max_volume);
      return(false);
     }
//--- get minimal step of volume changing
   double volume_step = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   int ratio = (int)MathRound(volume / volume_step);
   if(MathAbs(ratio * volume_step - volume) > 0.0000001)
     {
      description = StringFormat("Volume is not a multiple of the minimal step SYMBOL_VOLUME_STEP=%.2f, the closest correct volume is %.2f",
                                 volume_step, ratio * volume_step);
      return(false);
     }
   description = "Correct volume value";
   return(true);
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret = 0.0;
//---
   OnTick();
//---
   return(ret);
  }
//+------------------------------------------------------------------+
