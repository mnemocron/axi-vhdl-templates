----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-04-21
-- Design Name:    AXIS axis_pipeline
-- Module Name:    tb_skid - bh
-- Project Name:   
-- Target Devices: 
-- Tool Versions:  GHDL 0.37
-- Description:    bidirectional AXIS pipeline register
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

entity axis_pipeline is
  generic (
    -- Users to add parameters here

    -- User parameters ends
    -- Do not modify the parameters beyond this line

    -- Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_S_AXIS_TDATA_WIDTH.
    C_S_AXIS_TDATA_WIDTH  : integer := 32
  );
  port (
    -- Users to add ports here

    -- User ports ends
    -- Global ports
    AXIS_ACLK : in std_logic;
    AXIS_ARESETN  : in std_logic;

    -- Slave Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
    S_AXIS_TVALID : in  std_logic;
    -- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
    S_AXIS_TDATA  : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    -- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
    S_AXIS_TSTRB  : in  std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
    -- TLAST indicates the boundary of a packet.
    S_AXIS_TLAST  : in  std_logic;
    -- TREADY indicates that the slave can accept a transfer in the current cycle.
    S_AXIS_TREADY : out std_logic;

    -- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
    M_AXIS_TVALID : out std_logic;
    -- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
    M_AXIS_TDATA  : out std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    -- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
    M_AXIS_TSTRB  : out std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
    -- TLAST indicates the boundary of a packet.
    M_AXIS_TLAST  : out std_logic;
    -- TREADY indicates that the slave can accept a transfer in the current cycle.
    M_AXIS_TREADY : in  std_logic
  );
end axis_pipeline;

architecture arch_imp of axis_pipeline is
  -- skidbuffer component
  component skidbuffer is
  generic (
    DATA_WIDTH   : natural;
    OPT_DATA_REG : boolean);
    port (
       clock     : in  std_logic;
       reset_n   : in  std_logic;

       s_valid_i : in  std_logic;
       s_last_i  : in  std_logic;
       s_ready_o : out std_logic;
       s_data_i  : in  std_logic_vector((C_S_AXIS_TDATA_WIDTH+(C_S_AXIS_TDATA_WIDTH/8)) - 1 downto 0);

       m_valid_o : out std_logic;
       m_last_o  : out std_logic;
       m_ready_i : in  std_logic;
       m_data_o  : out std_logic_vector((C_S_AXIS_TDATA_WIDTH+(C_S_AXIS_TDATA_WIDTH/8)) - 1 downto 0));
  end component;

  -- signals
  signal aclk    : std_logic;
  signal aresetn : std_logic;

  signal i_s_axis_tvalid : std_logic := '0';
  signal i_s_axis_tdata  : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
  signal i_axis_data_strb  : std_logic_vector(C_S_AXIS_TDATA_WIDTH+(C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
  signal i_s_axis_tstrb  : std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
  signal i_s_axis_tlast  : std_logic;
  signal o_s_axis_tready : std_logic;

  signal o_m_axis_tvalid : std_logic;
  signal o_m_axis_tdata  : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
  signal o_axis_data_strb  : std_logic_vector(C_S_AXIS_TDATA_WIDTH+(C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
  signal o_m_axis_tstrb  : std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
  signal o_m_axis_tlast  : std_logic;
  signal i_m_axis_tready : std_logic := '0';

begin
  -- I/O connections assignments
  aclk    <= AXIS_ACLK;
  aresetn <= AXIS_ARESETN;

  -- inputs
  i_m_axis_tready <= M_AXIS_TREADY;
  i_s_axis_tvalid <= S_AXIS_TVALID;
  i_s_axis_tdata  <= S_AXIS_TDATA;
  i_s_axis_tstrb  <= S_AXIS_TSTRB;
  i_s_axis_tlast  <= S_AXIS_TLAST;

  -- outputs
  S_AXIS_TREADY <= o_s_axis_tready;
  M_AXIS_TVALID <= o_m_axis_tvalid;
  M_AXIS_TDATA  <= o_m_axis_tdata;
  M_AXIS_TSTRB  <= o_m_axis_tstrb;
  M_AXIS_TLAST  <= o_m_axis_tlast;

  -- combine strobe and data signals into single "data" channel
  i_axis_data_strb <= s_axis_tdata & s_axis_tstrb;
  o_m_axis_tdata <= o_axis_data_strb( (C_S_AXIS_TDATA_WIDTH+(C_S_AXIS_TDATA_WIDTH/8)) - 1 downto (C_S_AXIS_TDATA_WIDTH/8) );
  o_m_axis_tstrb <= o_axis_data_strb( (C_S_AXIS_TDATA_WIDTH/8) - 1 downto 0 );

  skidbuffer_inst : skidbuffer
  generic map (
      DATA_WIDTH    => (C_S_AXIS_TDATA_WIDTH+(C_S_AXIS_TDATA_WIDTH/8)),
      OPT_DATA_REG  => True
  )
  port map (
    clock     => aclk,
    reset_n   => aresetn,

    s_valid_i => i_s_axis_tvalid,
    s_last_i  => i_s_axis_tlast,
    s_ready_o => o_s_axis_tready,
    s_data_i  => i_axis_data_strb,

    m_valid_o => o_m_axis_tvalid,
    m_last_o  => o_m_axis_tlast,
    m_ready_i => i_m_axis_tready,
    m_data_o  => o_axis_data_strb
  );

end arch_imp;
