library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SPI_top is
    generic ( N : natural := 16);
    Port ( clk : in STD_LOGIC; --50MHz
           sclk : in STD_LOGIC; --10MHz
           ssn : in STD_LOGIC; --chip select
           mosi : in STD_LOGIC; --Master Out Slave In  (MOSI)
           miso : out STD_LOGIC; --Master In  Slave Out (MISO)
           rdata : in STD_LOGIC_VECTOR (N-1 downto 0); --Read data
           wdata : out STD_LOGIC_VECTOR (N-1 downto 0); --Write data
           wstrobe : out STD_LOGIC; -- Bit 16: 1 is write and 0 read
           addr : out STD_LOGIC_VECTOR (6 downto 0));
end SPI_top;

architecture first of SPI_top is

	signal regaddr:  std_logic_vector(6 downto 0) := (others => '0');	--Shift register for incoming addr
	signal regdata: std_logic_vector(N-1 downto 0) := (others => '0');	--Shift register for incoming data
	signal regoutdata: std_logic_vector(N-1 downto 0);-- := (others=>'0');	--Shift register for outgoing data
    signal b: std_logic := '0'; --wstrobe bit
    signal c: std_logic := '0'; --wstrobe bit
    signal detect: std_logic := '0';--sclk rising edge detector
    signal spi_clk_reg: std_logic := '0';
    signal counter : unsigned(4 downto 0) :=(others => '0');
begin

rising_edge_detector : process (clk)
    begin
        if (rising_edge(clk)) then
                spi_clk_reg <= sclk;
            end if;
    end process;
    -- Rising edge is detect when sclk=1 and spi_clk_reg=0.
    detect <= not sclk and spi_clk_reg;

bit_counter: process(clk)
begin
    if (rising_edge(clk) and detect='1' and ssn ='0') then
        counter <= counter + 1;
    end if;
end process;

read:
process(clk)

begin

if (rising_edge(clk)) then
    if (ssn = '0') then
        if (detect = '1') then 
            if (counter < 8) then
                regaddr <= regaddr(5 downto 0) & mosi;
            elsif (counter = 8) then
                b <= mosi;
                c <=mosi;
            elsif ((counter>8) and (counter <24)) then
                b<='0';
                regdata <= regdata(N-2 downto 0) & mosi;
            elsif (counter=24) then
            regdata <= regdata(N-2 downto 0) & mosi;
            wstrobe<=c;
            end if; 
        end if;
    end if; 
    else
    wstrobe<='0';
end if;
end process;

addr<= regaddr;
wdata<= regdata;

miso_write:

process(clk)

begin

if (rising_edge(clk)) then
    if (ssn = '0') then
        if (detect = '1') then
            if(b='1') then  
                regoutdata <= rdata;
             else
                miso<=regoutdata(N-1);
                regoutdata <= regoutdata(N-2 downto 0) & '0';
            end if;
        end if;
    else
       miso <= '0';
       regoutdata <= rdata;
    end if; 
end if;

end process;
end first;
