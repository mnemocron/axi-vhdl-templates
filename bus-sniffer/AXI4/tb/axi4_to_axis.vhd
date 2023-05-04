----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-04-21
-- Design Name:    AXIS axi4_to_axis
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

entity axi4_to_axis is
  generic (
    -- Users to add parameters here

    -- User parameters ends
    -- Do not modify the parameters beyond this line
    -- Width of ID for for write address, write data, read address and read data
    C_S_AXI_ID_WIDTH    : integer   := 1;
    -- Width of S_AXI data bus
    C_S_AXI_DATA_WIDTH  : integer   := 512;
    -- Width of S_AXI address bus
    C_S_AXI_ADDR_WIDTH  : integer   := 20;
    -- Width of optional user defined signal in write address channel
    C_S_AXI_AWUSER_WIDTH    : integer   := 0;
    -- Width of optional user defined signal in read address channel
    C_S_AXI_ARUSER_WIDTH    : integer   := 0;
    -- Width of optional user defined signal in write data channel
    C_S_AXI_WUSER_WIDTH : integer   := 0;
    -- Width of optional user defined signal in read data channel
    C_S_AXI_RUSER_WIDTH : integer   := 0;
    -- Width of optional user defined signal in write response channel
    C_S_AXI_BUSER_WIDTH : integer   := 0
    
  );
  port (
    -- Users to add ports here

    -- User ports ends
    -- Global ports
    AXIS_ACLK     : in std_logic;
    AXIS_ARESETN  : in std_logic;

    -- AXI4 (full) Slave
    -- Write Address ID
    S_AXI_AWID  : in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
    -- Write address
    S_AXI_AWADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    -- Burst length. The burst length gives the exact number of transfers in a burst
    S_AXI_AWLEN : in std_logic_vector(7 downto 0);
    -- Burst size. This signal indicates the size of each transfer in the burst
    S_AXI_AWSIZE    : in std_logic_vector(2 downto 0);
    -- Burst type. The burst type and the size information, 
    -- determine how the address for each transfer within the burst is calculated.
    S_AXI_AWBURST   : in std_logic_vector(1 downto 0);
    -- Lock type. Provides additional information about the
    -- atomic characteristics of the transfer.
    S_AXI_AWLOCK    : in std_logic;
    -- Memory type. This signal indicates how transactions
    -- are required to progress through a system.
    S_AXI_AWCACHE   : in std_logic_vector(3 downto 0);
    -- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
    S_AXI_AWPROT    : in std_logic_vector(2 downto 0);
    -- Quality of Service, QoS identifier sent for each
    -- write transaction.
    S_AXI_AWQOS : in std_logic_vector(3 downto 0);
    -- Region identifier. Permits a single physical interface
    -- on a slave to be used for multiple logical interfaces.
    S_AXI_AWREGION  : in std_logic_vector(3 downto 0);
    -- Optional User-defined signal in the write address channel.
    S_AXI_AWUSER    : in std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0);
    -- Write address valid. This signal indicates that
    -- the channel is signaling valid write address and
    -- control information.
    S_AXI_AWVALID   : in std_logic;
    -- Write address ready. This signal indicates that
    -- the slave is ready to accept an address and associated
    -- control signals.
    S_AXI_AWREADY   : out std_logic;
    -- Write Data
    S_AXI_WDATA : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    -- Write strobes. This signal indicates which byte
    -- lanes hold valid data. There is one write strobe
    -- bit for each eight bits of the write data bus.
    S_AXI_WSTRB : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    -- Write last. This signal indicates the last transfer
    -- in a write burst.
    S_AXI_WLAST : in std_logic;
    -- Optional User-defined signal in the write data channel.
    S_AXI_WUSER : in std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0);
    -- Write valid. This signal indicates that valid write
    -- data and strobes are available.
    S_AXI_WVALID    : in std_logic;
    -- Write ready. This signal indicates that the slave
    -- can accept the write data.
    S_AXI_WREADY    : out std_logic;
    -- Response ID tag. This signal is the ID tag of the
    -- write response.
    S_AXI_BID   : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
    -- Write response. This signal indicates the status
    -- of the write transaction.
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    -- Optional User-defined signal in the write response channel.
    S_AXI_BUSER : out std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
    -- Write response valid. This signal indicates that the
    -- channel is signaling a valid write response.
    S_AXI_BVALID    : out std_logic;
    -- Response ready. This signal indicates that the master
    -- can accept a write response.
    S_AXI_BREADY    : in std_logic;
    -- Read address ID. This signal is the identification
    -- tag for the read address group of signals.
    S_AXI_ARID  : in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
    -- Read address. This signal indicates the initial
    -- address of a read burst transaction.
    S_AXI_ARADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    -- Burst length. The burst length gives the exact number of transfers in a burst
    S_AXI_ARLEN : in std_logic_vector(7 downto 0);
    -- Burst size. This signal indicates the size of each transfer in the burst
    S_AXI_ARSIZE    : in std_logic_vector(2 downto 0);
    -- Burst type. The burst type and the size information, 
    -- determine how the address for each transfer within the burst is calculated.
    S_AXI_ARBURST   : in std_logic_vector(1 downto 0);
    -- Lock type. Provides additional information about the
    -- atomic characteristics of the transfer.
    S_AXI_ARLOCK    : in std_logic;
    -- Memory type. This signal indicates how transactions
    -- are required to progress through a system.
    S_AXI_ARCACHE   : in std_logic_vector(3 downto 0);
    -- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
    S_AXI_ARPROT    : in std_logic_vector(2 downto 0);
    -- Quality of Service, QoS identifier sent for each
    -- read transaction.
    S_AXI_ARQOS : in std_logic_vector(3 downto 0);
    -- Region identifier. Permits a single physical interface
    -- on a slave to be used for multiple logical interfaces.
    S_AXI_ARREGION  : in std_logic_vector(3 downto 0);
    -- Optional User-defined signal in the read address channel.
    S_AXI_ARUSER    : in std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0);
    -- Write address valid. This signal indicates that
    -- the channel is signaling valid read address and
    -- control information.
    S_AXI_ARVALID   : in std_logic;
    -- Read address ready. This signal indicates that
    -- the slave is ready to accept an address and associated
    -- control signals.
    S_AXI_ARREADY   : out std_logic;
    -- Read ID tag. This signal is the identification tag
    -- for the read data group of signals generated by the slave.
    S_AXI_RID   : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
    -- Read Data
    S_AXI_RDATA : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    -- Read response. This signal indicates the status of
    -- the read transfer.
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    -- Read last. This signal indicates the last transfer
    -- in a read burst.
    S_AXI_RLAST : out std_logic;
    -- Optional User-defined signal in the read address channel.
    S_AXI_RUSER : out std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
    -- Read valid. This signal indicates that the channel
    -- is signaling the required read data.
    S_AXI_RVALID    : out std_logic;
    -- Read ready. This signal indicates that the master can
    -- accept the read data and response information.
    S_AXI_RREADY    : in std_logic;

    -- AXI STREAM
    -- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
    M_AXIS_TVALID : out std_logic;
    -- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
    M_AXIS_TDATA  : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    -- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
    M_AXIS_TSTRB  : out std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    -- TLAST indicates the boundary of a packet.
    M_AXIS_TLAST  : out std_logic;
    -- TREADY indicates that the slave can accept a transfer in the current cycle.
    M_AXIS_TREADY : in  std_logic
  );
