-----------------------------------------------------------------------------------
--!     @file    interface_components.vhd                                        --
--!     @brief   Merge Sorter Interface Component Library Description Package    --
--!     @version 0.1.0                                                           --
--!     @date    2018/07/18                                                      --
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>                     --
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--                                                                               --
--      Copyright (C) 2018 Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>           --
--      All rights reserved.                                                     --
--                                                                               --
--      Redistribution and use in source and binary forms, with or without       --
--      modification, are permitted provided that the following conditions       --
--      are met:                                                                 --
--                                                                               --
--        1. Redistributions of source code must retain the above copyright      --
--           notice, this list of conditions and the following disclaimer.       --
--                                                                               --
--        2. Redistributions in binary form must reproduce the above copyright   --
--           notice, this list of conditions and the following disclaimer in     --
--           the documentation and/or other materials provided with the          --
--           distribution.                                                       --
--                                                                               --
--      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS      --
--      "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT        --
--      LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR    --
--      A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT    --
--      OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,    --
--      SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT         --
--      LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,    --
--      DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY    --
--      THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT      --
--      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE    --
--      OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.     --
--                                                                               --
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
library Merge_Sorter;
use     Merge_Sorter.Interface;
-----------------------------------------------------------------------------------
--! @brief Merge Sorter Interface Component Library Description Package          --
-----------------------------------------------------------------------------------
package Interface_Components is
-----------------------------------------------------------------------------------
--! @brief Merge_Reader                                                          --
-----------------------------------------------------------------------------------
component Merge_Reader
    generic (
        IN_NUM          :  integer :=  8;
        REG_PARAM       :  Merge_Sorter_Interface.Regs_Field_Type := Merge_Sorter_Interface.Default_Regs_Param;
        REQ_ADDR_BITS   :  integer := 32;
        REQ_SIZE_BITS   :  integer := 32;
        MRG_DATA_BITS   :  integer := 64;
        BUF_DATA_BITS   :  integer := 64;
        BUF_DEPTH       :  integer := 13;
        MAX_XFER_SIZE   :  integer := 12
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_L           :  in  std_logic_vector(IN_NUM*REG_PARAM.BITS-1 downto 0);
        REG_D           :  in  std_logic_vector(IN_NUM*REG_PARAM.BITS-1 downto 0);
        REG_Q           :  out std_logic_vector(IN_NUM*REG_PARAM.BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- Transaction Command Request Signals.
    -------------------------------------------------------------------------------
        REQ_VALID       :  out std_logic_vector(IN_NUM               -1 downto 0);
        REQ_ADDR        :  out std_logic_vector(REQ_ADDR_BITS        -1 downto 0);
        REQ_SIZE        :  out std_logic_vector(REQ_SIZE_BITS        -1 downto 0);
        REQ_BUF_PTR     :  out std_logic_vector(BUF_DEPTH            -1 downto 0);
        REQ_MODE        :  out std_logic_vector(REG_PARAM.MODE_BITS  -1 downto 0);
        REQ_FIRST       :  out std_logic;
        REQ_LAST        :  out std_logic;
        REQ_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transaction Command Acknowledge Signals.
    -------------------------------------------------------------------------------
        ACK_VALID       :  in  std_logic_vector(IN_NUM               -1 downto 0);
        ACK_SIZE        :  in  std_logic_vector(BUF_DEPTH               downto 0);
        ACK_ERROR       :  in  std_logic := '0';
        ACK_NEXT        :  in  std_logic;
        ACK_LAST        :  in  std_logic;
        ACK_STOP        :  in  std_logic;
        ACK_NONE        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transfer Status Signals.
    -------------------------------------------------------------------------------
        XFER_BUSY       :  in  std_logic_vector(IN_NUM               -1 downto 0);
        XFER_DONE       :  in  std_logic_vector(IN_NUM               -1 downto 0);
        XFER_ERROR      :  in  std_logic_vector(IN_NUM               -1 downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    -- Intake Flow Control Signals.
    -------------------------------------------------------------------------------
        FLOW_READY      :  out std_logic;
        FLOW_PAUSE      :  out std_logic;
        FLOW_STOP       :  out std_logic;
        FLOW_LAST       :  out std_logic;
        FLOW_SIZE       :  out std_logic_vector(BUF_DEPTH               downto 0);
        PUSH_FIN_VALID  :  in  std_logic_vector(IN_NUM               -1 downto 0);
        PUSH_FIN_LAST   :  in  std_logic;
        PUSH_FIN_ERROR  :  in  std_logic := '0';
        PUSH_FIN_SIZE   :  in  std_logic_vector(BUF_DEPTH               downto 0);
        PUSH_BUF_RESET  :  in  std_logic_vector(IN_NUM               -1 downto 0) := (others => '0');
        PUSH_BUF_VALID  :  in  std_logic_vector(IN_NUM               -1 downto 0) := (others => '0');
        PUSH_BUF_LAST   :  in  std_logic;
        PUSH_BUF_ERROR  :  in  std_logic := '0';
        PUSH_BUF_SIZE   :  in  std_logic_vector(BUF_DEPTH               downto 0);
        PUSH_BUF_READY  :  out std_logic_vector(IN_NUM               -1 downto 0);
    -------------------------------------------------------------------------------
    -- Buffer Interface Signals.
    -------------------------------------------------------------------------------
        BUF_WEN         :  in  std_logic_vector(IN_NUM               -1 downto 0);
        BUF_BEN         :  in  std_logic_vector(BUF_DATA_BITS/8      -1 downto 0);
        BUF_DATA        :  in  std_logic_vector(BUF_DATA_BITS        -1 downto 0);
        BUF_PTR         :  in  std_logic_vector(BUF_DEPTH               downto 0);
    -------------------------------------------------------------------------------
    -- Merge Outlet Signals.
    -------------------------------------------------------------------------------
        MRG_DATA        :  out std_logic_vector(IN_NUM*MRG_DATA_BITS -1 downto 0);
        MRG_NONE        :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_EBLK        :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_LAST        :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_VALID       :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_READY       :  in  std_logic_vector(IN_NUM               -1 downto 0);
        MRG_LEVEL       :  in  std_logic_vector(IN_NUM               -1 downto 0);
    -------------------------------------------------------------------------------
    -- Status Output.
    -------------------------------------------------------------------------------
        BUSY            :  out std_logic_vector(IN_NUM               -1 downto 0);
        DONE            :  out std_logic_vector(IN_NUM               -1 downto 0)
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_Writer                                                          --
-----------------------------------------------------------------------------------
component Merge_Writer
    generic (
        REG_PARAM       :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        REQ_ADDR_BITS   :  integer := 32;
        REQ_SIZE_BITS   :  integer := 32;
        BUF_DATA_BITS   :  integer := 64;
        BUF_DEPTH       :  integer := 13;
        MAX_XFER_SIZE   :  integer := 12;
        MRG_NUM         :  integer :=  1;
        MRG_DATA_BITS   :  integer := 64
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_L           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_D           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_Q           :  out std_logic_vector(REG_PARAM.BITS     -1 downto 0);
    -------------------------------------------------------------------------------
    -- Transaction Command Request Signals.
    -------------------------------------------------------------------------------
        REQ_VALID       :  out std_logic;
        REQ_ADDR        :  out std_logic_vector(REQ_ADDR_BITS      -1 downto 0);
        REQ_SIZE        :  out std_logic_vector(REQ_SIZE_BITS      -1 downto 0);
        REQ_BUF_PTR     :  out std_logic_vector(BUF_DEPTH          -1 downto 0);
        REQ_MODE        :  out std_logic_vector(REG_PARAM.MODE_BITS-1 downto 0);
        REQ_FIRST       :  out std_logic;
        REQ_LAST        :  out std_logic;
        REQ_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transaction Command Acknowledge Signals.
    -------------------------------------------------------------------------------
        ACK_VALID       :  in  std_logic;
        ACK_SIZE        :  in  std_logic_vector(BUF_DEPTH             downto 0);
        ACK_ERROR       :  in  std_logic := '0';
        ACK_NEXT        :  in  std_logic;
        ACK_LAST        :  in  std_logic;
        ACK_STOP        :  in  std_logic;
        ACK_NONE        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transfer Status Signals.
    -------------------------------------------------------------------------------
        XFER_BUSY       :  in  std_logic;
        XFER_DONE       :  in  std_logic;
        XFER_ERROR      :  in  std_logic := '0';
    -------------------------------------------------------------------------------
    -- Intake Flow Control Signals.
    -------------------------------------------------------------------------------
        FLOW_READY      :  out std_logic;
        FLOW_PAUSE      :  out std_logic;
        FLOW_STOP       :  out std_logic;
        FLOW_LAST       :  out std_logic;
        FLOW_SIZE       :  out std_logic_vector(BUF_DEPTH             downto 0);
        PULL_FIN_VALID  :  in  std_logic;
        PULL_FIN_LAST   :  in  std_logic;
        PULL_FIN_ERROR  :  in  std_logic := '0';
        PULL_FIN_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PULL_BUF_RESET  :  in  std_logic;
        PULL_BUF_VALID  :  in  std_logic;
        PULL_BUF_LAST   :  in  std_logic;
        PULL_BUF_ERROR  :  in  std_logic := '0';
        PULL_BUF_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PULL_BUF_READY  :  out std_logic;
    -------------------------------------------------------------------------------
    -- Buffer Interface Signals.
    -------------------------------------------------------------------------------
        BUF_REN         :  in  std_logic_vector;
        BUF_DATA        :  out std_logic_vector(BUF_DATA_BITS      -1 downto 0);
        BUF_PTR         :  in  std_logic_vector(BUF_DEPTH          -1 downto 0);
    -------------------------------------------------------------------------------
    -- Merge Intake Signals.
    -------------------------------------------------------------------------------
        MRG_DATA        :  in  std_logic_vector(MRG_NUM*MRG_DATA_BITS  -1 downto 0);
        MRG_STRB        :  in  std_logic_vector(MRG_NUM*MRG_DATA_BITS/8-1 downto 0);
        MRG_LAST        :  in  std_logic;
        MRG_VALID       :  in  std_logic;
        MRG_READY       :  out std_logic;
    -------------------------------------------------------------------------------
    -- Status Output.
    -------------------------------------------------------------------------------
        BUSY            :  out std_logic;
        DONE            :  out std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief ArgSort_Reader                                                        --
-----------------------------------------------------------------------------------
component ArgSort_Reader
    generic (
        REG_PARAM       :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        REQ_ADDR_BITS   :  integer := 32;
        REQ_SIZE_BITS   :  integer := 32;
        BUF_DATA_BITS   :  integer := 64;
        BUF_DEPTH       :  integer := 13;
        MAX_XFER_SIZE   :  integer := 12;
        STM_NUM         :  integer :=  1;
        STM_DATA_BITS   :  integer := 64;
        STM_INDEX_LO    :  integer :=  0;
        STM_INDEX_HI    :  integer := 31;
        STM_COMP_LO     :  integer := 32;
        STM_COMP_HI     :  integer := 63
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_L           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_D           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_Q           :  out std_logic_vector(REG_PARAM.BITS     -1 downto 0);
    -------------------------------------------------------------------------------
    -- Transaction Command Request Signals.
    -------------------------------------------------------------------------------
        REQ_VALID       :  out std_logic;
        REQ_ADDR        :  out std_logic_vector(REQ_ADDR_BITS      -1 downto 0);
        REQ_SIZE        :  out std_logic_vector(REQ_SIZE_BITS      -1 downto 0);
        REQ_BUF_PTR     :  out std_logic_vector(BUF_DEPTH          -1 downto 0);
        REQ_MODE        :  out std_logic_vector(REG_PARAM.MODE_BITS-1 downto 0);
        REQ_FIRST       :  out std_logic;
        REQ_LAST        :  out std_logic;
        REQ_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transaction Command Acknowledge Signals.
    -------------------------------------------------------------------------------
        ACK_VALID       :  in  std_logic;
        ACK_SIZE        :  in  std_logic_vector(BUF_DEPTH             downto 0);
        ACK_ERROR       :  in  std_logic := '0';
        ACK_NEXT        :  in  std_logic;
        ACK_LAST        :  in  std_logic;
        ACK_STOP        :  in  std_logic;
        ACK_NONE        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transfer Status Signals.
    -------------------------------------------------------------------------------
        XFER_BUSY       :  in  std_logic;
        XFER_DONE       :  in  std_logic;
        XFER_ERROR      :  in  std_logic := '0';
    -------------------------------------------------------------------------------
    -- Intake Flow Control Signals.
    -------------------------------------------------------------------------------
        FLOW_READY      :  out std_logic;
        FLOW_PAUSE      :  out std_logic;
        FLOW_STOP       :  out std_logic;
        FLOW_LAST       :  out std_logic;
        FLOW_SIZE       :  out std_logic_vector(BUF_DEPTH             downto 0);
        PUSH_FIN_VALID  :  in  std_logic;
        PUSH_FIN_LAST   :  in  std_logic;
        PUSH_FIN_ERROR  :  in  std_logic := '0';
        PUSH_FIN_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PUSH_BUF_RESET  :  in  std_logic;
        PUSH_BUF_VALID  :  in  std_logic;
        PUSH_BUF_LAST   :  in  std_logic;
        PUSH_BUF_ERROR  :  in  std_logic := '0';
        PUSH_BUF_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PUSH_BUF_READY  :  out std_logic;
    -------------------------------------------------------------------------------
    -- Buffer Interface Signals.
    -------------------------------------------------------------------------------
        BUF_WEN         :  in  std_logic;
        BUF_BEN         :  in  std_logic_vector(BUF_DATA_BITS/8    -1 downto 0);
        BUF_DATA        :  in  std_logic_vector(BUF_DATA_BITS      -1 downto 0);
        BUF_PTR         :  in  std_logic_vector(BUF_DEPTH             downto 0);
    -------------------------------------------------------------------------------
    -- Stream Outlet Signals.
    -------------------------------------------------------------------------------
        STM_DATA        :  out std_logic_vector(STM_NUM*STM_DATA_BITS  -1 downto 0);
        STM_STRB        :  out std_logic_vector(STM_NUM*STM_DATA_BITS/8-1 downto 0);
        STM_LAST        :  out std_logic;
        STM_VALID       :  out std_logic;
        STM_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Status Output.
    -------------------------------------------------------------------------------
        BUSY            :  out std_logic;
        DONE            :  out std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief ArgSort_Writer                                                        --
-----------------------------------------------------------------------------------
component ArgSort_Writer
    generic (
        REG_PARAM       :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        REQ_ADDR_BITS   :  integer := 32;
        REQ_SIZE_BITS   :  integer := 32;
        BUF_DATA_BITS   :  integer := 64;
        BUF_DEPTH       :  integer := 13;
        MAX_XFER_SIZE   :  integer := 12;
        STM_NUM         :  integer :=  1;
        STM_DATA_BITS   :  integer := 64;
        STM_INDEX_LO    :  integer :=  0;
        STM_INDEX_HI    :  integer := 31;
        STM_COMP_LO     :  integer := 32;
        STM_COMP_HI     :  integer := 63
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_L           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_D           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_Q           :  out std_logic_vector(REG_PARAM.BITS     -1 downto 0);
    -------------------------------------------------------------------------------
    -- Transaction Command Request Signals.
    -------------------------------------------------------------------------------
        REQ_VALID       :  out std_logic;
        REQ_ADDR        :  out std_logic_vector(REQ_ADDR_BITS      -1 downto 0);
        REQ_SIZE        :  out std_logic_vector(REQ_SIZE_BITS      -1 downto 0);
        REQ_BUF_PTR     :  out std_logic_vector(BUF_DEPTH          -1 downto 0);
        REQ_MODE        :  out std_logic_vector(REG_PARAM.MODE_BITS-1 downto 0);
        REQ_FIRST       :  out std_logic;
        REQ_LAST        :  out std_logic;
        REQ_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transaction Command Acknowledge Signals.
    -------------------------------------------------------------------------------
        ACK_VALID       :  in  std_logic;
        ACK_SIZE        :  in  std_logic_vector(BUF_DEPTH             downto 0);
        ACK_ERROR       :  in  std_logic := '0';
        ACK_NEXT        :  in  std_logic;
        ACK_LAST        :  in  std_logic;
        ACK_STOP        :  in  std_logic;
        ACK_NONE        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transfer Status Signals.
    -------------------------------------------------------------------------------
        XFER_BUSY       :  in  std_logic;
        XFER_DONE       :  in  std_logic;
        XFER_ERROR      :  in  std_logic := '0';
    -------------------------------------------------------------------------------
    -- Intake Flow Control Signals.
    -------------------------------------------------------------------------------
        FLOW_READY      :  out std_logic;
        FLOW_PAUSE      :  out std_logic;
        FLOW_STOP       :  out std_logic;
        FLOW_LAST       :  out std_logic;
        FLOW_SIZE       :  out std_logic_vector(BUF_DEPTH             downto 0);
        PULL_FIN_VALID  :  in  std_logic;
        PULL_FIN_LAST   :  in  std_logic;
        PULL_FIN_ERROR  :  in  std_logic := '0';
        PULL_FIN_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PULL_BUF_RESET  :  in  std_logic;
        PULL_BUF_VALID  :  in  std_logic;
        PULL_BUF_LAST   :  in  std_logic;
        PULL_BUF_ERROR  :  in  std_logic := '0';
        PULL_BUF_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PULL_BUF_READY  :  out std_logic;
    -------------------------------------------------------------------------------
    -- Buffer Interface Signals.
    -------------------------------------------------------------------------------
        BUF_REN         :  in  std_logic_vector;
        BUF_DATA        :  out std_logic_vector(BUF_DATA_BITS      -1 downto 0);
        BUF_PTR         :  in  std_logic_vector(BUF_DEPTH          -1 downto 0);
    -------------------------------------------------------------------------------
    -- Merge Outlet Signals.
    -------------------------------------------------------------------------------
        STM_DATA        :  in  std_logic_vector(STM_NUM*STM_DATA_BITS  -1 downto 0);
        STM_STRB        :  in  std_logic_vector(STM_NUM*STM_DATA_BITS/8-1 downto 0);
        STM_LAST        :  in  std_logic;
        STM_VALID       :  in  std_logic;
        STM_READY       :  out std_logic;
    -------------------------------------------------------------------------------
    -- Status Output.
    -------------------------------------------------------------------------------
        BUSY            :  out std_logic;
        DONE            :  out std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_AXI_Reader                                                      --
-----------------------------------------------------------------------------------
component Merge_AXI_Reader
    generic (
        IN_NUM          :  integer :=  8;
        REG_PARAM       :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        AXI_ID          :  integer :=  1;
        AXI_ID_WIDTH    :  integer :=  8;
        AXI_AUSER_WIDTH :  integer :=  4;
        AXI_ADDR_WIDTH  :  integer := 32;
        AXI_DATA_WIDTH  :  integer := 64;
        MAX_XFER_SIZE   :  integer := 12;
        MRG_DATA_BITS   :  integer := 64
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_L           :  in  std_logic_vector(REG_PARAM.BITS  -1 downto 0);
        REG_D           :  in  std_logic_vector(REG_PARAM.BITS  -1 downto 0);
        REG_Q           :  out std_logic_vector(REG_PARAM.BITS  -1 downto 0);
    -------------------------------------------------------------------------------
    -- AXI Master Read Address Channel Signals.
    -------------------------------------------------------------------------------
        AXI_ARID        :  out std_logic_vector(AXI_ID_WIDTH    -1 downto 0);
        AXI_ARADDR      :  out std_logic_vector(AXI_ADDR_WIDTH  -1 downto 0);
        AXI_ARLEN       :  out std_logic_vector(7 downto 0);
        AXI_ARSIZE      :  out std_logic_vector(2 downto 0);
        AXI_ARBURST     :  out std_logic_vector(1 downto 0);
        AXI_ARLOCK      :  out std_logic_vector(0 downto 0);
        AXI_ARCACHE     :  out std_logic_vector(3 downto 0);
        AXI_ARPROT      :  out std_logic_vector(2 downto 0);
        AXI_ARQOS       :  out std_logic_vector(3 downto 0);
        AXI_ARREGION    :  out std_logic_vector(3 downto 0);
        AXI_ARUSER      :  out std_logic_vector(AXI_AUSER_WIDTH -1 downto 0);
        AXI_ARVALID     :  out std_logic;
        AXI_ARREADY     :  in  std_logic;
    -------------------------------------------------------------------------------
    -- AXI Master Read Data Channel Signals.
    -------------------------------------------------------------------------------
        AXI_RID         :  in  std_logic_vector(AXI_ID_WIDTH    -1 downto 0);
        AXI_RDATA       :  in  std_logic_vector(AXI_DATA_WIDTH  -1 downto 0);
        AXI_RRESP       :  in  std_logic_vector(1 downto 0);
        AXI_RLAST       :  in  std_logic;
        AXI_RVALID      :  in  std_logic;
        AXI_RREADY      :  out std_logic;
    -------------------------------------------------------------------------------
    -- Merge Outlet Signals.
    -------------------------------------------------------------------------------
        MRG_DATA        :  out std_logic_vector(IN_NUM*MRG_DATA_BITS -1 downto 0);
        MRG_NONE        :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_EBLK        :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_LAST        :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_VALID       :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_READY       :  in  std_logic_vector(IN_NUM               -1 downto 0);
        MRG_LEVEL       :  in  std_logic_vector(IN_NUM               -1 downto 0);
    -------------------------------------------------------------------------------
    -- Intake Status Output.
    -------------------------------------------------------------------------------
        I_OPEN          :  out std_logic_vector(IN_NUM               -1 downto 0);
        I_RUNNING       :  out std_logic_vector(IN_NUM               -1 downto 0);
        I_DONE          :  out std_logic_vector(IN_NUM               -1 downto 0);
        I_ERROR         :  out std_logic_vector(IN_NUM               -1 downto 0);
    -------------------------------------------------------------------------------
    -- Outlet Status Output.
    -------------------------------------------------------------------------------
        O_OPEN          :  out std_logic_vector(IN_NUM               -1 downto 0);
        O_RUNNING       :  out std_logic_vector(IN_NUM               -1 downto 0);
        O_DONE          :  out std_logic_vector(IN_NUM               -1 downto 0);
        O_ERROR         :  out std_logic_vector(IN_NUM               -1 downto 0)
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_AXI_Writer                                                      --
-----------------------------------------------------------------------------------
component Merge_AXI_Writer
    generic (
        REG_PARAM       :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        AXI_ID          :  integer :=  1;
        AXI_ID_WIDTH    :  integer :=  8;
        AXI_AUSER_WIDTH :  integer :=  4;
        AXI_WUSER_WIDTH :  integer :=  4;
        AXI_BUSER_WIDTH :  integer :=  4;
        AXI_ADDR_WIDTH  :  integer := 32;
        AXI_DATA_WIDTH  :  integer := 64;
        MAX_XFER_SIZE   :  integer := 12;
        MRG_NUM         :  integer :=  1;
        MRG_DATA_BITS   :  integer := 64
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_L           :  in  std_logic_vector(REG_PARAM.BITS  -1 downto 0);
        REG_D           :  in  std_logic_vector(REG_PARAM.BITS  -1 downto 0);
        REG_Q           :  out std_logic_vector(REG_PARAM.BITS  -1 downto 0);
    -------------------------------------------------------------------------------
    -- AXI Master Writer Address Channel Signals.
    -------------------------------------------------------------------------------
        AXI_AWID        :  out std_logic_vector(AXI_ID_WIDTH    -1 downto 0);
        AXI_AWADDR      :  out std_logic_vector(AXI_ADDR_WIDTH  -1 downto 0);
        AXI_AWLEN       :  out std_logic_vector(7 downto 0);
        AXI_AWSIZE      :  out std_logic_vector(2 downto 0);
        AXI_AWBURST     :  out std_logic_vector(1 downto 0);
        AXI_AWLOCK      :  out std_logic_vector(0 downto 0);
        AXI_AWCACHE     :  out std_logic_vector(3 downto 0);
        AXI_AWPROT      :  out std_logic_vector(2 downto 0);
        AXI_AWQOS       :  out std_logic_vector(3 downto 0);
        AXI_AWREGION    :  out std_logic_vector(3 downto 0);
        AXI_AWUSER      :  out std_logic_vector(AXI_AUSER_WIDTH -1 downto 0);
        AXI_AWVALID     :  out std_logic;
        AXI_AWREADY     :  in  std_logic;
    ------------------------------------------------------------------------------
    -- AXI Master Write Data Channel Signals.
    ------------------------------------------------------------------------------
        AXI_WID         :  out std_logic_vector(AXI_ID_WIDTH    -1 downto 0);
        AXI_WDATA       :  out std_logic_vector(AXI_DATA_WIDTH  -1 downto 0);
        AXI_WSTRB       :  out std_logic_vector(AXI_DATA_WIDTH/8-1 downto 0);
        AXI_WUSER       :  out std_logic_vector(AXI_WUSER_WIDTH -1 downto 0);
        AXI_WLAST       :  out std_logic;
        AXI_WVALID      :  out std_logic;
        AXI_WREADY      :  in  std_logic;
    ------------------------------------------------------------------------------
    -- AXI Write Response Channel Signals.
    ------------------------------------------------------------------------------
        AXI_BID         :  in  std_logic_vector(AXI_ID_WIDTH    -1 downto 0);
        AXI_BRESP       :  in  std_logic_vector(1 downto 0);
        AXI_BUSER       :  in  std_logic_vector(AXI_BUSER_WIDTH -1 downto 0);
        AXI_BVALID      :  in  std_logic;
        AXI_BREADY      :  out std_logic;
    -------------------------------------------------------------------------------
    -- Merge Intake Signals.
    -------------------------------------------------------------------------------
        MRG_DATA        :  in  std_logic_vector(MRG_NUM*MRG_DATA_BITS  -1 downto 0);
        MRG_STRB        :  in  std_logic_vector(MRG_NUM*MRG_DATA_BITS/8-1 downto 0);
        MRG_LAST        :  in  std_logic;
        MRG_VALID       :  in  std_logic;
        MRG_READY       :  out std_logic;
    -------------------------------------------------------------------------------
    -- Status Output.
    -------------------------------------------------------------------------------
        BUSY            :  out std_logic;
        DONE            :  out std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief ArgSort_AXI_Reader                                                    --
-----------------------------------------------------------------------------------
component ArgSort_AXI_Reader
    generic (
        REG_PARAM       :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        AXI_ID          :  integer :=  1;
        AXI_ID_WIDTH    :  integer :=  8;
        AXI_AUSER_WIDTH :  integer :=  4;
        AXI_ADDR_WIDTH  :  integer := 32;
        AXI_DATA_WIDTH  :  integer := 64;
        MAX_XFER_SIZE   :  integer := 12;
        STM_NUM         :  integer :=  1;
        STM_DATA_BITS   :  integer := 64;
        STM_INDEX_LO    :  integer :=  0;
        STM_INDEX_HI    :  integer := 31;
        STM_COMP_LO     :  integer := 32;
        STM_COMP_HI     :  integer := 63
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_L           :  in  std_logic_vector(REG_PARAM.BITS  -1 downto 0);
        REG_D           :  in  std_logic_vector(REG_PARAM.BITS  -1 downto 0);
        REG_Q           :  out std_logic_vector(REG_PARAM.BITS  -1 downto 0);
    -------------------------------------------------------------------------------
    -- AXI Master Read Address Channel Signals.
    -------------------------------------------------------------------------------
        AXI_ARID        :  out std_logic_vector(AXI_ID_WIDTH    -1 downto 0);
        AXI_ARADDR      :  out std_logic_vector(AXI_ADDR_WIDTH  -1 downto 0);
        AXI_ARLEN       :  out std_logic_vector(7 downto 0);
        AXI_ARSIZE      :  out std_logic_vector(2 downto 0);
        AXI_ARBURST     :  out std_logic_vector(1 downto 0);
        AXI_ARLOCK      :  out std_logic_vector(0 downto 0);
        AXI_ARCACHE     :  out std_logic_vector(3 downto 0);
        AXI_ARPROT      :  out std_logic_vector(2 downto 0);
        AXI_ARQOS       :  out std_logic_vector(3 downto 0);
        AXI_ARREGION    :  out std_logic_vector(3 downto 0);
        AXI_ARUSER      :  out std_logic_vector(AXI_AUSER_WIDTH -1 downto 0);
        AXI_ARVALID     :  out std_logic;
        AXI_ARREADY     :  in  std_logic;
    -------------------------------------------------------------------------------
    -- AXI Master Read Data Channel Signals.
    -------------------------------------------------------------------------------
        AXI_RID         :  in  std_logic_vector(AXI_ID_WIDTH    -1 downto 0);
        AXI_RDATA       :  in  std_logic_vector(AXI_DATA_WIDTH  -1 downto 0);
        AXI_RRESP       :  in  std_logic_vector(1 downto 0);
        AXI_RLAST       :  in  std_logic;
        AXI_RVALID      :  in  std_logic;
        AXI_RREADY      :  out std_logic;
    -------------------------------------------------------------------------------
    -- Stream Outlet Signals.
    -------------------------------------------------------------------------------
        STM_DATA        :  out std_logic_vector(STM_NUM*STM_DATA_BITS  -1 downto 0);
        STM_STRB        :  out std_logic_vector(STM_NUM*STM_DATA_BITS/8-1 downto 0);
        STM_LAST        :  out std_logic;
        STM_VALID       :  out std_logic;
        STM_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Status Output.
    -------------------------------------------------------------------------------
        BUSY            :  out std_logic;
        DONE            :  out std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief ArgSort_AXI_Writer                                                    --
-----------------------------------------------------------------------------------
component ArgSort_AXI_Writer
    generic (
        REG_PARAM       :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        AXI_ID          :  integer :=  1;
        AXI_ID_WIDTH    :  integer :=  8;
        AXI_AUSER_WIDTH :  integer :=  4;
        AXI_WUSER_WIDTH :  integer :=  4;
        AXI_BUSER_WIDTH :  integer :=  4;
        AXI_ADDR_WIDTH  :  integer := 32;
        AXI_DATA_WIDTH  :  integer := 64;
        MAX_XFER_SIZE   :  integer := 12;
        STM_NUM         :  integer :=  1;
        STM_DATA_BITS   :  integer := 64;
        STM_INDEX_LO    :  integer :=  0;
        STM_INDEX_HI    :  integer := 31;
        STM_COMP_LO     :  integer := 32;
        STM_COMP_HI     :  integer := 63
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_L           :  in  std_logic_vector(REG_PARAM.BITS  -1 downto 0);
        REG_D           :  in  std_logic_vector(REG_PARAM.BITS  -1 downto 0);
        REG_Q           :  out std_logic_vector(REG_PARAM.BITS  -1 downto 0);
    -------------------------------------------------------------------------------
    -- AXI Master Writer Address Channel Signals.
    -------------------------------------------------------------------------------
        AXI_AWID        :  out std_logic_vector(AXI_ID_WIDTH    -1 downto 0);
        AXI_AWADDR      :  out std_logic_vector(AXI_ADDR_WIDTH  -1 downto 0);
        AXI_AWLEN       :  out std_logic_vector(7 downto 0);
        AXI_AWSIZE      :  out std_logic_vector(2 downto 0);
        AXI_AWBURST     :  out std_logic_vector(1 downto 0);
        AXI_AWLOCK      :  out std_logic_vector(0 downto 0);
        AXI_AWCACHE     :  out std_logic_vector(3 downto 0);
        AXI_AWPROT      :  out std_logic_vector(2 downto 0);
        AXI_AWQOS       :  out std_logic_vector(3 downto 0);
        AXI_AWREGION    :  out std_logic_vector(3 downto 0);
        AXI_AWUSER      :  out std_logic_vector(AXI_AUSER_WIDTH -1 downto 0);
        AXI_AWVALID     :  out std_logic;
        AXI_AWREADY     :  in  std_logic;
    ------------------------------------------------------------------------------
    -- AXI Master Write Data Channel Signals.
    ------------------------------------------------------------------------------
        AXI_WID         :  out std_logic_vector(AXI_ID_WIDTH    -1 downto 0);
        AXI_WDATA       :  out std_logic_vector(AXI_DATA_WIDTH  -1 downto 0);
        AXI_WSTRB       :  out std_logic_vector(AXI_DATA_WIDTH/8-1 downto 0);
        AXI_WUSER       :  out std_logic_vector(AXI_WUSER_WIDTH -1 downto 0);
        AXI_WLAST       :  out std_logic;
        AXI_WVALID      :  out std_logic;
        AXI_WREADY      :  in  std_logic;
    ------------------------------------------------------------------------------
    -- AXI Write Response Channel Signals.
    ------------------------------------------------------------------------------
        AXI_BID         :  in  std_logic_vector(AXI_ID_WIDTH    -1 downto 0);
        AXI_BRESP       :  in  std_logic_vector(1 downto 0);
        AXI_BUSER       :  in  std_logic_vector(AXI_BUSER_WIDTH -1 downto 0);
        AXI_BVALID      :  in  std_logic;
        AXI_BREADY      :  out std_logic;
    -------------------------------------------------------------------------------
    -- Merge Outlet Signals.
    -------------------------------------------------------------------------------
        STM_DATA        :  in  std_logic_vector(STM_NUM*STM_DATA_BITS  -1 downto 0);
        STM_STRB        :  in  std_logic_vector(STM_NUM*STM_DATA_BITS/8-1 downto 0);
        STM_LAST        :  in  std_logic;
        STM_VALID       :  in  std_logic;
        STM_READY       :  out std_logic;
    -------------------------------------------------------------------------------
    -- Status Output.
    -------------------------------------------------------------------------------
        BUSY            :  out std_logic;
        DONE            :  out std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Interface_Controller                                                  --
-----------------------------------------------------------------------------------
component Interface_Controller
    generic (
        MRG_RD_NUM          :  integer :=    8;
        STM_FEEDBACK        :  integer :=    1;
        STM_RD_DATA_BITS    :  integer :=   32;
        STM_WR_DATA_BITS    :  integer :=   32;
        MRG_RW_DATA_BITS    :  integer :=   64;
        REG_ADDR_BITS       :  integer :=   64;
        REG_SIZE_BITS       :  integer :=   32;
        REG_MODE_BITS       :  integer :=   32;
        MRG_RD_REG_PARAM    :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        MRG_WR_REG_PARAM    :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        STM_RD_REG_PARAM    :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        STM_WR_REG_PARAM    :  Interface.Regs_Field_Type := Interface.Default_Regs_Param
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK                 :  in  std_logic;
        RST                 :  in  std_logic;
        CLR                 :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_RD_ADDR_L       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_RD_ADDR_D       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_RD_ADDR_Q       :  out std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_L       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_D       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_Q       :  out std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_L       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_D       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_Q       :  out std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_L       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_D       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_Q       :  out std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_SIZE_L          :  in  std_logic_vector(REG_SIZE_BITS-1 downto 0);
        REG_SIZE_D          :  in  std_logic_vector(REG_SIZE_BITS-1 downto 0);
        REG_SIZE_Q          :  out std_logic_vector(REG_SIZE_BITS-1 downto 0);
        REG_RD_MODE_L       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_RD_MODE_D       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_RD_MODE_Q       :  out std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_WR_MODE_L       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_WR_MODE_D       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_WR_MODE_Q       :  out std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T0_MODE_L       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T0_MODE_D       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T0_MODE_Q       :  out std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T1_MODE_L       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T1_MODE_D       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T1_MODE_Q       :  out std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_START_L         :  in  std_logic;
        REG_START_D         :  in  std_logic;
        REG_START_Q         :  out std_logic;
        REG_RESET_L         :  in  std_logic;
        REG_RESET_D         :  in  std_logic;
        REG_RESET_Q         :  out std_logic;
    -------------------------------------------------------------------------------
    -- Merge Sorter Core Control Interface
    -------------------------------------------------------------------------------
        STM_REQ_VALID       :  out std_logic;
        STM_REQ_READY       :  in  std_logic;
        STM_RES_VALID       :  in  std_logic;
        STM_RES_READY       :  out std_logic;
        MRG_REQ_VALID       :  out std_logic;
        MRG_REQ_READY       :  in  std_logic;
        MRG_RES_VALID       :  in  std_logic;
        MRG_RES_READY       :  out std_logic;
    -------------------------------------------------------------------------------
    -- Stream Reader Control Register Interface
    -------------------------------------------------------------------------------
        STM_RD_REG_L        :  out std_logic_vector(           STM_RD_REG_PARAM.BITS-1 downto 0);
        STM_RD_REG_D        :  out std_logic_vector(           STM_RD_REG_PARAM.BITS-1 downto 0);
        STM_RD_REG_Q        :  in  std_logic_vector(           STM_RD_REG_PARAM.BITS-1 downto 0);
        STM_RD_BUSY         :  in  std_logic;
        STM_RD_DONE         :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Stream Writer Control Register Interface
    -------------------------------------------------------------------------------
        STM_WR_REG_L        :  out std_logic_vector(           STM_WR_REG_PARAM.BITS-1 downto 0);
        STM_WR_REG_D        :  out std_logic_vector(           STM_WR_REG_PARAM.BITS-1 downto 0);
        STM_WR_REG_Q        :  in  std_logic_vector(           STM_WR_REG_PARAM.BITS-1 downto 0);
        STM_WR_BUSY         :  in  std_logic;
        STM_WR_DONE         :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Merge Reader Control Register Interface
    -------------------------------------------------------------------------------
        MRG_RD_REG_L        :  out std_logic_vector(MRG_RD_NUM*MRG_RD_REG_PARAM.BITS-1 downto 0);
        MRG_RD_REG_D        :  out std_logic_vector(MRG_RD_NUM*MRG_RD_REG_PARAM.BITS-1 downto 0);
        MRG_RD_REG_Q        :  in  std_logic_vector(MRG_RD_NUM*MRG_RD_REG_PARAM.BITS-1 downto 0);
        MRG_RD_BUSY         :  in  std_logic_vector(MRG_RD_NUM                      -1 downto 0);
        MRG_RD_DONE         :  in  std_logic_vector(MRG_RD_NUM                      -1 downto 0);
    -------------------------------------------------------------------------------
    -- Merge Writer Control Register Interface
    -------------------------------------------------------------------------------
        MRG_WR_REG_L        :  out std_logic_vector(           MRG_WR_REG_PARAM.BITS-1 downto 0);
        MRG_WR_REG_D        :  out std_logic_vector(           MRG_WR_REG_PARAM.BITS-1 downto 0);
        MRG_WR_REG_Q        :  in  std_logic_vector(           MRG_WR_REG_PARAM.BITS-1 downto 0);
        MRG_WR_BUSY         :  in  std_logic;
        MRG_WR_DONE         :  in  std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief ArgSort_AXI_Interface                                                 --
-----------------------------------------------------------------------------------
component ArgSort_AXI_Interface
    generic (
        MRG_AXI_ID          :  integer :=    1;
        MRG_AXI_ID_WIDTH    :  integer :=    8;
        MRG_AXI_AUSER_WIDTH :  integer :=    4;
        MRG_AXI_ADDR_WIDTH  :  integer :=   32;
        MRG_AXI_DATA_WIDTH  :  integer :=   64;
        MRG_MAX_XFER_SIZE   :  integer :=   12;
        STM_AXI_ID          :  integer :=    1;
        STM_AXI_ID_WIDTH    :  integer :=    8;
        STM_AXI_AUSER_WIDTH :  integer :=    4;
        STM_AXI_WUSER_WIDTH :  integer :=    4;
        STM_AXI_BUSER_WIDTH :  integer :=    4;
        STM_AXI_ADDR_WIDTH  :  integer :=   32;
        STM_AXI_DATA_WIDTH  :  integer :=   64;
        STM_MAX_XFER_SIZE   :  integer :=   12;
        MRG_IN_NUM          :  integer :=    8;
        MRG_WR_NUM          :  integer :=    8;
        MRG_DATA_BITS       :  integer :=   64;
        STM_FEEDBACK        :  integer :=    1;
        STM_RD_NUM          :  integer :=    1;
        STM_RD_DATA_BITS    :  integer :=   64;
        STM_WR_NUM          :  integer :=    1;
        STM_WR_DATA_BITS    :  integer :=   64;
        STM_INDEX_LO        :  integer :=    0;
        STM_INDEX_HI        :  integer :=   31;
        STM_COMP_LO         :  integer :=   32;
        STM_COMP_HI         :  integer :=   63
        REG_ADDR_BITS       :  integer :=   64;
        REG_SIZE_BITS       :  integer :=   32;
        REG_MODE_BITS       :  integer :=   32
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK                 :  in  std_logic;
        RST                 :  in  std_logic;
        CLR                 :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_RD_ADDR_L       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_RD_ADDR_D       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_RD_ADDR_Q       :  out std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_L       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_D       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_Q       :  out std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_L       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_D       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_Q       :  out std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_L       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_D       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_Q       :  out std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_SIZE_L          :  in  std_logic_vector(REG_SIZE_BITS-1 downto 0);
        REG_SIZE_D          :  in  std_logic_vector(REG_SIZE_BITS-1 downto 0);
        REG_SIZE_Q          :  out std_logic_vector(REG_SIZE_BITS-1 downto 0);
        REG_RD_MODE_L       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_RD_MODE_D       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_RD_MODE_Q       :  out std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_WR_MODE_L       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_WR_MODE_D       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_WR_MODE_Q       :  out std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T0_MODE_L       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T0_MODE_D       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T0_MODE_Q       :  out std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T1_MODE_L       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T1_MODE_D       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T1_MODE_Q       :  out std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_START_L         :  in  std_logic;
        REG_START_D         :  in  std_logic;
        REG_START_Q         :  out std_logic;
        REG_RESET_L         :  in  std_logic;
        REG_RESET_D         :  in  std_logic;
        REG_RESET_Q         :  out std_logic;
    -------------------------------------------------------------------------------
    -- Stream AXI Master Read Address Channel Signals.
    -------------------------------------------------------------------------------
        STM_AXI_ARID        :  out std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_ARADDR      :  out std_logic_vector(STM_AXI_ADDR_WIDTH  -1 downto 0);
        STM_AXI_ARLEN       :  out std_logic_vector(7 downto 0);
        STM_AXI_ARSIZE      :  out std_logic_vector(2 downto 0);
        STM_AXI_ARBURST     :  out std_logic_vector(1 downto 0);
        STM_AXI_ARLOCK      :  out std_logic_vector(0 downto 0);
        STM_AXI_ARCACHE     :  out std_logic_vector(3 downto 0);
        STM_AXI_ARPROT      :  out std_logic_vector(2 downto 0);
        STM_AXI_ARQOS       :  out std_logic_vector(3 downto 0);
        STM_AXI_ARREGION    :  out std_logic_vector(3 downto 0);
        STM_AXI_ARUSER      :  out std_logic_vector(STM_AXI_AUSER_WIDTH -1 downto 0);
        STM_AXI_ARVALID     :  out std_logic;
        STM_AXI_ARREADY     :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Stream AXI Master Read Data Channel Signals.
    -------------------------------------------------------------------------------
        STM_AXI_RID         :  in  std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_RDATA       :  in  std_logic_vector(STM_AXI_DATA_WIDTH  -1 downto 0);
        STM_AXI_RRESP       :  in  std_logic_vector(1 downto 0);
        STM_AXI_RLAST       :  in  std_logic;
        STM_AXI_RVALID      :  in  std_logic;
        STM_AXI_RREADY      :  out std_logic;
    -------------------------------------------------------------------------------
    -- Stream AXI Master Writer Address Channel Signals.
    -------------------------------------------------------------------------------
        STM_AXI_AWID        :  out std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_AWADDR      :  out std_logic_vector(STM_AXI_ADDR_WIDTH  -1 downto 0);
        STM_AXI_AWLEN       :  out std_logic_vector(7 downto 0);
        STM_AXI_AWSIZE      :  out std_logic_vector(2 downto 0);
        STM_AXI_AWBURST     :  out std_logic_vector(1 downto 0);
        STM_AXI_AWLOCK      :  out std_logic_vector(0 downto 0);
        STM_AXI_AWCACHE     :  out std_logic_vector(3 downto 0);
        STM_AXI_AWPROT      :  out std_logic_vector(2 downto 0);
        STM_AXI_AWQOS       :  out std_logic_vector(3 downto 0);
        STM_AXI_AWREGION    :  out std_logic_vector(3 downto 0);
        STM_AXI_AWUSER      :  out std_logic_vector(STM_AXI_AUSER_WIDTH -1 downto 0);
        STM_AXI_AWVALID     :  out std_logic;
        STM_AXI_AWREADY     :  in  std_logic;
    ------------------------------------------------------------------------------
    -- Stream AXI Master Write Data Channel Signals.
    ------------------------------------------------------------------------------
        STM_AXI_WID         :  out std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_WDATA       :  out std_logic_vector(STM_AXI_DATA_WIDTH  -1 downto 0);
        STM_AXI_WSTRB       :  out std_logic_vector(STM_AXI_DATA_WIDTH/8-1 downto 0);
        STM_AXI_WUSER       :  out std_logic_vector(STM_AXI_WUSER_WIDTH -1 downto 0);
        STM_AXI_WLAST       :  out std_logic;
        STM_AXI_WVALID      :  out std_logic;
        STM_AXI_WREADY      :  in  std_logic;
    ------------------------------------------------------------------------------
    -- Stream AXI Write Response Channel Signals.
    ------------------------------------------------------------------------------
        STM_AXI_BID         :  in  std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_BRESP       :  in  std_logic_vector(1 downto 0);
        STM_AXI_BUSER       :  in  std_logic_vector(STM_AXI_BUSER_WIDTH -1 downto 0);
        STM_AXI_BVALID      :  in  std_logic;
        STM_AXI_BREADY      :  out std_logic;
    -------------------------------------------------------------------------------
    -- Stream Reader Outlet Signals.
    -------------------------------------------------------------------------------
        STM_RD_DATA        :  out std_logic_vector(STM_RD_NUM*STM_RD_DATA_BITS  -1 downto 0);
        STM_RD_STRB        :  out std_logic_vector(STM_RD_NUM*STM_RD_DATA_BITS/8-1 downto 0);
        STM_RD_LAST        :  out std_logic;
        STM_RD_VALID       :  out std_logic;
        STM_RD_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Stream Writer Intake Signals.
    -------------------------------------------------------------------------------
        STM_WR_DATA         :  in  std_logic_vector(STM_WR_NUM*STM_WR_DATA_BITS  -1 downto 0);
        STM_WR_STRB         :  in  std_logic_vector(STM_WR_NUM*STM_WR_DATA_BITS/8-1 downto 0);
        STM_WR_LAST         :  in  std_logic;
        STM_WR_VALID        :  in  std_logic;
        STM_WR_READY        :  out std_logic;
    -------------------------------------------------------------------------------
    -- Merge AXI Master Read Address Channel Signals.
    -------------------------------------------------------------------------------
        MRG_AXI_ARID        :  out std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_ARADDR      :  out std_logic_vector(MRG_AXI_ADDR_WIDTH  -1 downto 0);
        MRG_AXI_ARLEN       :  out std_logic_vector(7 downto 0);
        MRG_AXI_ARSIZE      :  out std_logic_vector(2 downto 0);
        MRG_AXI_ARBURST     :  out std_logic_vector(1 downto 0);
        MRG_AXI_ARLOCK      :  out std_logic_vector(0 downto 0);
        MRG_AXI_ARCACHE     :  out std_logic_vector(3 downto 0);
        MRG_AXI_ARPROT      :  out std_logic_vector(2 downto 0);
        MRG_AXI_ARQOS       :  out std_logic_vector(3 downto 0);
        MRG_AXI_ARREGION    :  out std_logic_vector(3 downto 0);
        MRG_AXI_ARUSER      :  out std_logic_vector(AXI_AUSER_WIDTH -1 downto 0);
        MRG_AXI_ARVALID     :  out std_logic;
        MRG_AXI_ARREADY     :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Merge AXI Master Read Data Channel Signals.
    -------------------------------------------------------------------------------
        MRG_AXI_RID         :  in  std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_RDATA       :  in  std_logic_vector(MRG_AXI_DATA_WIDTH  -1 downto 0);
        MRG_AXI_RRESP       :  in  std_logic_vector(1 downto 0);
        MRG_AXI_RLAST       :  in  std_logic;
        MRG_AXI_RVALID      :  in  std_logic;
        MRG_AXI_RREADY      :  out std_logic;
    -------------------------------------------------------------------------------
    -- Merge AXI Master Writer Address Channel Signals.
    -------------------------------------------------------------------------------
        MRG_AXI_AWID        :  out std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_AWADDR      :  out std_logic_vector(MRG_AXI_ADDR_WIDTH  -1 downto 0);
        MRG_AXI_AWLEN       :  out std_logic_vector(7 downto 0);
        MRG_AXI_AWSIZE      :  out std_logic_vector(2 downto 0);
        MRG_AXI_AWBURST     :  out std_logic_vector(1 downto 0);
        MRG_AXI_AWLOCK      :  out std_logic_vector(0 downto 0);
        MRG_AXI_AWCACHE     :  out std_logic_vector(3 downto 0);
        MRG_AXI_AWPROT      :  out std_logic_vector(2 downto 0);
        MRG_AXI_AWQOS       :  out std_logic_vector(3 downto 0);
        MRG_AXI_AWREGION    :  out std_logic_vector(3 downto 0);
        MRG_AXI_AWUSER      :  out std_logic_vector(MRG_AXI_AUSER_WIDTH -1 downto 0);
        MRG_AXI_AWVALID     :  out std_logic;
        MRG_AXI_AWREADY     :  in  std_logic;
    ------------------------------------------------------------------------------
    -- Merge AXI Master Write Data Channel Signals.
    ------------------------------------------------------------------------------
        MRG_AXI_WID         :  out std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_WDATA       :  out std_logic_vector(MRG_AXI_DATA_WIDTH  -1 downto 0);
        MRG_AXI_WSTRB       :  out std_logic_vector(MRG_AXI_DATA_WIDTH/8-1 downto 0);
        MRG_AXI_WUSER       :  out std_logic_vector(MRG_AXI_WUSER_WIDTH -1 downto 0);
        MRG_AXI_WLAST       :  out std_logic;
        MRG_AXI_WVALID      :  out std_logic;
        MRG_AXI_WREADY      :  in  std_logic;
    ------------------------------------------------------------------------------
    -- Merge AXI Write Response Channel Signals.
    ------------------------------------------------------------------------------
        MRG_AXI_BID         :  in  std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_BRESP       :  in  std_logic_vector(1 downto 0);
        MRG_AXI_BUSER       :  in  std_logic_vector(MRG_AXI_BUSER_WIDTH -1 downto 0);
        MRG_AXI_BVALID      :  in  std_logic;
        MRG_AXI_BREADY      :  out std_logic;
    -------------------------------------------------------------------------------
    -- Merge Reader Outlet Signals.
    -------------------------------------------------------------------------------
        MRG_RD_DATA         :  out std_logic_vector(MRG_IN_NUM*MRG_DATA_BITS  -1 downto 0);
        MRG_RD_NONE         :  out std_logic_vector(MRG_IN_NUM                -1 downto 0);
        MRG_RD_EBLK         :  out std_logic_vector(MRG_IN_NUM                -1 downto 0);
        MRG_RD_LAST         :  out std_logic_vector(MRG_IN_NUM                -1 downto 0);
        MRG_RD_VALID        :  out std_logic_vector(MRG_IN_NUM                -1 downto 0);
        MRG_RD_READY        :  in  std_logic_vector(MRG_IN_NUM                -1 downto 0);
        MRG_RD_LEVEL        :  in  std_logic_vector(MRG_IN_NUM                -1 downto 0);
    -------------------------------------------------------------------------------
    -- Merge Writer Intake Signals.
    -------------------------------------------------------------------------------
        MRG_WR_DATA         :  in  std_logic_vector(MRG_WR_NUM*MRG_DATA_BITS  -1 downto 0);
        MRG_WR_STRB         :  in  std_logic_vector(MRG_WR_NUM*MRG_DATA_BITS/8-1 downto 0);
        MRG_WR_LAST         :  in  std_logic;
        MRG_WR_VALID        :  in  std_logic;
        MRG_WR_READY        :  out std_logic;
    -------------------------------------------------------------------------------
    -- Merge Sorter Core Control Interface Signals.
    -------------------------------------------------------------------------------
        STM_REQ_VALID       :  out std_logic;
        STM_REQ_READY       :  in  std_logic;
        STM_RES_VALID       :  in  std_logic;
        STM_RES_READY       :  out std_logic;
        MRG_REQ_VALID       :  out std_logic;
        MRG_REQ_READY       :  in  std_logic;
        MRG_RES_VALID       :  in  std_logic;
        MRG_RES_READY       :  out std_logic;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
        IRQ                 :  out std_logic
    );
end component;
end Interface_Components;
