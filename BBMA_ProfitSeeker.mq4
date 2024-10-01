// EA BBMA Oma Ally
input int BBPeriod = 20;        // Periode Bollinger Bands
input double BBDeviation = 2.0; // Deviasi Bollinger Bands
input int MAPeriod = 50;        // Periode Moving Average
input double LotSize = 0.1;     // Ukuran lot
input double TakeProfit = 50;   // Take profit dalam pips
input double StopLoss = 50;     // Stop loss dalam pips

double upperBand, lowerBand, maValue;

int OnInit()
{
    // Inisialisasi EA
    return INIT_SUCCEEDED;
}

void OnTick()
{
    // Hitung Bollinger Bands dan Moving Average
    upperBand = iBands(NULL, 0, BBPeriod, BBDeviation, 0, PRICE_CLOSE, MODE_UPPER, 0);
    lowerBand = iBands(NULL, 0, BBPeriod, BBDeviation, 0, PRICE_CLOSE, MODE_LOWER, 0);
    maValue = iMA(NULL, 0, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, 0);

    // Cek apakah ada posisi terbuka
    bool hasOpenPosition = false;
    for (int i = 0; i < OrdersTotal(); i++)
    {
        if (OrderSelect(i, SELECT_BY_POS))
        {
            if (OrderSymbol() == Symbol() && (OrderType() == OP_BUY || OrderType() == OP_SELL))
            {
                hasOpenPosition = true;
                break; // Keluar dari loop jika ada posisi terbuka
            }
        }
    }

    // Dapatkan jarak minimum untuk SL dan TP
    double minDistance = MarketInfo(Symbol(), MODE_STOPLEVEL) * Point;

    // Logika pembelian
    if (!hasOpenPosition && Close[1] < lowerBand && Close[0] > lowerBand && Close[0] > maValue)
    {
        double tpBuy = upperBand; // Set TP untuk posisi beli berdasarkan upper band
        double distanceBuy = tpBuy - Ask; // Hitung jarak dari harga saat ini ke TP untuk buy
        double slBuy = Bid - distanceBuy; // Set SL pada jarak yang sama di bawah harga Bid

        // Pastikan harga SL dan TP valid
        if (tpBuy > Ask + minDistance && slBuy < Bid - minDistance)
        {
            int buyTicket = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 2, slBuy, tpBuy, "BBMA Buy", 0, 0, clrGreen);
            if (buyTicket < 0)
            {
                Print("Error opening buy order: ", GetLastError());
            }
        }
        else
        {
            Print("Error: Take Profit or Stop Loss is not valid for buy.");
        }
    }

    // Logika penjualan
    if (!hasOpenPosition && Close[1] > upperBand && Close[0] < upperBand && Close[0] < maValue)
    {
        double tpSell = lowerBand; // Set TP untuk posisi jual berdasarkan lower band
        double distanceSell = Ask - tpSell; // Hitung jarak dari harga saat ini ke TP untuk sell
        double slSell = Ask + distanceSell; // Set SL pada jarak yang sama di atas harga Ask

        // Pastikan harga SL dan TP valid
        if (tpSell < Bid - minDistance && slSell > Ask + minDistance)
        {
            int sellTicket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 2, slSell, tpSell, "BBMA Sell", 0, 0, clrRed);
            if (sellTicket < 0)
            {
                Print("Error opening sell order: ", GetLastError());
            }
        }
        else
        {
            Print("Error: Take Profit or Stop Loss is not valid for sell.");
        }
    }
}