end axi4_to_axis;

architecture arch_imp of axi4_to_axis is
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
       s_data_i  : in  std_logic_vector((C_S_AXI_DATA_WIDTH+(C_S_AXI_DATA_WIDTH/8)) - 1 downto 0);

       m_valid_o : out std_logic;
       m_last_o  : out std_logic;
       m_ready_i : in  std_logic;
       m_data_o  : out std_logic_vector((C_S_AXI_DATA_WIDTH+(C_S_AXI_DATA_WIDTH/8)) - 1 downto 0));
  end component;

  type axi_rx_state_t is (AXI_RX_STATE_IDLE, AXI_RX_STATE_SIMPLE, AXI_RX_STATE_MULTI);
  signal state_axi_rx : axi_rx_state_t;

  -- signals
  signal aclk    : std_logic;
  signal aresetn : std_logic;

  signal i_s_axis_tvalid : std_logic := '0';
  signal i_s_axis_tdata  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal i_s_axis_data_strb  : std_logic_vector(C_S_AXI_DATA_WIDTH+(C_S_AXI_DATA_WIDTH/8)-1 downto 0);
  signal i_s_axis_tstrb  : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
  signal i_s_axis_tlast  : std_logic;
  signal o_s_axis_tready : std_logic;

  signal o_m_axis_tvalid : std_logic;
  signal o_m_axis_tdata  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal o_m_axis_data_strb  : std_logic_vector(C_S_AXI_DATA_WIDTH+(C_S_AXI_DATA_WIDTH/8)-1 downto 0);
  signal o_m_axis_tstrb  : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
  signal o_m_axis_tlast  : std_logic;
  signal i_m_axis_tready : std_logic := '0';

  -- Write Response
  --signal o_axi_bresp  : std_logic_vector(1 downto 0);
  --signal o_axi_bvalid : std_logic;
  --signal o_axi_bid    : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  --signal i_axi_bready : std_logic;

  signal temp_bid       : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal bresp_pending  : std_logic;
  signal debug_state    : std_logic_vector(1 downto 0);

  signal i_axi_awid     : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal i_axi_awaddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal i_axi_awlen    : std_logic_vector(7 downto 0);
  signal i_axi_awsize   : std_logic_vector(2 downto 0);
  signal i_axi_awburst  : std_logic_vector(1 downto 0);
  signal i_axi_awlock   : std_logic;
  signal i_axi_awcache  : std_logic_vector(3 downto 0);
  signal i_axi_awprot   : std_logic_vector(2 downto 0);
  signal i_axi_awqos    : std_logic_vector(3 downto 0);
  signal i_axi_awregion : std_logic_vector(3 downto 0);
  signal i_axi_awuser   : std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0);
  signal i_axi_awvalid  : std_logic;
  signal o_axi_awready  : std_logic;

  signal i_axi_wdata    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal i_axi_wstrb    : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
  signal i_axi_wlast    : std_logic;
  signal i_axi_wuser    : std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0);
  signal i_axi_wvalid   : std_logic;
  signal o_axi_wready   : std_logic;

  signal o_axi_bid      : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal o_axi_bresp    : std_logic_vector(1 downto 0);
  signal o_axi_buser    : std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
  signal o_axi_bvalid   : std_logic;
  signal i_axi_bready   : std_logic;
  signal i_axi_arid     : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal i_axi_araddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal i_axi_arlen    : std_logic_vector(7 downto 0);
  signal i_axi_arsize   : std_logic_vector(2 downto 0);
  signal i_axi_arburst  : std_logic_vector(1 downto 0);
  signal i_axi_arlock   : std_logic;
  signal i_axi_arcache  : std_logic_vector(3 downto 0);
  signal i_axi_arprot   : std_logic_vector(2 downto 0);
  signal i_axi_arqos    : std_logic_vector(3 downto 0);
  signal i_axi_arregion : std_logic_vector(3 downto 0);
  signal i_axi_aruser   : std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0);
  signal i_axi_arvalid  : std_logic;
  signal o_axi_arready  : std_logic;
  signal o_axi_rid      : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal o_axi_rdata    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal o_axi_rresp    : std_logic_vector(1 downto 0);
  signal o_axi_rlast    : std_logic;
  signal o_axi_ruser    : std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
  signal o_axi_rvalid   : std_logic;
  signal i_axi_rready   : std_logic;

