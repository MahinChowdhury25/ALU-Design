library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_alu_4bit is
end tb_alu_4bit;

architecture Behavioral of tb_alu_4bit is
    signal A            : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal B            : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal OP           : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal RESULT       : STD_LOGIC_VECTOR(3 downto 0);
    signal CARRY_BORROW : STD_LOGIC;
    signal ZERO         : STD_LOGIC;

    type slv4_array is array (natural range <>) of STD_LOGIC_VECTOR(3 downto 0);
    type slv3_array is array (natural range <>) of STD_LOGIC_VECTOR(2 downto 0);
    type sl_array is array (natural range <>) of STD_LOGIC;

    constant A_VEC : slv4_array(0 to 10) := (
        "0011", "1111", "0111", "0010", "1100", "1100",
        "1100", "0101", "1001", "1001", "0101"
    );
    constant B_VEC : slv4_array(0 to 10) := (
        "0010", "0001", "0011", "0101", "1010", "1010",
        "1010", "0000", "0000", "0000", "1010"
    );
    constant OP_VEC : slv3_array(0 to 10) := (
        "000", "000", "001", "001", "010", "011",
        "100", "101", "110", "111", "010"
    );
    constant RESULT_VEC : slv4_array(0 to 10) := (
        "0101", "0000", "0100", "1101", "1000", "1110",
        "0110", "1010", "0010", "0100", "0000"
    );
    constant FLAG_VEC : sl_array(0 to 10) := (
        '0', '1', '0', '1', '0', '0', '0', '0', '1', '1', '0'
    );
    constant ZERO_VEC : sl_array(0 to 10) := (
        '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1'
    );
begin
    DUT: entity work.alu_4bit
        port map (
            A => A, B => B, OP => OP,
            RESULT => RESULT, CARRY_BORROW => CARRY_BORROW, ZERO => ZERO
        );

    stimulus: process
    begin
        for i in A_VEC'range loop
            A <= A_VEC(i);
            B <= B_VEC(i);
            OP <= OP_VEC(i);
            wait for 10 ns;

            assert (RESULT = RESULT_VEC(i) and
                    CARRY_BORROW = FLAG_VEC(i) and
                    ZERO = ZERO_VEC(i))
                report "ALU test vector " & integer'image(i) & " failed."
                severity error;
        end loop;

        report "All 11 ALU test vectors completed." severity note;
        wait;
    end process;
end Behavioral;
