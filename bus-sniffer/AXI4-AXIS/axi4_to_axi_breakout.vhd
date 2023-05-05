library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi4_s_axis_s_splitter is
  generic (
    -- Users to add parameters here

    -- User parameters ends
    -- Do not modify the parameters beyond this line


    -- Parameters of Axi Slave Bus Interface S00_AXI
    C_AXI_ID_WIDTH  : integer := 1;
    C_AXI_DATA_WIDTH  : integer := 32;
    C_AXI_ADDR_WIDTH  : integer := 6;
    C_AXI_AWUSER_WIDTH  : integer := 0;
    C_AXI_ARUSER_WIDTH  : integer := 0;
    C_AXI_WUSER_WIDTH : integer := 0;
    C_AXI_RUSER_WIDTH : integer := 0;
    C_AXI_BUSER_WIDTH : integer := 0
  );
  port (
    -- Users to add ports here

    -- User ports ends
    -- Do not modify the ports beyond this line

    -- Ports of Axi Slave Bus Interface S00_AXI
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
    s00_axi_wready  : in std_logic;
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

    -- AW PORT
    -- Ports of Axi Master Bus Interface M00_AXIS
    m00_axis_tvalid : out std_logic;
    m00_axis_tdata  : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
    m00_axis_tstrb  : out std_logic_vector((C_AXI_ADDR_WIDTH/8)-1 downto 0);
    m00_axis_tlast  : out std_logic;
    m00_axis_tready : out std_logic;
  );
end axi4_s_axis_s_splitter;

architecture arch_imp of axi4_s_axis_s_splitter is

  signal aw_axis_tvalid : std_logic;
  signal aw_axis_tdata  : std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
  signal aw_axis_tstrb  : std_logic_vector((C_AXI_ADDR_WIDTH/8)-1 downto 0);
  signal aw_axis_tlast  : std_logic;

  signal w_axis_tvalid  : std_logic;
  signal w_axis_tdata   : std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
  signal w_axis_tstrb   : std_logic_vector((C_AXI_ADDR_WIDTH/8)-1 downto 0);
  signal w_axis_tlast   : std_logic;

  signal ar_axis_tvalid : std_logic;
  signal ar_axis_tdata  : std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
  signal ar_axis_tstrb  : std_logic_vector((C_AXI_ADDR_WIDTH/8)-1 downto 0);
  signal ar_axis_tlast  : std_logic;

  signal r_axis_tvalid  : std_logic;
  signal r_axis_tdata   : std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
  signal r_axis_tstrb   : std_logic_vector((C_AXI_ADDR_WIDTH/8)-1 downto 0);
  signal r_axis_tlast   : std_logic;

  signal i_axi_awid     : std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
  signal i_axi_awaddr   : std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
  signal i_axi_awlen    : std_logic_vector(7 downto 0);
  signal i_axi_awsize   : std_logic_vector(2 downto 0);
  signal i_axi_awburst  : std_logic_vector(1 downto 0);
  signal i_axi_awlock   : std_logic;
  signal i_axi_awcache  : std_logic_vector(3 downto 0);
  signal i_axi_awprot   : std_logic_vector(2 downto 0);
  signal i_axi_awqos    : std_logic_vector(3 downto 0);
  signal i_axi_awregion : std_logic_vector(3 downto 0);
  signal i_axi_awuser   : std_logic_vector(C_AXI_AWUSER_WIDTH-1 downto 0);
  signal i_axi_awvalid  : std_logic;
  signal o_axi_awready  : std_logic;
  signal i_axi_wdata    : std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
  signal i_axi_wstrb    : std_logic_vector((C_AXI_DATA_WIDTH/8)-1 downto 0);
  signal i_axi_wlast    : std_logic;
  signal i_axi_wuser    : std_logic_vector(C_AXI_WUSER_WIDTH-1 downto 0);
  signal i_axi_wvalid   : std_logic;
  signal o_axi_wready   : std_logic;
  signal o_axi_bid      : std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
  signal o_axi_bresp    : std_logic_vector(1 downto 0);
  signal o_axi_buser    : std_logic_vector(C_AXI_BUSER_WIDTH-1 downto 0);
  signal o_axi_bvalid   : std_logic;
  signal i_axi_bready   : std_logic;
  signal i_axi_arid     : std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
  signal i_axi_araddr   : std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
  signal i_axi_arlen    : std_logic_vector(7 downto 0);
  signal i_axi_arsize   : std_logic_vector(2 downto 0);
  signal i_axi_arburst  : std_logic_vector(1 downto 0);
  signal i_axi_arlock   : std_logic;
  signal i_axi_arcache  : std_logic_vector(3 downto 0);
  signal i_axi_arprot   : std_logic_vector(2 downto 0);
  signal i_axi_arqos    : std_logic_vector(3 downto 0);
  signal i_axi_arregion : std_logic_vector(3 downto 0);
  signal i_axi_aruser   : std_logic_vector(C_AXI_ARUSER_WIDTH-1 downto 0);
  signal i_axi_arvalid  : std_logic;
  signal o_axi_arready  : std_logic;
  signal o_axi_rid      : std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
  signal o_axi_rdata    : std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
  signal o_axi_rresp    : std_logic_vector(1 downto 0);
  signal o_axi_rlast    : std_logic;
  signal o_axi_ruser    : std_logic_vector(C_AXI_RUSER_WIDTH-1 downto 0);
  signal o_axi_rvalid   : std_logic;
  signal i_axi_rready   : std_logic;

begin

  -- Add user logic here
  w_axis_tvalid   <= s00_axi_wvalid;
  w_axis_tdata    <= s00_axi_wdata;
  w_axis_tstrb    <= s00_axi_wstrb;
  w_axis_tlast    <= s00_axi_wlast;
  w_axis_tready   <= s00_axi_wready;

  m00_axis_tvalid <= w_axis_tvalid;
  m00_axis_tdata  <= w_axis_tdata;
  m00_axis_tstrb  <= w_axis_tstrb;
  m00_axis_tlast  <= w_axis_tlast;
  m00_axis_tready <= w_axis_tready;


  -- User logic ends

end arch_imp;
