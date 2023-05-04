library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axis_splitter is
  generic (
    -- Users to add parameters here

    -- User parameters ends
    -- Do not modify the parameters beyond this line


    -- Parameters of Axi Slave Bus Interface S00_AXIS
    C_AXIS_TDATA_WIDTH  : integer := 32
  );
  port (
    -- Users to add ports here

    -- User ports ends
    -- Do not modify the ports beyond this line


    -- Ports of Axi Slave Bus Interface S00_AXIS
    axis_aclk : in std_logic;
    axis_aresetn  : in std_logic;

    s00_axis_tready : out std_logic;
    s00_axis_tdata  : in std_logic_vector(C_AXIS_TDATA_WIDTH-1 downto 0);
    s00_axis_tstrb  : in std_logic_vector((C_AXIS_TDATA_WIDTH/8)-1 downto 0);
    s00_axis_tlast  : in std_logic;
    s00_axis_tvalid : in std_logic;

    -- Ports of Axi Master Bus Interface M00_AXIS
    m00_axis_tvalid : out std_logic;
    m00_axis_tdata  : out std_logic_vector(C_AXIS_TDATA_WIDTH-1 downto 0);
    m00_axis_tstrb  : out std_logic_vector((C_AXIS_TDATA_WIDTH/8)-1 downto 0);
    m00_axis_tlast  : out std_logic;
    m00_axis_tready : in std_logic;

    -- Ports of Axi Master Bus Interface M01_AXIS
    m01_axis_tvalid : out std_logic;
    m01_axis_tdata  : out std_logic_vector(C_AXIS_TDATA_WIDTH-1 downto 0);
    m01_axis_tstrb  : out std_logic_vector((C_AXIS_TDATA_WIDTH/8)-1 downto 0);
    m01_axis_tlast  : out std_logic;
    m01_axis_tready : in std_logic;   -- m01_tready is ignored!

    opt_tready : out std_logic
  );
end axis_splitter;

architecture arch_imp of axis_splitter is

  signal axis_tready  : std_logic;
  signal axis_tdata : std_logic_vector(C_AXIS_TDATA_WIDTH-1 downto 0);
  signal axis_tstrb : std_logic_vector((C_AXIS_TDATA_WIDTH/8)-1 downto 0);
  signal axis_tlast : std_logic;
  signal axis_tvalid  : std_logic;

begin

  -- Add user logic here
  axis_tdata  <= s00_axis_tdata;
  axis_tstrb  <= s00_axis_tstrb;
  axis_tlast  <= s00_axis_tlast;
  axis_tvalid <= s00_axis_tvalid;

  axis_tready <= m00_axis_tready;
  s00_axis_tready <= axis_tready;
  opt_tready      <= axis_tready;

  m00_axis_tvalid <= axis_tvalid;
  m00_axis_tdata  <= axis_tdata;
  m00_axis_tstrb  <= axis_tstrb;
  m00_axis_tlast  <= axis_tlast;

  m01_axis_tvalid <= axis_tvalid;
  m01_axis_tdata  <= axis_tdata;
  m01_axis_tstrb  <= axis_tstrb;
  m01_axis_tlast  <= axis_tlast;

  -- User logic ends

end arch_imp;
