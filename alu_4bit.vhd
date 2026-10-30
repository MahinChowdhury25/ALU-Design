library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_4bit is
    Port (
        A             : in  STD_LOGIC_VECTOR(3 downto 0);
        B             : in  STD_LOGIC_VECTOR(3 downto 0);
        OP            : in  STD_LOGIC_VECTOR(2 downto 0);
        RESULT        : out STD_LOGIC_VECTOR(3 downto 0);
        CARRY_BORROW  : out STD_LOGIC;
        ZERO          : out STD_LOGIC
    );
end alu_4bit;

architecture Behavioral of alu_4bit is
begin
    -- Combinational 4-bit ALU. There is no clock input.
    process (A, B, OP)
        variable temp      : unsigned(4 downto 0);
        variable result_v  : STD_LOGIC_VECTOR(3 downto 0);
        variable flag_v    : STD_LOGIC;
    begin
        temp     := (others => '0');
        result_v := (others => '0');
        flag_v   := '0';

        case OP is
            when "000" =>  -- Addition: A + B
                temp := unsigned('0' & A) + unsigned('0' & B);
                result_v := std_logic_vector(temp(3 downto 0));
                flag_v := temp(4);  -- Carry-out

            when "001" =>  -- Subtraction: A - B
                temp := unsigned('0' & A) - unsigned('0' & B);
                result_v := std_logic_vector(temp(3 downto 0));
                flag_v := temp(4);  -- Borrow flag (1 when A < B)

            when "010" =>  -- Bitwise AND
                result_v := A and B;

            when "011" =>  -- Bitwise OR
                result_v := A or B;

            when "100" =>  -- Bitwise XOR
                result_v := A xor B;

            when "101" =>  -- Bitwise NOT of A
                result_v := not A;

            when "110" =>  -- Logical shift A left by one bit
                result_v := A(2 downto 0) & '0';
                flag_v := A(3);  -- Bit shifted out

            when "111" =>  -- Logical shift A right by one bit
                result_v := '0' & A(3 downto 1);
                flag_v := A(0);  -- Bit shifted out

            when others =>
                result_v := (others => '0');
                flag_v := '0';
        end case;

        RESULT <= result_v;
        CARRY_BORROW <= flag_v;

        if result_v = "0000" then
            ZERO <= '1';
        else
            ZERO <= '0';
        end if;
    end process;
end Behavioral;
