# PWM Detector in VHDL

Frequency and Duty cycle measurement on pwm signals.

In order to measure the frequency and duty cycle of a square wave signal this implementation on VHDL counts how many clock cycles are between the rising and falling edge of the input signal. We can read these signals at the rising edge of the valid signal, and use them to make the calculations as follows. 


## Inputs/Outputs
|INPUT| TYPE | OUTPUT | TYPE |
|------|------|----------|-----|
| clock | STD_LOGIC | signal_count | STD_LOGIC_VECTOR | 
| reset | STD_LOGIC | pulse_count | STD_LOGIC_VECTOR |
| pwm_input | STD_LOGIC | valid |STD_LOGIC |

## Block Diagram
![Block diagram](img/block_diagram.png)

## How to measure signal characteristics
![](https://latex.codecogs.com/svg.latex?\Large&space;Frequency=\frac{clockfrequency}{signalcount}(Hz))

![](https://latex.codecogs.com/svg.latex?\Large&space;DutyCycle=\frac{pulsecount}{signalcount}*100(%))

![](https://latex.codecogs.com/svg.latex?\Large&space;PulsePeriod=\frac{pulsecount}{clockfrequenct}(sec))

## Simulation
![Simulation](img/s.png)

