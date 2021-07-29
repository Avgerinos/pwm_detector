----------------------------------------------------------------------------------
-- Avgerinos Bakalidis
-- 
-- Create Date: 05/06/2021
-- Design Name: PWM Detection
-- Description: Measure pulse width and period in clock counts, in order to find frequency, period and duty cycle of a pwm input signal
-- 
-- 
----------------------------------------------------------------------------------

LIBRARY ieee;  
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY pwm_detector IS
generic (
counter_width : integer
);
PORT(
clock		: IN	STD_LOGIC;					--clock input - the frequency of the clock will determine the resolution of the measurement
reset		: IN	STD_LOGIC;					--reset input
pwm_input	: IN	STD_LOGIC;					--pulse width moduleted signal to measure
signal_count	: OUT	STD_LOGIC_VECTOR(counter_width-1 DOWNTO 0);	--the period of the frequency of the signal in counts of the input clock
pulse_count	: OUT	STD_LOGIC_VECTOR(counter_width-1 DOWNTO 0);	--the period of the pulse of the signal in counts of the input clock
valid		: OUT	STD_LOGIC					--a valid signal to indicate when the counter output signals are valid
);
END pwm_detector;

ARCHITECTURE behav OF pwm_detector IS

SIGNAL pwm_input_delay: STD_LOGIC;					--a signal to hold a delayed version of the pwm input signal

BEGIN


PROCESS(clock)
VARIABLE counter : std_logic_vector(counter_width-1 downto 0):=(others => '0');
BEGIN
	IF (reset = '1') THEN
		counter := (others => '0');					--reset counter value
		signal_count <= (others => '0');
		pulse_count <= (others => '0');
		valid <= '0';
		pwm_input_delay <= '0';
	ELSIF (rising_edge(clock)) then
		pwm_input_delay <= pwm_input;					--delay the input signal by 1 clock cycle, used to find the edges of the input signal
		IF((pwm_input = '1') AND (pwm_input_delay = '0')) THEN		--rising edge detecton
			signal_count <= counter ;
			counter := (others => '0');
			counter(0) := '1';
			valid <= '1';						--valid = 1 - signal_count and pulse_count are updated at this point
		ELSIF((pwm_input = '0') AND (pwm_input_delay = '1')) THEN	--falling edge detection
			pulse_count <= counter;
			counter := counter + "01";
			valid <= '0';
		ELSE
			valid <= '0';
			counter := counter + "01";
		END IF;
	END IF;
END PROCESS;

END ARCHITECTURE;

