library verilog;
use verilog.vl_types.all;
entity Initialize_Remote is
    generic(
        TURN_ON         : integer := 1;
        IDLE            : integer := 0
    );
    port(
        clock           : in     vl_logic;
        on_state        : in     vl_logic;
        initial_signal  : out    vl_logic_vector(7 downto 0);
        debug           : out    vl_logic
    );
end Initialize_Remote;
