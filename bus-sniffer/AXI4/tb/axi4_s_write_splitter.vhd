library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi4_s_write_splitter is
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
    
    -- Ports of Axi Master Bus Interface M00_AXI
    -- m00_axi_init_axi_txn  : in std_logic;
    -- m00_axi_txn_done  : out std_logic;
    -- m00_axi_error     : out std_logic;

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

    -- AW PORT
    -- Ports of Axi Master Bus Interface M00_AXIS
    m00_axis_tvalid : out std_logic;
    m00_axis_tdata  : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
    m00_axis_tstrb  : out std_logic_vector((C_AXI_ADDR_WIDTH/8)-1 downto 0);
    m00_axis_tlast  : out std_logic;
    m00_axis_tready : in std_logic;

    -- W PORT
    -- Ports of Axi Master Bus Interface M01_AXIS
    m01_axis_tvalid : out std_logic;
    m01_axis_tdata  : out std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
    m01_axis_tstrb  : out std_logic_vector((C_AXI_DATA_WIDTH/8)-1 downto 0);
    m01_axis_tlast  : out std_logic;
    m01_axis_tready : in std_logic;

    -- AR PORT
    -- Ports of Axi Master Bus Interface M02_AXIS
    m02_axis_tvalid : out std_logic;
    m02_axis_tdata  : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
    m02_axis_tstrb  : out std_logic_vector((C_AXI_ADDR_WIDTH/8)-1 downto 0);
    m02_axis_tlast  : out std_logic;
    m02_axis_tready : in std_logic;

    -- R PORT
    -- Ports of Axi Master Bus Interface M03_AXIS
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
end axi4_s_write_splitter;

architecture arch_imp of axi4_s_write_splitter is

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
  aw_axis_tvalid  <= s00_axi_awvalid;
  aw_axis_tdata   <= s00_axi_awaddr;
  aw_axis_tstrb   <= (others => '1');
  aw_axis_tlast   <= '0';
  m00_axis_tvalid <= aw_axis_tvalid;
  m00_axis_tdata  <= aw_axis_tdata;
  m00_axis_tstrb  <= aw_axis_tstrb;
  m00_axis_tlast  <= aw_axis_tlast;

  w_axis_tvalid   <= s00_axi_wvalid;
  w_axis_tdata    <= s00_axi_wdata;
  w_axis_tstrb    <= s00_axi_wstrb;
  w_axis_tlast    <= s00_axi_wlast;
  m01_axis_tvalid <= w_axis_tvalid;
  m01_axis_tdata  <= w_axis_tdata;
  m01_axis_tstrb  <= w_axis_tstrb;
  m01_axis_tlast  <= w_axis_tlast;

  ar_axis_tvalid  <= s00_axi_arvalid;
  ar_axis_tdata   <= s00_axi_araddr;
  ar_axis_tstrb   <= (others => '1');
  ar_axis_tlast   <= '0';
  m02_axis_tvalid <= ar_axis_tvalid;
  m02_axis_tdata  <= ar_axis_tdata;
  m02_axis_tstrb  <= ar_axis_tstrb;
  m02_axis_tlast  <= ar_axis_tlast;

  r_axis_tvalid   <= m00_axi_rvalid;
  r_axis_tdata    <= m00_axi_rdata;
  r_axis_tstrb    <= (others => '1');
  r_axis_tlast    <= m00_axi_rlast;
  m03_axis_tvalid <= r_axis_tvalid;
  m03_axis_tdata  <= r_axis_tdata;
  m03_axis_tstrb  <= r_axis_tstrb;
  m03_axis_tlast  <= r_axis_tlast;

  i_axi_awid    <= s00_axi_awid;   
  i_axi_awaddr  <= s00_axi_awaddr;   
  i_axi_awlen   <= s00_axi_awlen;   
  i_axi_awsize  <= s00_axi_awsize;   
  i_axi_awburst <= s00_axi_awburst; 
  i_axi_awlock  <= s00_axi_awlock;   
  i_axi_awcache <= s00_axi_awcache; 
  i_axi_awprot  <= s00_axi_awprot;   
  i_axi_awqos   <= s00_axi_awqos;   
  i_axi_awregion <= s00_axi_awregion; 
  i_axi_awuser  <= s00_axi_awuser;   
  i_axi_awvalid <= s00_axi_awvalid; 
  o_axi_awready <= m00_axi_awready; 
  i_axi_wdata   <= s00_axi_wdata;   
  i_axi_wstrb   <= s00_axi_wstrb;   
  i_axi_wlast   <= s00_axi_wlast;   
  i_axi_wuser   <= s00_axi_wuser;   
  i_axi_wvalid  <= s00_axi_wvalid;   
  o_axi_wready  <= m00_axi_wready;   
  o_axi_bid     <= m00_axi_bid;   
  o_axi_bresp   <= m00_axi_bresp;   
  o_axi_buser   <= m00_axi_buser;   
  o_axi_bvalid  <= m00_axi_bvalid;   
  i_axi_bready  <= s00_axi_bready;   
  i_axi_arid    <= s00_axi_arid;   
  i_axi_araddr  <= s00_axi_araddr;   
  i_axi_arlen   <= s00_axi_arlen;   
  i_axi_arsize  <= s00_axi_arsize;   
  i_axi_arburst <= s00_axi_arburst; 
  i_axi_arlock  <= s00_axi_arlock;   
  i_axi_arcache <= s00_axi_arcache; 
  i_axi_arprot  <= s00_axi_arprot;   
  i_axi_arqos   <= s00_axi_arqos;
  i_axi_arregion <= s00_axi_arregion;
  i_axi_aruser  <= s00_axi_aruser;
  i_axi_arvalid <= s00_axi_arvalid;
  o_axi_arready <= m00_axi_arready;
  o_axi_rid     <= m00_axi_rid;
  o_axi_rdata   <= m00_axi_rdata;
  o_axi_rresp   <= m00_axi_rresp;
  o_axi_rlast   <= m00_axi_rlast;
  o_axi_ruser   <= m00_axi_ruser;
  o_axi_rvalid  <= m00_axi_rvalid;
  i_axi_rready  <= s00_axi_rready;

  m00_axi_awid    <= i_axi_awid;   
  m00_axi_awaddr  <= i_axi_awaddr;   
  m00_axi_awlen   <= i_axi_awlen;   
  m00_axi_awsize  <= i_axi_awsize;   
  m00_axi_awburst <= i_axi_awburst; 
  m00_axi_awlock  <= i_axi_awlock;   
  m00_axi_awcache <= i_axi_awcache; 
  m00_axi_awprot  <= i_axi_awprot;   
  m00_axi_awqos   <= i_axi_awqos;   
