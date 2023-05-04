
ghdl --version

:: delete
del /Q *.vcd &
del /Q *.o &
del /Q *.exe &
del /Q *.cf &

:: analyze
ghdl -a skidbuffer.vhd
ghdl -a axis_splitter.vhd
ghdl -a axis_pipeline.vhd
ghdl -a axi4_to_axis.vhd
ghdl -a tb_axis.vhd
:: elaborate
ghdl -e skidbuffer
ghdl -e axis_splitter
ghdl -e axis_pipeline
ghdl -e axi4_to_axis
ghdl -e tb_axis
:: run
ghdl -r tb_axis --vcd=wave.vcd --stop-time=1us
gtkwave wave.vcd waveform.gtkw

:: delete
del /Q *.o &
del /Q *.exe &
del /Q *.cf &
