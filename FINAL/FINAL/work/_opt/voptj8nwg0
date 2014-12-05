library verilog;
use verilog.vl_types.all;
entity Off_FSM is
    generic(
        MAX_X           : integer := 15;
        MAX_Y           : integer := 15
    );
    port(
        clock           : in     vl_logic;
        x1              : in     vl_logic_vector(15 downto 0);
        y1              : in     vl_logic_vector(15 downto 0);
        x2              : in     vl_logic_vector(15 downto 0);
        y2              : in     vl_logic_vector(15 downto 0);
        reset           : in     vl_logic;
        is_off          : out    vl_logic
    );
end Off_FSM;
