----------------------------------------------------------------------------------
-- Avgerinos Bakalidis
-- 
-- Create Date: 05/06/2021
-- Design Name: PWM Detection TB
-- Description: Testbench for PWM Detector
-- 
-- 
----------------------------------------------------------------------------------

LIBRARY ieee;  
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY pwm_detector_tb IS
generic (
counter_width_tb : integer:= 24						--set resolution of counter
);
END pwm_detector_tb;

ARCHITECTURE behav OF pwm_detector_tb IS

COMPONENT pwm_detector
generic (
counter_width : integer
);
PORT(
clock		: IN	STD_LOGIC;					--clock input - the frequency of the clock will determine the resolution of the measurement
reset		: IN	STD_LOGIC;					--reset input
pwm_input	: IN	STD_LOGIC;					--pulse width moduleted signal to measure
signal_count	: OUT	STD_LOGIC_VECTOR(counter_width DOWNTO 0);	--the period of the frequency of the signal in counts of the input clock
pulse_count	: OUT	STD_LOGIC_VECTOR(counter_width DOWNTO 0);	--the period of the pulse of the signal in counts of the input clock
valid		: OUT	STD_LOGIC					--a valid signal to indicate when the period output signals are valid
);
END COMPONENT;

SIGNAL clock_tb, reset_tb : STD_LOGIC;
SIGNAL pwm_input_tb : STD_LOGIC:='0';
SIGNAL signal_count_tb, pulse_count_tb : STD_LOGIC_VECTOR(counter_width_tb-1 DOWNTO 0);
SIGNAL valid_tb : STD_LOGIC;
TYPE STATES IS (duty_cycle_25, duty_cycle_50, duty_cycle_75);
SIGNAL duty_cycle : STATES := duty_cycle_25;
BEGIN


--GENERATE CLOCK (50MHz)
PROCESS
BEGIN
	clock_tb <= '0';
	reset_tb <= '0';
	WAIT FOR 10 ns;
	clock_tb <= '1';
	WAIT FOR 10 ns;

END PROCESS;

--GENERATE PWM SIGNAL AT 500Hz WITH 25%, 50%, 75% DUTY CYCLE
PROCESS(clock_tb)
VARIABLE counter : INTEGER RANGE 0 TO 100000;
BEGIN
	IF (rising_edge(clock_tb)) THEN
		counter := counter + 1;
	CASE duty_cycle IS
		WHEN duty_cycle_25 =>
			IF(COUNTER <= 25000) THEN
				pwm_input_tb <= '1';
			ELSE
				pwm_input_tb <= '0';
			END IF;
			IF(COUNTER = 100000) THEN
				counter := 0;
				duty_cycle <= duty_cycle_50;
			END IF;
		WHEN duty_cycle_50 =>
			IF(COUNTER <= 50000) THEN
				pwm_input_tb <= '1';
			ELSE
				pwm_input_tb <= '0';
			END IF;
			IF(COUNTER = 100000) THEN
				counter := 0;
				duty_cycle <= duty_cycle_75;
			END IF;
		WHEN duty_cycle_75 =>
			IF(COUNTER <= 75000) THEN
				pwm_input_tb <= '1';
			ELSE
				pwm_input_tb <= '0';
			END IF;
			IF(COUNTER = 100000) THEN
				counter := 0;
				duty_cycle <= duty_cycle_25;
			END IF;
	END CASE;
	END IF;
END PROCESS;



U1: pwm_detector
GENERIC MAP(
counter_width => counter_width_tb
)
PORT MAP(
clock =>clock_tb,
reset => reset_tb,
pwm_input => pwm_input_tb,
signal_count => signal_count_tb,
pulse_count => pulse_count_tb,
valid => valid_tb
);

END ARCHITECTURE;