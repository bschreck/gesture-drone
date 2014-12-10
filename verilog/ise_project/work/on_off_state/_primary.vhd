library verilog;
use verilog.vl_types.all;
entity on_off_state is
    generic(
        OFF             : integer := 0;
        \ON\            : integer := 1
    );
    port(
        clock           : in     vl_logic;
        is_on           : in     vl_logic;
        is_off          : in     vl_logic;
        reset           : in     vl_logic;
        on_off_s        : out    vl_logic
    );
end on_off_state;
