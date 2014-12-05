library verilog;
use verilog.vl_types.all;
entity On_FSM is
    generic(
        MAX_X           : integer := 10;
        MAX_Y           : integer := 10
    );
    port(
        clock           : in     vl_logic;
        x               : in     vl_logic_vector(15 downto 0);
        y               : in     vl_logic_vector(15 downto 0);
        reset           : in     vl_logic;
        is_on           : out    vl_logic;
        on_fsm          : out    vl_logic_vector(3 downto 0)
    );
end On_FSM;
