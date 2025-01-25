-- Wheel of Fortune (NES) Wheel Randomizer V0.22
-- By MaCobra52
-- Special thanks to LoZCardsfan23 for making all of this possible!
-- Only compatible with WoF Family Edition (and romhacks of Family Edition)

--Configurable options:

-- True - Randomize the wheel on every spin
-- False - Only randomize the wheel at the start of each round
local randomizeEverySpin = true;

-- True - Wheel will tend to randomize more predictably
	-- Odds: 45% Low $, 45% Mid $, 5% Special, 5% High $
-- False - Wheel is completely random (aside from guarantees to prevent completely unfair scenarios/softlocks)
	-- Odds: 25% Low $, 25% Mid $, 25% Special, 25% High $
-- (Note: Listed odds are after guarantees are applied)
local reasonableOdds = false;

-- True - Speed Up Wheel will only contain high $ amounts
-- False - Randomize Speed Up Wheel normally
local betterSpeedUpWheel = false;

-- True - Inlcude $ amounts over 5,000 as possible choices on the wheel (up to 8,000)
-- False - The max $ amount possible on the wheel is 5,000
local evenHigherAmounts = false;


-- End configurable options
-- Do not edit below this line unless you know what you're doing



--<=$450
local lowWheelValues = {0xAC, 0x2C, 0xAD, 0x2D, 0xAE, 0x2E, 0xAF, 0x2F};
-->$450 && <=$850
local medWheelValues = {0xB0, 0x30, 0xB1, 0x31, 0xB2, 0x32, 0xB3, 0x33};
-->$850
local highWheelValues = {0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13};
--local fourDigitWheelValues = {0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13};

local specialValues = {0xB8, 0xB7, 0xB6};
--local bankrupt = 0xB8;
--local freeSpin = 0xB7;
--local loseaTurn = 0xB6;

local wheelStart = 0x48B;
local wheelFinish = 0x4A2;
local currentRoundAddress = 0xBF;
local spinAddress = 0xB0;
			
local romCheck = false;
local identifier = 0x00;
local initialized = false;
local round = 0x00;
local spinning = 0x00;

local function randomizeWheel()
	local wheel = {};
	local value = 0;
	local r;
	local i;
	
	if round ~= 0x02 or (round == 0x02 and betterSpeedUpWheel == false) then
		--minimum 2 non-special, non-high
		for i=1, 2, 1 do
			r = math.random(1, 10);
			if r <= 5 then
				value = lowWheelValues[math.random(#lowWheelValues)];
			else
				value = medWheelValues[math.random(#medWheelValues)];
			end;
			table.insert(wheel, value);
		end;
		
		--minimum 1 four digit
		if evenHigherAmounts == true then
			table.insert(wheel, highWheelValues[math.random(#highWheelValues)]);
		else
			table.insert(wheel, highWheelValues[math.random(#highWheelValues-3)]);
		end;
		
		--minimum 1 bankrupt and lose a turn
		table.insert(wheel, 0xB8);
		table.insert(wheel, 0xB6);
		
		--normal rando
		for i=1, 19, 1 do
			if reasonableOdds == true then
				--2/40 special
				--2/40 high
				--18/40 medium
				--18/40 low
				r = math.random(1, 40);
				if r <= 18 then
					value = lowWheelValues[math.random(#lowWheelValues)];
				elseif r <= 36 then
					value = medWheelValues[math.random(#medWheelValues)];
				elseif r <= 38 then
					if evenHigherAmounts == true then
						value = highWheelValues[math.random(#highWheelValues)];
					else
						value = highWheelValues[math.random(#highWheelValues-3)];
					end;
				else
					value = specialValues[math.random(#specialValues)];
				end;
			else
				r = math.random(1, 4);
				if r == 1 then
					value = lowWheelValues[math.random(#lowWheelValues)];
				elseif r == 2 then
					value = medWheelValues[math.random(#medWheelValues)];
				elseif r == 3 then
					if evenHigherAmounts == true then
						value = highWheelValues[math.random(#highWheelValues)];
					else
						value = highWheelValues[math.random(#highWheelValues-3)];
					end;
				else
					value = specialValues[math.random(#specialValues)];
				end;
			end;
			table.insert(wheel, value);
		end;
	--Buffed Speed Up Wheel
	else
		--print("Speed Up Wheel!");
		--minimum 1 four digit
		if evenHigherAmounts == true then
			table.insert(wheel, highWheelValues[math.random(#highWheelValues)]);
		else
			table.insert(wheel, highWheelValues[math.random(#highWheelValues-3)]);
		end;
		
		--need filler to avoid graphical glitches
		table.insert(wheel, 0xB8);
		table.insert(wheel, 0xB6);
		table.insert(wheel, 0xB7);
		table.insert(wheel, 0xB8);
		table.insert(wheel, 0xB6);
		table.insert(wheel, 0xB7);
		
		--normal rando
		for i=1, 17, 1 do
			if evenHigherAmounts == true then
				value = highWheelValues[math.random(#highWheelValues)];
			else
				value = highWheelValues[math.random(#highWheelValues-3)];
			end;
			table.insert(wheel, value);
		end;
	end;
	
	--shuffle wheel
	for i=#wheel, 2, -1 do
		local j = math.random(i)
		wheel[i], wheel[j] = wheel[j], wheel[i];
	end;
	
	--insert wheel
	for i=0, 23, 1 do
		memory.writebyte(wheelStart+i, wheel[i+1]);
	end;
end;

local function randomizePalette()
	rom.writebyte(0x2A92, 0x28);
end;


while (true) do
	if romCheck == false then
		print("Wheel of Fortune (NES) Wheel Randomizer (Family Edition), by MaCobra52");
		if randomizeEverySpin == true then	
			print("Randomize every spin");
		else
			print("Randomize start of round only");
		end;
		if reasonableOdds == true then
			print("Wheel odds are reasonable");
		else
			print("Wheel odds are random");
		end;
		if betterSpeedUpWheel == true then
			print("Speed Up Wheel is buffed");
		else
			print("Speed Up Wheel is normal");
		end;
		if evenHigherAmounts == true then
			print("Amounts over $5,000 will appear");
		else
			print("Amounts over $5,000 will NOT appear");
		end;
		print("To change these configurations, open this LUA file in a text editior and modify the respective values at the top. Have fun!");
		--identifier = rom.readbyte(0x0017);
		--if identifier == 0x0F then
			--Family Edition has different locations
			--wheelStart = 0x48B;
			--wheelFinish = 0x4A2;
			--currentRoundAddress = 0xBF;
			--spinAddress = 0xB0;
		--end;
		--Seed the RNG
		math.randomseed(os.time())
		romCheck = true;
	end;
	
	if memory.readbyte(wheelFinish) ~= 0x00 then
		if initialized == false then
			--initialize wheel
			randomizeWheel();
			initialized = true;
		end;
		currentRound = memory.readbyte(currentRoundAddress);
		--Randomize at the start of each round
		if currentRound ~= round then
			--new round. Randomize wheel
			round = currentRound;
			print("New round. Randomizing wheel...");
			randomizeWheel();
		end;
		--Randomize every spin
		if randomizeEverySpin == true then
			currentSpin = memory.readbyte(spinAddress);
			if currentSpin == 0x02 and currentSpin ~= spinning then
				--new spin. Randomize wheel
				print("New spin. Randomizing wheel...");
				randomizeWheel();
				--randomizePalette();
			end;
			spinning = currentSpin;
		end;
	end;
		
	emu.frameadvance();

end;
