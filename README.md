# RMS Black Market

A straightforward and customizable black market script for **RSGCore v2**. 

### Big Shoutouts 
Massive thanks to [Jewsie](https://github.com/Jewsie) for creating the original [Jc-Blackmarket script](https://forum.cfx.re/t/rsg-free-jc-blackmarket/5224412)! This version builds on that foundation with additional features and flexibility.

## Features

- **Dynamic Location Cycle**: The black market location will change at a specified interval, keeping it unpredictable and fresh.
- **Multiple Location Support**: Define various possible locations for the black market to occupy, enhancing gameplay dynamics.
- **Buy & Sell Options**: Control whether players can sell items, buy items, or both at the black market.
- **Customizable NPC Models**: Choose any NPC model as the black market operator.
- **Unlimited Items**: Add any number of items for players to purchase or sell.

## Requirements

- **RSGCore v2**  
- Targeting system (e.g., `rsg-target`)

## Installation

1. Add the shop to rsg-shops
2. Place it in your `resources` folder.
3. Ensure the following lines are added to your `server.cfg`:
   ```plaintext
   ensure rsg-blackmarket