begin
  -- I/O connections assignments
  aclk    <= AXIS_ACLK;
  aresetn <= AXIS_ARESETN;

  -- inputs
  o_axi_wready <= o_s_axis_tready;

  i_m_axis_tready <= M_AXIS_TREADY;
  i_s_axis_tvalid <= S_AXI_WVALID;
  i_s_axis_tdata  <= S_AXI_WDATA;
  i_s_axis_tstrb  <= S_AXI_WSTRB;
  i_s_axis_tlast  <= S_AXI_WLAST;
  i_axi_bready  <= S_AXI_BREADY;

  i_axi_awid     <= S_AXI_AWID;
  i_axi_awaddr   <= S_AXI_AWADDR;
  i_axi_awlen    <= S_AXI_AWLEN;
  i_axi_awsize   <= S_AXI_AWSIZE;
  i_axi_awburst  <= S_AXI_AWBURST;
  i_axi_awlock   <= S_AXI_AWLOCK;
  i_axi_awcache  <= S_AXI_AWCACHE;
  i_axi_awprot   <= S_AXI_AWPROT;
  i_axi_awqos    <= S_AXI_AWQOS;
  i_axi_awregion <= S_AXI_AWREGION;
  i_axi_awuser   <= S_AXI_AWUSER;
  i_axi_awvalid  <= S_AXI_AWVALID;
  S_AXI_AWREADY  <= o_axi_awready;

  -- outputs
  S_AXI_WREADY  <= o_s_axis_tready;
  M_AXIS_TVALID <= o_m_axis_tvalid;
  M_AXIS_TDATA  <= o_m_axis_tdata;
  M_AXIS_TSTRB  <= o_m_axis_tstrb;
  M_AXIS_TLAST  <= o_m_axis_tlast;
  S_AXI_BRESP   <= o_axi_bresp;
  S_AXI_BVALID  <= o_axi_bvalid;
  S_AXI_BID     <= o_axi_bid;

  i_axi_wdata   <= S_AXI_WDATA;
  i_axi_wstrb   <= S_AXI_WSTRB;
  i_axi_wlast   <= S_AXI_WLAST;
  i_axi_wuser   <= S_AXI_WUSER;
  i_axi_wvalid  <= S_AXI_WVALID;
  S_AXI_WREADY  <= o_axi_wready;

  -- combine strobe and data signals into single "data" channel
  i_s_axis_data_strb <= i_s_axis_tdata & i_s_axis_tstrb;
  o_m_axis_tdata <= o_m_axis_data_strb( (C_S_AXI_DATA_WIDTH+(C_S_AXI_DATA_WIDTH/8)) - 1 downto (C_S_AXI_DATA_WIDTH/8) );
  o_m_axis_tstrb <= o_m_axis_data_strb( (C_S_AXI_DATA_WIDTH/8) - 1 downto 0 );

  p_axi_rx_flow_state : process(aclk)
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        state_axi_rx <= AXI_RX_STATE_IDLE;
        o_axi_bvalid <= '0';
        o_axi_bresp  <= (others => '0');
        o_axi_bid    <= (others => '0');
        o_axi_awready <= '1';  -- "always" ready to accept AW (because address gets discarded anyways)
        bresp_pending <= '0';
        debug_state <= "00";
      else
        -- state machine that can accept up to 2 requests over AW channel
        case state_axi_rx is
          -- IDLE: wait for AW request, remember AWID for BID, go to RX_SIMPLE
          when AXI_RX_STATE_IDLE =>
            debug_state <= "01";
            if i_axi_awvalid = '1' and o_axi_awready = '1' then -- accept incomming AW request
              state_axi_rx <= AXI_RX_STATE_SIMPLE;
              o_axi_bid <= i_axi_awid;
              o_axi_awready <= '0';
            end if;
            if i_s_axis_tlast = '1' then
              -- tlast signals that the transfer can be aknowledged via BRESP channel
              o_axi_bvalid <= '1';
            end if;
            if o_axi_bvalid = '1' and i_axi_bready = '1' then
              -- deasert, if BRESP is aknowledged
              o_axi_bvalid <= '0';
            end if;

          -- RX_SIMPLE: only 1 incomming xfer, AXI Slave can still accept AW requests
          -- when another AW reqest is incomming go to RX_MULTI
          when AXI_RX_STATE_SIMPLE =>
            debug_state <= "10";
            if i_axi_awvalid = '1' and o_axi_awready = '1' then -- accept ANOTHER incomming AW request
              state_axi_rx <= AXI_RX_STATE_MULTI;
              -- signal the pending signal, if awvalid, awready and tlast assert at the same time
              bresp_pending <= o_m_axis_tlast; 
              temp_bid <= i_axi_awid;
              o_axi_bvalid <= '0';
              o_axi_awready <= '0';
            elsif o_m_axis_tlast = '1' then
              -- tlast signals that the transfer is complete and can be aknowledged via BRESP channel
              state_axi_rx <= AXI_RX_STATE_IDLE;
              o_axi_bvalid <= '1';
              o_axi_awready <= '1';
            else
              -- wait for transfer to be complete
              state_axi_rx <= AXI_RX_STATE_SIMPLE;
              o_axi_bvalid <= '0';
              o_axi_awready <= '1';
            end if;
            if o_axi_bvalid = '1' and i_axi_bready = '1' then
              -- deasert, if BRESP is aknowledged
              o_axi_bvalid <= '0';
            end if;

          -- RX_MULTI: multiple xfers pending, AXI Slave AW is stalled
          when AXI_RX_STATE_MULTI =>
            debug_state <= "11";
            if bresp_pending = '1' then
              bresp_pending <= '0';
              state_axi_rx <= AXI_RX_STATE_SIMPLE;
              o_axi_awready <= '1';
              o_axi_bvalid <= '1';
            elsif o_m_axis_tlast = '1' then
              state_axi_rx <= AXI_RX_STATE_SIMPLE;
              o_axi_awready <= '1';
              o_axi_bid <= temp_bid;
              o_axi_bvalid <= '1';
            else
              o_axi_awready <= '0';
            end if;
       end case;
      end if;
    end if;
  end process;

  skidbuffer_inst : skidbuffer
  generic map (
      DATA_WIDTH    => (C_S_AXI_DATA_WIDTH+(C_S_AXI_DATA_WIDTH/8)),
      OPT_DATA_REG  => True
  )
  port map (
    clock     => aclk,
    reset_n   => aresetn,

    s_valid_i => i_s_axis_tvalid,
    s_last_i  => i_s_axis_tlast,
    s_ready_o => o_s_axis_tready,
    s_data_i  => i_s_axis_data_strb,

    m_valid_o => o_m_axis_tvalid,
    m_last_o  => o_m_axis_tlast,
    m_ready_i => i_m_axis_tready,
    m_data_o  => o_m_axis_data_strb
  );

end arch_imp;
