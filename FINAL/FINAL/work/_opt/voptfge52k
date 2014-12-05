library verilog;
use verilog.vl_types.all;
entity Hover is
    generic(
        MAX_X           : integer := 12;
        MAX_Y           : integer := 24;
        NUM_BUCKETS     : integer := 4
    );
    port(
        clock           : in     vl_logic;
        y1              : in     vl_logic_vector(15 downto 0);
        y2              : in     vl_logic_vector(15 downto 0);
        reset           : in     vl_logic;
        \on\            : in     vl_logic;
        hover           : out    vl_logic_vector(7 downto 0)
    );
end Hover;
