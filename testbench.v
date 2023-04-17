module tb;
    reg sck = 0;
    reg cs=1;
    wire [63:0] data;
    reg mosi;
    reg unsigned [7:0] i;

    assign data[63:56] = 8'hB5; //команда
    assign data[55:32] = 24'h123456; //адрес
    assign data[31:0] = 32'h789456; //данные

    // initial
    //    forever #10 sck=~sck;

    initial
    begin
        mosi=0;
        #50;
        cs=0;
        for (i=0;i<=63;i=i+1)
            begin 
                mosi=data[63-i];
                #5;
                sck=1;
                #10;
                sck=0;
                #5;
            end
        cs=1;
    end

    initial
    begin
        #5000 $finish;
    end

    initial
    begin
        $dumpfile("spi_dump.vcd");
        $dumpvars(0, tb);
    end

    spi_slave spi0(
        .sck(sck),
        .cs(cs),
        .mosi(mosi)
    );

endmodule