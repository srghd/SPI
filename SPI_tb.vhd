library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SPI_tb is
generic ( N : natural := 16);
--  Port ( );
end SPI_tb;

--Port ( x : in STD_LOGIC;
           --y: in STD_LOGIC;
           --clk : in STD_LOGIC;
           --rst : in STD_LOGIC;
           --s : out STD_LOGIC);

architecture first of SPI_tb is
component SPI_top is
    Port ( clk : in STD_LOGIC; --50MHz
          sclk : in STD_LOGIC; --10MHz
          ssn : in STD_LOGIC; --chip select
          mosi : in STD_LOGIC; --Master Out Slave In  (MOSI)
          miso : out STD_LOGIC; --Master In  Slave Out (MISO)
          rdata : in STD_LOGIC_VECTOR (N-1 downto 0); --Read data
          wdata : out STD_LOGIC_VECTOR (N-1 downto 0); --Write data
          wstrobe : out STD_LOGIC; -- Bit 16: 1 is write and 0 read
          addr : out STD_LOGIC_VECTOR (6 downto 0));
end component;
constant CP: time := 20 ns;
--signal xin_sig, yin_sig, sout_sig, clk_sig, rst_sig: std_logic :='0';
signal clk_sig, sclk_sig, ssn_sig, mosi_sig, miso_sig, wstrobe_sig : std_logic :='0';

signal rdata_sig: std_logic_vector(N-1 downto 0) := "1000001100100001";
signal wdata_sig: std_logic_vector(N-1 downto 0) := (others => '0');
signal addr_sig: std_logic_vector(6 downto 0) := (others => '0');

begin

uuspi: SPI_top port map (clk=> clk_sig, sclk=> sclk_sig, ssn=> ssn_sig, mosi=> mosi_sig, miso=> miso_sig, wstrobe=> wstrobe_sig, rdata=>rdata_sig, wdata=> wdata_sig,addr=> addr_sig );

process
begin
clk_sig <='1';
wait for CP/2;
clk_sig <='0';
wait for CP/2;
end process;

process
begin
ssn_sig <='1';
wait for 300 ns;
ssn_sig <= '0';
wait for 2850 ns;
end process;

process
begin
sclk_sig <='1';
wait for 50ns;
sclk_sig <= '0';
wait for 50ns;
end process;

process
begin
mosi_sig <='0';
wait for 400 ns;
mosi_sig <= '1';
wait for 5*CP;
mosi_sig <= '0';
wait for 5*CP;
mosi_sig <= '1';
wait for 5*CP;
mosi_sig <= '0';
wait for 5*CP;
mosi_sig <= '1';
wait for 5*CP;
mosi_sig <= '0';
wait for 5*CP;
mosi_sig <= '1';
wait for 10*CP;
mosi_sig <= '0';
wait for 5*CP;
mosi_sig <= '1';
wait for 5*CP;
mosi_sig <= '0';
wait for 5*CP;
mosi_sig <= '1';
wait for 10*CP;
mosi_sig <= '0';
wait for 10*CP;
mosi_sig <= '1';
wait for 10*CP;
mosi_sig <= '0';
wait;
end process;

process
begin
rdata_sig <= (others => '0');
wait for 1100 ns;
rdata_sig <= "1000001100100001";
wait;
end process;

end first;
