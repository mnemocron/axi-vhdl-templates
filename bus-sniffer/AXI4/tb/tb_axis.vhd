----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-04-21
-- Design Name:    skid buffer testbench
-- Module Name:    tb_axis - bh
-- Project Name:   
-- Target Devices: 
-- Tool Versions:  GHDL 0.37
-- Description:    
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

-- this testbench acts as a streaming master, sending bursts of data
-- counting from 1-4, also asserting tlast on the 4th data packet

-- the testbench itself acts as a correct streaming master which keeps the data
-- until it is acknowledged by the DUT by asserting tready.

-- the data pattern can be influenced by the user in 2 ways
-- + Tx requests are generated by changing the pattern in p_stimuli_tready
--   the master will try to send data for as long as sim_valid_data = '1'
-- + Rx acknowledgements are generated by changing the pattern in p_stimuli_tready
--   the downstream slave after the DUT will signal ready-to-receive 
--   when sim_ready_data = '1'

-- simulate both with OPT_DATA_REG = True / False
entity tb_axis is
  generic
  (
    OPT_DATA_REG         : boolean   := True;
    -- Width of ID for for write address, write data, read address and read data
    C_S_AXI_ID_WIDTH     : integer   := 3;
    -- Width of S_AXI data bus
    C_S_AXI_DATA_WIDTH   : integer   := 8;
    -- Width of S_AXI address bus
    C_S_AXI_ADDR_WIDTH   : integer   := 8;
    -- Width of optional user defined signal in write address channel
    C_S_AXI_AWUSER_WIDTH : integer   := 0;
    -- Width of optional user defined signal in read address channel
    C_S_AXI_ARUSER_WIDTH : integer   := 0;
    -- Width of optional user defined signal in write data channel
    C_S_AXI_WUSER_WIDTH  : integer   := 0;
    -- Width of optional user defined signal in read data channel
    C_S_AXI_RUSER_WIDTH  : integer   := 0;
    -- Width of optional user defined signal in write response channel
    C_S_AXI_BUSER_WIDTH  : integer   := 0
  );
end tb_axis;

