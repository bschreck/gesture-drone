library verilog;
use verilog.vl_types.all;
entity gest_rec is
    generic(
        MAX_X           : integer := 9;
        MAX_Y           : integer := 9;
        MAX_Z           : integer := 9;
        NO_ROLL         : integer := 0;
        ROLL_LEFT       : integer := 1;
        ROLL_RIGHT      : integer := 2
    );
    port(
        clock           : in     vl_logic;
        x1              : in     vl_logic_vector(15 downto 0);
        y1              : in     vl_logic_vector(15 downto 0);
        z1              : in     vl_logic_vector(15 downto 0);
        x2              : in     vl_logic_vector(15 downto 0);
        y2              : in     vl_logic_vector(15 downto 0);
        z2              : in     vl_logic_vector(15 downto 0);
        reset           : in     vl_logic;
        hover           : out    vl_logic_vector(7 downto 0);
        roll            : out    vl_logic_vector(7 downto 0);
        pitch           : out    vl_logic_vector(7 downto 0);
        \on\            : out    vl_logic
    );
end gest_rec;