--  m00_axi_awregion <= i_axi_awregion; 
  m00_axi_awuser  <= i_axi_awuser;   
  m00_axi_awvalid <= i_axi_awvalid; 
  s00_axi_awready <= o_axi_awready; 
  m00_axi_wdata   <= i_axi_wdata;   
  m00_axi_wstrb   <= i_axi_wstrb;   
  m00_axi_wlast   <= i_axi_wlast;   
  m00_axi_wuser   <= i_axi_wuser;   
  m00_axi_wvalid  <= i_axi_wvalid;   
  s00_axi_wready  <= o_axi_wready;   
  s00_axi_bid     <= o_axi_bid;   
  s00_axi_bresp   <= o_axi_bresp;   
  s00_axi_buser   <= o_axi_buser;   
  s00_axi_bvalid  <= o_axi_bvalid;   
  m00_axi_bready  <= i_axi_bready;   
  m00_axi_arid    <= i_axi_arid;   
  m00_axi_araddr  <= i_axi_araddr;   
  m00_axi_arlen   <= i_axi_arlen;   
  m00_axi_arsize  <= i_axi_arsize;   
  m00_axi_arburst <= i_axi_arburst; 
  m00_axi_arlock  <= i_axi_arlock;   
  m00_axi_arcache <= i_axi_arcache; 
  m00_axi_arprot  <= i_axi_arprot;   
  m00_axi_arqos   <= i_axi_arqos;
--  m00_axi_arregion <= i_axi_arregion;
  m00_axi_aruser  <= i_axi_aruser;
  m00_axi_arvalid <= i_axi_arvalid;
  s00_axi_arready <= o_axi_arready;
  s00_axi_rid     <= o_axi_rid;
  s00_axi_rdata   <= o_axi_rdata;
  s00_axi_rresp   <= o_axi_rresp;
  s00_axi_rlast   <= o_axi_rlast;
  s00_axi_ruser   <= o_axi_ruser;
  s00_axi_rvalid  <= o_axi_rvalid;
  m00_axi_rready  <= i_axi_rready;

  -- User logic ends

end arch_imp;