architecture bh of tb_axis is
  -- DUT component declaration
  component axi4_to_axis is
    generic (
      C_S_AXI_ID_WIDTH     : integer;
      C_S_AXI_DATA_WIDTH   : integer;
      C_S_AXI_ADDR_WIDTH   : integer;
      C_S_AXI_AWUSER_WIDTH : integer;
      C_S_AXI_ARUSER_WIDTH : integer;
      C_S_AXI_WUSER_WIDTH  : integer;
      C_S_AXI_RUSER_WIDTH  : integer;
      C_S_AXI_BUSER_WIDTH  : integer
    );
    port (
      AXIS_ACLK      : in  std_logic;
      AXIS_ARESETN   : in  std_logic;

      S_AXI_AWID     : in  std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
      S_AXI_AWADDR   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      S_AXI_AWLEN    : in  std_logic_vector(7 downto 0);
      S_AXI_AWSIZE   : in  std_logic_vector(2 downto 0);
      S_AXI_AWBURST  : in  std_logic_vector(1 downto 0);
      S_AXI_AWLOCK   : in  std_logic;
      S_AXI_AWCACHE  : in  std_logic_vector(3 downto 0);
      S_AXI_AWPROT   : in  std_logic_vector(2 downto 0);
      S_AXI_AWQOS    : in  std_logic_vector(3 downto 0);
      S_AXI_AWREGION : in  std_logic_vector(3 downto 0);
      S_AXI_AWUSER   : in  std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0);
      S_AXI_AWVALID  : in  std_logic;
      S_AXI_AWREADY  : out std_logic;
      S_AXI_WDATA    : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      S_AXI_WSTRB    : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
      S_AXI_WLAST    : in  std_logic;
      S_AXI_WUSER    : in  std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0);
      S_AXI_WVALID   : in  std_logic;
      S_AXI_WREADY   : out std_logic;
      S_AXI_BID      : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
      S_AXI_BRESP    : out std_logic_vector(1 downto 0);
      S_AXI_BUSER    : out std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
      S_AXI_BVALID   : out std_logic;
      S_AXI_BREADY   : in  std_logic;
      S_AXI_ARID     : in  std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
      S_AXI_ARADDR   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      S_AXI_ARLEN    : in  std_logic_vector(7 downto 0);
      S_AXI_ARSIZE   : in  std_logic_vector(2 downto 0);
      S_AXI_ARBURST  : in  std_logic_vector(1 downto 0);
      S_AXI_ARLOCK   : in  std_logic;
      S_AXI_ARCACHE  : in  std_logic_vector(3 downto 0);
      S_AXI_ARPROT   : in  std_logic_vector(2 downto 0);
      S_AXI_ARQOS    : in  std_logic_vector(3 downto 0);
      S_AXI_ARREGION : in  std_logic_vector(3 downto 0);
      S_AXI_ARUSER   : in  std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0);
      S_AXI_ARVALID  : in  std_logic;
      S_AXI_ARREADY  : out std_logic;
      S_AXI_RID      : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
      S_AXI_RDATA    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      S_AXI_RRESP    : out std_logic_vector(1 downto 0);
      S_AXI_RLAST    : out std_logic;
      S_AXI_RUSER    : out std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
      S_AXI_RVALID   : out std_logic;
      S_AXI_RREADY   : in  std_logic;

      M_AXIS_TVALID : out std_logic;
      M_AXIS_TDATA  : out std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      M_AXIS_TSTRB  : out std_logic_vector((C_S_AXI_ADDR_WIDTH/8)-1 downto 0);
      M_AXIS_TLAST  : out std_logic;
      M_AXIS_TREADY : in  std_logic
    );
  end component;

  component axi4_s_write_splitter is
    generic (
      C_AXI_ID_WIDTH  : integer;
      C_AXI_DATA_WIDTH  : integer;
      C_AXI_ADDR_WIDTH  : integer;
      C_AXI_AWUSER_WIDTH  : integer;
      C_AXI_ARUSER_WIDTH  : integer;
      C_AXI_WUSER_WIDTH : integer;
      C_AXI_RUSER_WIDTH : integer;
      C_AXI_BUSER_WIDTH : integer
    );
    port (
      axi_aclk  : in std_logic;
      axi_aresetn : in std_logic;

      s00_axi_awid    : in std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      s00_axi_awaddr  : in std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
      s00_axi_awlen   : in std_logic_vector(7 downto 0);
      s00_axi_awsize  : in std_logic_vector(2 downto 0);
      s00_axi_awburst : in std_logic_vector(1 downto 0);
      s00_axi_awlock  : in std_logic;
      s00_axi_awcache : in std_logic_vector(3 downto 0);
      s00_axi_awprot  : in std_logic_vector(2 downto 0);
      s00_axi_awqos   : in std_logic_vector(3 downto 0);
      s00_axi_awregion : in std_logic_vector(3 downto 0);
      s00_axi_awuser  : in std_logic_vector(C_AXI_AWUSER_WIDTH-1 downto 0);
      s00_axi_awvalid : in std_logic;
      s00_axi_awready : out std_logic;
      s00_axi_wdata   : in std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
      s00_axi_wstrb   : in std_logic_vector((C_AXI_DATA_WIDTH/8)-1 downto 0);
      s00_axi_wlast   : in std_logic;
      s00_axi_wuser   : in std_logic_vector(C_AXI_WUSER_WIDTH-1 downto 0);
      s00_axi_wvalid  : in std_logic;
      s00_axi_wready  : out std_logic;
      s00_axi_bid     : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      s00_axi_bresp   : out std_logic_vector(1 downto 0);
      s00_axi_buser   : out std_logic_vector(C_AXI_BUSER_WIDTH-1 downto 0);
      s00_axi_bvalid  : out std_logic;
      s00_axi_bready  : in std_logic;
      s00_axi_arid    : in std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      s00_axi_araddr  : in std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
      s00_axi_arlen   : in std_logic_vector(7 downto 0);
      s00_axi_arsize  : in std_logic_vector(2 downto 0);
      s00_axi_arburst : in std_logic_vector(1 downto 0);
      s00_axi_arlock  : in std_logic;
      s00_axi_arcache : in std_logic_vector(3 downto 0);
      s00_axi_arprot  : in std_logic_vector(2 downto 0);
      s00_axi_arqos   : in std_logic_vector(3 downto 0);
      s00_axi_arregion : in std_logic_vector(3 downto 0);
      s00_axi_aruser  : in std_logic_vector(C_AXI_ARUSER_WIDTH-1 downto 0);
      s00_axi_arvalid : in std_logic;
      s00_axi_arready : out std_logic;
      s00_axi_rid     : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      s00_axi_rdata   : out std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
      s00_axi_rresp   : out std_logic_vector(1 downto 0);
      s00_axi_rlast   : out std_logic;
      s00_axi_ruser   : out std_logic_vector(C_AXI_RUSER_WIDTH-1 downto 0);
      s00_axi_rvalid  : out std_logic;
      s00_axi_rready  : in std_logic;
      
      m00_axi_awid    : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      m00_axi_awaddr  : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
      m00_axi_awlen   : out std_logic_vector(7 downto 0);
      m00_axi_awsize  : out std_logic_vector(2 downto 0);
      m00_axi_awburst : out std_logic_vector(1 downto 0);
      m00_axi_awlock  : out std_logic;
      m00_axi_awcache : out std_logic_vector(3 downto 0);
      m00_axi_awprot  : out std_logic_vector(2 downto 0);
      m00_axi_awqos   : out std_logic_vector(3 downto 0);
      m00_axi_awuser  : out std_logic_vector(C_AXI_AWUSER_WIDTH-1 downto 0);
      m00_axi_awvalid : out std_logic;
      m00_axi_awready : in std_logic;
      m00_axi_wdata   : out std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
      m00_axi_wstrb   : out std_logic_vector(C_AXI_DATA_WIDTH/8-1 downto 0);
      m00_axi_wlast   : out std_logic;
      m00_axi_wuser   : out std_logic_vector(C_AXI_WUSER_WIDTH-1 downto 0);
      m00_axi_wvalid  : out std_logic;
      m00_axi_wready  : in std_logic;
      m00_axi_bid     : in std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      m00_axi_bresp   : in std_logic_vector(1 downto 0);
      m00_axi_buser   : in std_logic_vector(C_AXI_BUSER_WIDTH-1 downto 0);
      m00_axi_bvalid  : in std_logic;
      m00_axi_bready  : out std_logic;
      m00_axi_arid    : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      m00_axi_araddr  : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
      m00_axi_arlen   : out std_logic_vector(7 downto 0);
      m00_axi_arsize  : out std_logic_vector(2 downto 0);
      m00_axi_arburst : out std_logic_vector(1 downto 0);
      m00_axi_arlock  : out std_logic;
      m00_axi_arcache : out std_logic_vector(3 downto 0);
      m00_axi_arprot  : out std_logic_vector(2 downto 0);
      m00_axi_arqos   : out std_logic_vector(3 downto 0);
      m00_axi_aruser  : out std_logic_vector(C_AXI_ARUSER_WIDTH-1 downto 0);
      m00_axi_arvalid : out std_logic;
      m00_axi_arready : in std_logic;
      m00_axi_rid     : in std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      m00_axi_rdata   : in std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
      m00_axi_rresp   : in std_logic_vector(1 downto 0);
      m00_axi_rlast   : in std_logic;
      m00_axi_ruser   : in std_logic_vector(C_AXI_RUSER_WIDTH-1 downto 0);
      m00_axi_rvalid  : in std_logic;
      m00_axi_rready  : out std_logic;

      m00_axis_tvalid : out std_logic;
      m00_axis_tdata  : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
      m00_axis_tstrb  : out std_logic_vector((C_AXI_ADDR_WIDTH/8)-1 downto 0);
      m00_axis_tlast  : out std_logic;
      m00_axis_tready : in std_logic;

      m01_axis_tvalid : out std_logic;
      m01_axis_tdata  : out std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
      m01_axis_tstrb  : out std_logic_vector((C_AXI_DATA_WIDTH/8)-1 downto 0);
      m01_axis_tlast  : out std_logic;
      m01_axis_tready : in std_logic;

      m02_axis_tvalid : out std_logic;
      m02_axis_tdata  : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
      m02_axis_tstrb  : out std_logic_vector((C_AXI_ADDR_WIDTH/8)-1 downto 0);
      m02_axis_tlast  : out std_logic;
      m02_axis_tready : in std_logic;

      m03_axis_tvalid : out std_logic;
      m03_axis_tdata  : out std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
      m03_axis_tstrb  : out std_logic_vector((C_AXI_DATA_WIDTH/8)-1 downto 0);
      m03_axis_tlast  : out std_logic;
      m03_axis_tready : in std_logic;

      opt_awready   : out std_logic;
      opt_wready    : out std_logic;
      opt_arready   : out std_logic;
      opt_rready    : out std_logic
    );
  end component;

  
  constant CLK_PERIOD: TIME := 5 ns;

  signal sim_start_write : std_logic := '0'; -- request AW channel
  signal sim_start_ready : std_logic := '0'; -- signal ready to receive from slave
  signal sim_valid_data  : std_logic := '0'; -- AW complete, now send W channel
  signal sim_data        : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

  signal o_axis_tvalid : std_logic;
  signal o_axis_tdata  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal o_axis_tstrb  : std_logic_vector((C_S_AXI_ADDR_WIDTH/8)-1 downto 0);
  signal o_axis_tlast  : std_logic;
  signal i_axis_tready : std_logic := '0';

  signal clk   : std_logic;
  signal rst_n : std_logic;

  signal o_axi_awid     : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal o_axi_awaddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal o_axi_awlen    : std_logic_vector(7 downto 0);
  signal o_axi_awsize   : std_logic_vector(2 downto 0);
  signal o_axi_awburst  : std_logic_vector(1 downto 0);
  signal o_axi_awlock   : std_logic;
  signal o_axi_awcache  : std_logic_vector(3 downto 0);
  signal o_axi_awprot   : std_logic_vector(2 downto 0);
  signal o_axi_awqos    : std_logic_vector(3 downto 0);
  signal o_axi_awregion : std_logic_vector(3 downto 0);
  signal o_axi_awuser   : std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0);
  signal o_axi_awvalid  : std_logic;
  signal i_axi_awready  : std_logic;
  signal o_axi_wdata    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal o_axi_wstrb    : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
  signal o_axi_wlast    : std_logic;
  signal o_axi_wuser    : std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0);
  signal o_axi_wvalid   : std_logic;
  signal i_axi_wready   : std_logic;
  signal i_axi_bid      : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal i_axi_bresp    : std_logic_vector(1 downto 0);
  signal i_axi_buser    : std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
  signal i_axi_bvalid   : std_logic;
  signal o_axi_bready   : std_logic;
  signal o_axi_arid     : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal o_axi_araddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal o_axi_arlen    : std_logic_vector(7 downto 0);
  signal o_axi_arsize   : std_logic_vector(2 downto 0);
  signal o_axi_arburst  : std_logic_vector(1 downto 0);
  signal o_axi_arlock   : std_logic;
  signal o_axi_arcache  : std_logic_vector(3 downto 0);
  signal o_axi_arprot   : std_logic_vector(2 downto 0);
  signal o_axi_arqos    : std_logic_vector(3 downto 0);
  signal o_axi_arregion : std_logic_vector(3 downto 0);
  signal o_axi_aruser   : std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0);
  signal o_axi_arvalid  : std_logic;
  signal i_axi_arready  : std_logic;
  signal i_axi_rid      : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal i_axi_rdata    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal i_axi_rresp    : std_logic_vector(1 downto 0);
  signal i_axi_rlast    : std_logic;
  signal i_axi_ruser    : std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
  signal i_axi_rvalid   : std_logic;
  signal o_axi_rready   : std_logic;

  signal o_Y_axi_awid     : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal o_Y_axi_awaddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal o_Y_axi_awlen    : std_logic_vector(7 downto 0);
  signal o_Y_axi_awsize   : std_logic_vector(2 downto 0);
  signal o_Y_axi_awburst  : std_logic_vector(1 downto 0);
  signal o_Y_axi_awlock   : std_logic;
  signal o_Y_axi_awcache  : std_logic_vector(3 downto 0);
  signal o_Y_axi_awprot   : std_logic_vector(2 downto 0);
  signal o_Y_axi_awqos    : std_logic_vector(3 downto 0);
  signal o_Y_axi_awregion : std_logic_vector(3 downto 0);
  signal o_Y_axi_awuser   : std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0);
  signal o_Y_axi_awvalid  : std_logic;
  signal i_Y_axi_awready  : std_logic;
  signal o_Y_axi_wdata    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal o_Y_axi_wstrb    : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
  signal o_Y_axi_wlast    : std_logic;
  signal o_Y_axi_wuser    : std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0);
  signal o_Y_axi_wvalid   : std_logic;
  signal i_Y_axi_wready   : std_logic;
  signal i_Y_axi_bid      : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal i_Y_axi_bresp    : std_logic_vector(1 downto 0);
  signal i_Y_axi_buser    : std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
  signal i_Y_axi_bvalid   : std_logic;
  signal o_Y_axi_bready   : std_logic;
  signal o_Y_axi_arid     : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal o_Y_axi_araddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal o_Y_axi_arlen    : std_logic_vector(7 downto 0);
  signal o_Y_axi_arsize   : std_logic_vector(2 downto 0);
  signal o_Y_axi_arburst  : std_logic_vector(1 downto 0);
  signal o_Y_axi_arlock   : std_logic;
  signal o_Y_axi_arcache  : std_logic_vector(3 downto 0);
  signal o_Y_axi_arprot   : std_logic_vector(2 downto 0);
  signal o_Y_axi_arqos    : std_logic_vector(3 downto 0);
  signal o_Y_axi_arregion : std_logic_vector(3 downto 0);
  signal o_Y_axi_aruser   : std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0);
  signal o_Y_axi_arvalid  : std_logic;
  signal i_Y_axi_arready  : std_logic;
  signal i_Y_axi_rid      : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal i_Y_axi_rdata    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal i_Y_axi_rresp    : std_logic_vector(1 downto 0);
  signal i_Y_axi_rlast    : std_logic;
  signal i_Y_axi_ruser    : std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
  signal i_Y_axi_rvalid   : std_logic;
  signal o_Y_axi_rready   : std_logic;

  signal clk_count : std_logic_vector(7 downto 0) := (others => '0');
  signal outstanding_xfers : std_logic_vector(7 downto 0) := (others => '0');
