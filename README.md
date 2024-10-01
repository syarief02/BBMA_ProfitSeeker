# BBMA_ProfitSeeker

## Table of Contents
- [Download](#download)
- [Overview](#overview)
- [Features](#features)
- [Input Parameters](#input-parameters)
- [How It Works](#how-it-works)
- [TP and SL Management](#tp-and-sl-management)
- [Usage Instructions](#usage-instructions)
- [License](#license)
- [Contributing](#contributing)
- [Contact Information](#contact-information)
- [Disclaimer](#disclaimer)

## Download
You can download the compiled EA from the following link:
- [Download BBMA Profit Seeker EA](https://github.com/syarief02/BBMA_ProfitSeeker/raw/refs/heads/main/BBMA_ProfitSeeker.ex4)

## Overview
The **BBMA Profit Seeker** is an Expert Advisor (EA) designed for trading in MetaTrader 4 using the BBMA (Bollinger Bands and Moving Average) strategy. This EA aims to identify potential buy and sell opportunities based on the relationship between the current price, Bollinger Bands, and a moving average.

## Features
- **BBMA Strategy**: The EA opens buy orders when the price crosses above the lower Bollinger Band and the moving average, and sell orders when the price crosses below the upper Bollinger Band and the moving average.
- **Customizable Parameters**: Users can adjust key parameters such as lot size, Bollinger Bands period, deviation, and moving average period.
- **Real-time Chart Comments**: The EA displays real-time information on the chart, including the current Bollinger Bands values, moving average, lot size, current take profit and stop loss levels for both buy and sell orders, date, and time.

## Input Parameters
- **BBPeriod**: The period for the Bollinger Bands (default is 20).
- **BBDeviation**: The standard deviation for the Bollinger Bands (default is 2).
- **MAPeriod**: The period for the moving average (default is 50).
- **LotSize**: The size of each trade (default is 0.1).
- **Slippage**: The maximum slippage allowed when placing orders (default is 3).

## How It Works
1. **Initialization**: When the EA is initialized, it sets up the chart comment with relevant information about the EA and its parameters.
2. **OnTick Event**: The EA continuously monitors market ticks:
   - It calculates the current Bollinger Bands and moving average values.
   - It checks for buy conditions: If the previous candle closed below the lower Bollinger Band and the current candle closes above it, a buy order is placed.
   - It checks for sell conditions: If the previous candle closed above the upper Bollinger Band and the current candle closes below it, a sell order is placed.
3. **Chart Comment Update**: The EA updates the chart comment with the current Bollinger Bands values, moving average, lot size, current take profit and stop loss levels for both buy and sell orders, date, and time on each tick.

## TP and SL Management
The **BBMA Profit Seeker** EA effectively manages Take Profit (TP) and Stop Loss (SL) levels based on the Bollinger Bands:

1. **Entry Conditions**:
   - **Buy Orders**: A buy order is placed when the previous candle closes below the lower Bollinger Band, and the current candle closes above it and above the Moving Average (MA).
   - **Sell Orders**: A sell order is placed when the previous candle closes above the upper Bollinger Band, and the current candle closes below it and below the Moving Average (MA).

2. **Setting Take Profit (TP)**:
   - For buy orders, the TP is set to the value of the upper Bollinger Band.
   - For sell orders, the TP is set to the value of the lower Bollinger Band.

3. **Setting Stop Loss (SL)**:
   - For buy orders, the SL is calculated as the current Bid price minus the distance to the TP.
   - For sell orders, the SL is calculated as the current Ask price plus the distance to the TP.

4. **Validation of TP and SL**:
   - The EA checks that the calculated TP and SL levels are valid before placing an order, ensuring they comply with broker requirements.

5. **Real-time Updates**:
   - The EA continuously updates the chart comment with the current values of the Bollinger Bands, Moving Average, lot size, and the TP and SL levels for both buy and sell orders.

## Usage Instructions
1. **Installation**: Copy the `bbma_profit_seeker.mq4` file into the `Experts` directory of your MetaTrader 4 installation.
2. **Compile**: Open the MetaEditor, load the `bbma_profit_seeker.mq4` file, and compile it.
3. **Attach to Chart**: Open a chart for the desired currency pair and timeframe (recommended: M15) and attach the EA.
4. **Configure Settings**: Adjust the input parameters as needed in the EA settings.
5. **Start Trading**: Enable automated trading in MetaTrader 4 to allow the EA to execute trades based on the defined strategy.

## License
This EA is licensed under the MIT License. It is provided for free and should not be sold or distributed for profit. You are free to use, modify, and share this EA, but please respect the terms of the license.

## Contributing
We welcome contributions! If you have ideas for improvements or new features, feel free to fork the repository, make your modifications, and submit a pull request. Your contributions can enhance this EA and benefit the trading community.

## Contact Information
For support or inquiries, please contact:
- **Author**: Budak Ubat
- **Telegram**: [t.me/EABudakUbat](https://t.me/EABudakUbat)
- **WhatsApp**: +60194961568

## Disclaimer
Trading in financial markets involves risk. This EA is provided for educational purposes only. Users should conduct their own research and consider their financial situation before trading.