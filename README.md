# Wheel of Fortune (NES) Wheel Randomizer

This is a simple LUA script that randomizes the wheel in all NES versions of Wheel of Fortune developed by Rare, including:
- Wheel of Fortune (U)
- Wheel of Fortune Family Edition (U)
- Wheel of Fortune Junior Edition (U)
- Wheel of Fortune Gamer Edition (Romhack)

Other versions/romhacks are untested.

# Requirements

- Any NES emulator that supports LUA (FCEUX, Bizhawk, Mesen, etc.)

# Configurable Options

(To change any of these options, simply open the script with a text editor and modify the booleans at the top accordingly)

- **Randomize Every Spin** - Set to **true** to randomize the wheel on every spin, or **false** to only randomize the wheel at the start of each round (default: true)
- **Reasonable Odds** - Set to **true** to adjust the odds to be more reasonable, or **false** to make the odds completely random (after guarantees are applied to prevent completely unfair scenarios/softlocks) (default: true)
- **Better Speed Up Wheel** - Set to **true** to make the Speed Up (Final Spin) wheel only contain high dollar amounts, or **false** to randomize the Speed Up wheel normally (default: false)
- **Even Higher Amounts** - Set to **true** to include dollar amounts over $5,000 as possible choices on the wheel (up to $8,000), or **false** to set the maximum dollar amount to $5,000 (default: false)

# Special Thanks

To LoZCardsFan23 for making the creation of this script possible!

Enjoy!