begin

  -- generate clk signal
  p_clk_gen : process
  begin
   clk <= '1';
   wait for (CLK_PERIOD / 2);
   clk <= '0';
   wait for (CLK_PERIOD / 2);
   clk_count <= std_logic_vector(unsigned(clk_count) + 1);
  end process;

  -- generate initial reset
  p_reset_gen : process
  begin 
    rst_n <= '0';
    wait until rising_edge(clk);
    wait for (CLK_PERIOD / 4);
    rst_n <= '1';
    wait;
  end process;

  -- generate AW request
  p_aw_stimuli : process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        o_axi_awid     <= (others => '0'); 
        o_axi_awaddr   <= (others => '0'); 
        o_axi_awlen    <= (others => '0'); 
        o_axi_awsize   <= (others => '0'); 
        o_axi_awburst  <= (others => '0'); 
        o_axi_awlock   <= '0';
        o_axi_awcache  <= (others => '0'); 
        o_axi_awprot   <= (others => '0'); 
        o_axi_awqos    <= (others => '0'); 
        o_axi_awregion <= (others => '0'); 
        o_axi_awuser   <= (others => '0'); 
        o_axi_awvalid  <= '0';
        sim_valid_data <= '0';
      else
        if o_axi_awvalid = '1' then -- AW handshake ongoing, wait for slave to ack
          if i_axi_awready = '1' then -- slave is able to receive AW reqest
            o_axi_awid <= "000";
            o_axi_awaddr <= (others => '0'); 
            o_axi_awlen <= (others => '0'); 
            o_axi_awsize <= "000";
            o_axi_awburst <= "00";
            o_axi_awvalid <= '0';
            sim_valid_data <= '1';
          end if;
        else
          if sim_start_write = '1' then -- AW handshake requested by simulation
            o_axi_awid <= "101";
            o_axi_awaddr <= x"42";
            o_axi_awlen <= x"3f";  -- 63+1 bytes
            o_axi_awsize <= "110"; -- 64 bytes
            o_axi_awburst <= "01"; -- INCR
            o_axi_awvalid <= '1';
            --sim_valid_data <= '0';
          end if;
        end if;
        if sim_valid_data = '1' then
          if o_axi_wlast = '1' and i_axi_wready = '1' then
            if unsigned(outstanding_xfers) = 1 then 
              sim_valid_data <= '0';
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;

  -- generate counter data when successfully acknowledged (tready) by slave
  p_stimuli_tdata : process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        o_axi_wdata <= (others => '0');
        o_axi_wstrb <= (others => '0');
        sim_data    <= (others => '0');
        o_axi_wlast <= '0';
        o_axi_wvalid <= '0';
      else
        if (sim_valid_data = '1' or o_axi_awvalid='1') then -- and o_axi_wlast = '0'  then    -- OK from a valid AW handshake
        --  if o_axi_wlast = '0' then
            if i_axi_wready = '1' then    -- wready from slave
              if unsigned(o_axi_wdata) = 15 then
                o_axi_wlast <= '1';
              else 
                o_axi_wlast <= '0';
              end if;

              if unsigned(outstanding_xfers) /= 0 and o_axi_wlast = '0' then
                if unsigned(o_axi_wdata) = 16 then
                  -- restart counter at "1"
                  o_axi_wdata(C_S_AXI_DATA_WIDTH-1 downto 1) <= (others => '0');
                  o_axi_wdata(0) <= '1';
                  sim_data(C_S_AXI_DATA_WIDTH-1 downto 1) <= (others => '0');
                  sim_data(0) <= '1';
                else
                  if (unsigned(sim_data) > unsigned(o_axi_wdata)) and (unsigned(sim_data) < 4) then
                    o_axi_wdata <= std_logic_vector(unsigned(sim_data) + 1);
                  else
                    o_axi_wdata <= std_logic_vector(unsigned(o_axi_wdata) + 1);
                  end if;
                  
                  if unsigned(sim_data) = 16 then
                    sim_data(C_S_AXI_DATA_WIDTH-1 downto 1) <= (others => '0');
                    sim_data(0) <= '1';
                  else
                    sim_data <= std_logic_vector(unsigned(sim_data) + 1);
                  end if;
                end if;
                o_axi_wvalid <= '1';
                o_axi_wstrb  <= "1";
              else
                if unsigned(outstanding_xfers) = 1 then
                  o_axi_wdata <= (others => '0');
                  sim_data <= (others => '0');
                  o_axi_wvalid <= '0';
                  o_axi_wstrb  <= "0";
                else 
                  o_axi_wdata(C_S_AXI_DATA_WIDTH-1 downto 1) <= (others => '0');
                  o_axi_wdata(0) <= '1';
                  sim_data(C_S_AXI_DATA_WIDTH-1 downto 1) <= (others => '0');
                  sim_data(0) <= '1';
                end if;
              end if;
            else
              o_axi_wdata <= o_axi_wdata;
              sim_data    <= sim_data;
            end if;
        --  end if;
        else 
          o_axi_wvalid <= '0';
          o_axi_wstrb  <= "0";
          o_axi_wlast  <= '0';
          o_axi_wdata  <= (others => '0');
          sim_data <= sim_data;
        end if;
      end if;
    end if;
  end process;

  -- accept and ack BRESP
  p_ack_bresp : process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
          o_axi_bready <= '1';
      else
        if i_axi_bvalid = '1' then
          o_axi_bready <= '0';
        else
          o_axi_bready <= '1';
        end if;
      end if;
    end if;
  end process;

  -- generate ready signal
  p_slave_tready : process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
          i_axis_tready <= '0';
      else
        if sim_start_ready = '1' then
          i_axis_tready <= '1';
        else
          i_axis_tready <= '0';
        end if;
      end if;
    end if;
  end process;

  -- generate valid signal
  p_stimuli_valid : process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
          sim_start_write <= '0';
      else
        if o_axi_wlast = '1' and i_axi_wready = '1' then
          outstanding_xfers <= std_logic_vector(unsigned(outstanding_xfers) - 1);
        else
          if unsigned(clk_count) = 3 then
            sim_start_write <= '1';
            outstanding_xfers <= std_logic_vector(unsigned(outstanding_xfers) + 1);
          end if;
          if unsigned(clk_count) = 5 then
            sim_start_write <= '0';
          end if;

          if unsigned(clk_count) = 20 then
            sim_start_write <= '1';
            outstanding_xfers <= std_logic_vector(unsigned(outstanding_xfers) + 1);
          end if;
          if unsigned(clk_count) = 22 then
            sim_start_write <= '0';
          end if;

          if unsigned(clk_count) = 46 then
            sim_start_write <= '1';
            outstanding_xfers <= std_logic_vector(unsigned(outstanding_xfers) + 1);
          end if;
          if unsigned(clk_count) = 48 then
            sim_start_write <= '0';
          end if;
          if unsigned(clk_count) = 56 then
            sim_start_write <= '1';
            outstanding_xfers <= std_logic_vector(unsigned(outstanding_xfers) + 1);
          end if;
          if unsigned(clk_count) = 58 then
            sim_start_write <= '0';
          end if;

