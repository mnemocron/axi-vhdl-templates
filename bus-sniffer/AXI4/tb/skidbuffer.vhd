----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-04-21
-- Design Name:    AXIS skidbuffer
-- Module Name:    tb_skid - bh
-- Project Name:   
-- Target Devices: 
-- Tool Versions:  GHDL 0.37
-- Description:    skidbuffer for pipelining a bus handshake
-- 
-- Dependencies:   
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity skidbuffer is
  generic (
    DATA_WIDTH  : integer := 32;
    OPT_DATA_REG : boolean := True
  );
  port (
    clock     : in std_logic;
    reset_n   : in std_logic;

    s_valid_i : in  std_logic;
    s_last_i  : in  std_logic;
    s_ready_o : out std_logic;
    s_data_i  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);

    m_valid_o : out std_logic;
    m_last_o  : out std_logic;
    m_ready_i : in  std_logic;
    m_data_o  : out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
end skidbuffer;

architecture arch_imp of skidbuffer is
  -- register signals
  signal reg_data  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal reg_last  : std_logic;
  signal reg_valid : std_logic;
  signal reg_ready : std_logic;

  -- skid buffer signals (only used when OPT_DATA_REG = '1')
  signal skd_data  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal skd_last  : std_logic;

  -- output signals for output multiplexer
  signal out_data  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal out_last  : std_logic;

begin
  -- I/O connections assignments
  m_valid_o <= reg_valid;
  s_ready_o <= reg_ready;
  m_data_o  <= out_data;
  m_last_o  <= out_last;

  -- ready is always registered
  p_reg_ready : process(clock)
  begin
    if rising_edge(clock) then 
      if reset_n = '0' then
        reg_ready <= '0';
      else
        reg_ready <= m_ready_i;
      end if;
    end if;
  end process;

-- NOT REGISTERED OUTPUT -------------------------------------------------------
  gen_no_register : if not OPT_DATA_REG generate
    reg_valid <= s_valid_i; -- valid is not registered
    -- output multiplexer
    out_data <= reg_data when (reg_ready = '0') else s_data_i;
    out_last <= reg_last when (reg_ready = '0') else s_last_i;

    p_reg : process (clock)
    begin
      if rising_edge(clock) then 
        if reset_n = '0' then
          reg_data  <= (others => '0');
          reg_last  <= '0';
        else
          if reg_ready = '1' then
            reg_data <= s_data_i;
            reg_last <= s_last_i;
          else
            reg_data <= reg_data;
            reg_last <= reg_last;
          end if;
        end if;
      end if;
    end process;
    
  end generate;

-- FULLY REGISTERED OUTPUT -----------------------------------------------------
  gen_data_register : if OPT_DATA_REG generate
    out_data <= reg_data;
    out_last <= reg_last;
    -- registered output signals
    p_reg : process (clock)
    begin
      if rising_edge(clock) then 
        if reset_n = '0' then
          reg_data  <= (others => '0');
          reg_last  <= '0';
          skd_data  <= (others => '0');
          skd_last  <= '0';
          reg_valid <= '0';
        else
          reg_valid <= s_valid_i;
          if reg_ready = '1' then
            skd_data <= s_data_i;
            skd_last <= s_last_i;
          else
            skd_data <= skd_data;
            skd_last <= skd_last;
          end if;

          if m_ready_i = '0' then
            reg_data <= reg_data;
            reg_last <= reg_last;
          else
            if reg_ready = '1' then
              reg_data <= s_data_i;
              reg_last <= s_last_i;
            else
              reg_data <= skd_data;
              reg_last <= skd_last;
            end if;
          end if;
        end if;
      end if;
    end process;
  end generate;

end arch_imp;
