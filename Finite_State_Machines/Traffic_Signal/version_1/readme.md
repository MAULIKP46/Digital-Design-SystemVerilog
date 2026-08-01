# Traffic Light Controller FSM

## Overview

A Moore finite state machine implemented in SystemVerilog that models a two-road traffic intersection.

The controller cycles through:

- North-South Green
- North-South Yellow
- East-West Green
- East-West Yellow

The design includes an internal timer-based state transition mechanism using a synchronous counter.

## Features

- Moore FSM architecture
- typedef enum state encoding
- Separate state register, next-state logic, and output logic
- Internal timing counter
- Synchronous reset
- Self-contained SystemVerilog testbench
- Waveform verification using GTKWave

## Files

rtl/
- traffic_signal.sv

tb/
- traffic_signal_tb.sv

waveform/
- traffic_signal.png

## Simulation

Simulator:
- Icarus Verilog

Waveform Viewer:
- GTKWave

## Future Improvements

- Adaptive traffic control
- Vehicle sensors
- Pedestrian crossing requests
- Emergency vehicle priority