--          if unsigned(clk_count) = 78 then
--            sim_start_write <= '1';
--            outstanding_xfers <= std_logic_vector(unsigned(outstanding_xfers) + 1);
--          end if;
--          if unsigned(clk_count) = 85 then
--            sim_start_write <= '0';
--          end if;
        end if;
      end if;
    end if;
  end process;

  -- generate ready signal
  p_stimuli_ready : process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
          sim_start_ready <= '0';
      else
        if unsigned(clk_count) = 2 then
          sim_start_ready <= '1';
        end if;
        if unsigned(clk_count) = 52 then
          sim_start_ready <= '0';
        end if;
        if unsigned(clk_count) = 70 then
          sim_start_ready <= '1';
        end if;
--        if unsigned(clk_count) = 27 then
--          sim_start_ready <= '0';
--        end if;
--        if unsigned(clk_count) = 38 then
--          sim_start_ready <= '1';
--        end if;
      end if;
    end if;
  end process;

-- DUT instance and connections
  axi_converter_inst : axi4_to_axis
    generic map (
      C_S_AXI_ID_WIDTH     => C_S_AXI_ID_WIDTH,
      C_S_AXI_DATA_WIDTH   => C_S_AXI_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH   => C_S_AXI_ADDR_WIDTH,
      C_S_AXI_AWUSER_WIDTH => C_S_AXI_AWUSER_WIDTH,
      C_S_AXI_ARUSER_WIDTH => C_S_AXI_ARUSER_WIDTH,
      C_S_AXI_WUSER_WIDTH  => C_S_AXI_WUSER_WIDTH,
      C_S_AXI_RUSER_WIDTH  => C_S_AXI_RUSER_WIDTH,
      C_S_AXI_BUSER_WIDTH  => C_S_AXI_BUSER_WIDTH
    )
    port map (
      AXIS_ACLK      => clk,
      AXIS_ARESETN   => rst_n,

      S_AXI_AWID     =>  o_Y_axi_awid,
      S_AXI_AWADDR   =>  o_Y_axi_awaddr,
      S_AXI_AWLEN    =>  o_Y_axi_awlen,
      S_AXI_AWSIZE   =>  o_Y_axi_awsize,
      S_AXI_AWBURST  =>  o_Y_axi_awburst,
      S_AXI_AWLOCK   =>  o_Y_axi_awlock,
      S_AXI_AWCACHE  =>  o_Y_axi_awcache,
      S_AXI_AWPROT   =>  o_Y_axi_awprot,
      S_AXI_AWQOS    =>  o_Y_axi_awqos,
      S_AXI_AWREGION =>  o_Y_axi_awregion,
      S_AXI_AWUSER   =>  o_Y_axi_awuser,
      S_AXI_AWVALID  =>  o_Y_axi_awvalid,
      S_AXI_AWREADY  =>  i_Y_axi_awready,
      S_AXI_WDATA    =>  o_Y_axi_wdata,
      S_AXI_WSTRB    =>  o_Y_axi_wstrb,
      S_AXI_WLAST    =>  o_Y_axi_wlast,
      S_AXI_WUSER    =>  o_Y_axi_wuser,
      S_AXI_WVALID   =>  o_Y_axi_wvalid,
      S_AXI_WREADY   =>  i_Y_axi_wready,
      S_AXI_BID      =>  i_Y_axi_bid,
      S_AXI_BRESP    =>  i_Y_axi_bresp,
      S_AXI_BUSER    =>  i_Y_axi_buser,
      S_AXI_BVALID   =>  i_Y_axi_bvalid,
      S_AXI_BREADY   =>  o_Y_axi_bready,
      S_AXI_ARID     =>  o_Y_axi_arid,
      S_AXI_ARADDR   =>  o_Y_axi_araddr,
      S_AXI_ARLEN    =>  o_Y_axi_arlen,
      S_AXI_ARSIZE   =>  o_Y_axi_arsize,
      S_AXI_ARBURST  =>  o_Y_axi_arburst,
      S_AXI_ARLOCK   =>  o_Y_axi_arlock,
      S_AXI_ARCACHE  =>  o_Y_axi_arcache,
      S_AXI_ARPROT   =>  o_Y_axi_arprot,
      S_AXI_ARQOS    =>  o_Y_axi_arqos,
      S_AXI_ARREGION =>  o_Y_axi_arregion,
      S_AXI_ARUSER   =>  o_Y_axi_aruser,
      S_AXI_ARVALID  =>  o_Y_axi_arvalid,
      S_AXI_ARREADY  =>  i_Y_axi_arready,
      S_AXI_RID      =>  i_Y_axi_rid,
      S_AXI_RDATA    =>  i_Y_axi_rdata,
      S_AXI_RRESP    =>  i_Y_axi_rresp,
      S_AXI_RLAST    =>  i_Y_axi_rlast,
      S_AXI_RUSER    =>  i_Y_axi_ruser,
      S_AXI_RVALID   =>  i_Y_axi_rvalid,
      S_AXI_RREADY   =>  o_Y_axi_rready,

      M_AXIS_TVALID  =>  o_axis_tvalid,
      M_AXIS_TDATA   =>  o_axis_tdata,
      M_AXIS_TSTRB   =>  o_axis_tstrb,
      M_AXIS_TLAST   =>  o_axis_tlast,
      M_AXIS_TREADY  =>  i_axis_tready 
    );

  axi4_s_write_splitter_inst : axi4_s_write_splitter
    generic map (
      C_AXI_ID_WIDTH      => C_S_AXI_ID_WIDTH,
      C_AXI_DATA_WIDTH    => C_S_AXI_DATA_WIDTH,
      C_AXI_ADDR_WIDTH    => C_S_AXI_ADDR_WIDTH,
      C_AXI_AWUSER_WIDTH  => C_S_AXI_AWUSER_WIDTH,
      C_AXI_ARUSER_WIDTH  => C_S_AXI_ARUSER_WIDTH,
      C_AXI_WUSER_WIDTH   => C_S_AXI_WUSER_WIDTH,
      C_AXI_RUSER_WIDTH   => C_S_AXI_RUSER_WIDTH,
      C_AXI_BUSER_WIDTH   => C_S_AXI_BUSER_WIDTH
    )
    port map (
      axi_aclk    => clk,
      axi_aresetn => rst_n,

      s00_axi_awid      => o_axi_awid,        --n std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      s00_axi_awaddr    => o_axi_awaddr,        --n std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
      s00_axi_awlen     => o_axi_awlen,        --n std_logic_vector(7 downto 0);
      s00_axi_awsize    => o_axi_awsize,        --n std_logic_vector(2 downto 0);
      s00_axi_awburst   => o_axi_awburst,        --n std_logic_vector(1 downto 0);
      s00_axi_awlock    => o_axi_awlock,        --n std_logic;
      s00_axi_awcache   => o_axi_awcache,        --n std_logic_vector(3 downto 0);
      s00_axi_awprot    => o_axi_awprot,        --n std_logic_vector(2 downto 0);
      s00_axi_awqos     => o_axi_awqos,        --n std_logic_vector(3 downto 0);
      s00_axi_awregion  => o_axi_awregion,        --n std_logic_vector(3 downto 0);
      s00_axi_awuser    => o_axi_awuser,        --n std_logic_vector(C_AXI_AWUSER_WIDTH-1 downto 0);
      s00_axi_awvalid   => o_axi_awvalid,        --n std_logic;
      s00_axi_awready   => i_axi_awready,        --ut std_logic;
      s00_axi_wdata     => o_axi_wdata,        --n std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
      s00_axi_wstrb     => o_axi_wstrb,        --n std_logic_vector((C_AXI_DATA_WIDTH/8)-1 downto 0);
      s00_axi_wlast     => o_axi_wlast,        --n std_logic;
      s00_axi_wuser     => o_axi_wuser,        --n std_logic_vector(C_AXI_WUSER_WIDTH-1 downto 0);
      s00_axi_wvalid    => o_axi_wvalid,        --n std_logic;
      s00_axi_wready    => i_axi_wready,        --ut std_logic;
      s00_axi_bid       => i_axi_bid,        --ut std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      s00_axi_bresp     => i_axi_bresp,        --ut std_logic_vector(1 downto 0);
      s00_axi_buser     => i_axi_buser,        --ut std_logic_vector(C_AXI_BUSER_WIDTH-1 downto 0);
      s00_axi_bvalid    => i_axi_bvalid,        --ut std_logic;
      s00_axi_bready    => o_axi_bready,        --n std_logic;
      s00_axi_arid      => o_axi_arid,        --n std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      s00_axi_araddr    => o_axi_araddr,        --n std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
      s00_axi_arlen     => o_axi_arlen,        --n std_logic_vector(7 downto 0);
      s00_axi_arsize    => o_axi_arsize,        --n std_logic_vector(2 downto 0);
      s00_axi_arburst   => o_axi_arburst,        --n std_logic_vector(1 downto 0);
      s00_axi_arlock    => o_axi_arlock,        --n std_logic;
      s00_axi_arcache   => o_axi_arcache,        --n std_logic_vector(3 downto 0);
      s00_axi_arprot    => o_axi_arprot,        --n std_logic_vector(2 downto 0);
      s00_axi_arqos     => o_axi_arqos,        --n std_logic_vector(3 downto 0);
      s00_axi_arregion  => o_axi_arregion,        --n std_logic_vector(3 downto 0);
      s00_axi_aruser    => o_axi_aruser,        --n std_logic_vector(C_AXI_ARUSER_WIDTH-1 downto 0);
      s00_axi_arvalid   => o_axi_arvalid,        --n std_logic;
      s00_axi_arready   => i_axi_arready,        --ut std_logic;
      s00_axi_rid       => i_axi_rid,        --ut std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      s00_axi_rdata     => i_axi_rdata,        --ut std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
      s00_axi_rresp     => i_axi_rresp,        --ut std_logic_vector(1 downto 0);
      s00_axi_rlast     => i_axi_rlast,        --ut std_logic;
      s00_axi_ruser     => i_axi_ruser,        --ut std_logic_vector(C_AXI_RUSER_WIDTH-1 downto 0);
      s00_axi_rvalid    => i_axi_rvalid,        --ut std_logic;
      s00_axi_rready    => o_axi_rready,        --n std_logic;
      
      m00_axi_awid    => o_Y_axi_awid, --         ut std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      m00_axi_awaddr  => o_Y_axi_awaddr, --         ut std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
      m00_axi_awlen   => o_Y_axi_awlen, --         ut std_logic_vector(7 downto 0);
      m00_axi_awsize  => o_Y_axi_awsize, --         ut std_logic_vector(2 downto 0);
      m00_axi_awburst => o_Y_axi_awburst, --         ut std_logic_vector(1 downto 0);
      m00_axi_awlock  => o_Y_axi_awlock, --         ut std_logic;
      m00_axi_awcache => o_Y_axi_awcache, --         ut std_logic_vector(3 downto 0);
      m00_axi_awprot  => o_Y_axi_awprot, --         ut std_logic_vector(2 downto 0);
      m00_axi_awqos   => o_Y_axi_awqos, --         ut std_logic_vector(3 downto 0);
      m00_axi_awuser  => o_Y_axi_awuser, --         ut std_logic_vector(C_AXI_AWUSER_WIDTH-1 downto 0);
      m00_axi_awvalid => o_Y_axi_awvalid, --         ut std_logic;
      m00_axi_awready => i_Y_axi_awready, --         n std_logic;
      m00_axi_wdata   => o_Y_axi_wdata, --         ut std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
      m00_axi_wstrb   => o_Y_axi_wstrb, --         ut std_logic_vector(C_AXI_DATA_WIDTH/8-1 downto 0);
      m00_axi_wlast   => o_Y_axi_wlast, --         ut std_logic;
      m00_axi_wuser   => o_Y_axi_wuser, --         ut std_logic_vector(C_AXI_WUSER_WIDTH-1 downto 0);
      m00_axi_wvalid  => o_Y_axi_wvalid, --         ut std_logic;
      m00_axi_wready  => i_Y_axi_wready, --         n std_logic;
      m00_axi_bid     => i_Y_axi_bid, --         n std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      m00_axi_bresp   => i_Y_axi_bresp, --         n std_logic_vector(1 downto 0);
      m00_axi_buser   => i_Y_axi_buser, --         n std_logic_vector(C_AXI_BUSER_WIDTH-1 downto 0);
      m00_axi_bvalid  => i_Y_axi_bvalid, --         n std_logic;
      m00_axi_bready  => o_Y_axi_bready, --         ut std_logic;
      m00_axi_arid    => o_Y_axi_arid, --         ut std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      m00_axi_araddr  => o_Y_axi_araddr, --         ut std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
      m00_axi_arlen   => o_Y_axi_arlen, --         ut std_logic_vector(7 downto 0);
      m00_axi_arsize  => o_Y_axi_arsize, --         ut std_logic_vector(2 downto 0);
      m00_axi_arburst => o_Y_axi_arburst, --         ut std_logic_vector(1 downto 0);
      m00_axi_arlock  => o_Y_axi_arlock, --         ut std_logic;
      m00_axi_arcache => o_Y_axi_arcache, --         ut std_logic_vector(3 downto 0);
      m00_axi_arprot  => o_Y_axi_arprot, --         ut std_logic_vector(2 downto 0);
      m00_axi_arqos   => o_Y_axi_arqos, --         ut std_logic_vector(3 downto 0);
      m00_axi_aruser  => o_Y_axi_aruser, --         ut std_logic_vector(C_AXI_ARUSER_WIDTH-1 downto 0);
      m00_axi_arvalid => o_Y_axi_arvalid, --         ut std_logic;
      m00_axi_arready => i_Y_axi_arready, --         n std_logic;
      m00_axi_rid     => i_Y_axi_rid, --         n std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
      m00_axi_rdata   => i_Y_axi_rdata, --         n std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
      m00_axi_rresp   => i_Y_axi_rresp, --         n std_logic_vector(1 downto 0);
      m00_axi_rlast   => i_Y_axi_rlast, --         n std_logic;
      m00_axi_ruser   => i_Y_axi_ruser, --         n std_logic_vector(C_AXI_RUSER_WIDTH-1 downto 0);
      m00_axi_rvalid  => i_Y_axi_rvalid, --         n std_logic;
      m00_axi_rready  => o_Y_axi_rready, --         ut std_logic;

      m00_axis_tvalid => open, -- ;
      m00_axis_tdata  => open, -- (C_AXI_ADDR_WIDTH-1 downto 0);
      m00_axis_tstrb  => open, -- ((C_AXI_ADDR_WIDTH/8)-1 downto 0);
      m00_axis_tlast  => open, -- ;
      m00_axis_tready => '1',

      m01_axis_tvalid => open, -- ;
      m01_axis_tdata  => open, -- (C_AXI_DATA_WIDTH-1 downto 0);
      m01_axis_tstrb  => open, -- ((C_AXI_DATA_WIDTH/8)-1 downto 0);
      m01_axis_tlast  => open, -- ;
      m01_axis_tready => '1',

      m02_axis_tvalid => open, -- ;
      m02_axis_tdata  => open, -- (C_AXI_ADDR_WIDTH-1 downto 0);
      m02_axis_tstrb  => open, -- ((C_AXI_ADDR_WIDTH/8)-1 downto 0);
      m02_axis_tlast  => open, -- ;
      m02_axis_tready => '1',

      m03_axis_tvalid => open, -- ;
      m03_axis_tdata  => open, -- (C_AXI_DATA_WIDTH-1 downto 0);
      m03_axis_tstrb  => open, -- ((C_AXI_DATA_WIDTH/8)-1 downto 0);
      m03_axis_tlast  => open, -- ;
      m03_axis_tready => '1',

      opt_awready   => open,
      opt_wready    => open,
      opt_arready   => open,
      opt_rready    => open
    );
    
end bh;
