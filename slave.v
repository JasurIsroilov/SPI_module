module spi_slave (
  input sck,  
  input cs,
  input mosi,

  output reg [7:0] cmd,
  output reg [23:0] address,
  output reg [31:0] data
);

reg enable = 0;
reg mosi_out = 0;
reg unsigned [7:0] i = 0;
reg unsigned [7:0] counter = 0;
 
always @(posedge sck)
begin
   if (~cs)
   begin
      if (i <= 7)
      begin
        cmd[7-i] <= mosi;
      end
      else if (i >= 8 && i <= 31)
      begin
        address[31-i] <= mosi;
      end
      else
      begin
        data[63-i] <= mosi;
      end
      i = i + 1;
      counter = counter + 1;
      if (counter == 64)
        begin
          if (cmd == 8'hB5)
            enable=1;
        end
   end
end

always @(posedge enable)
begin
  if (cmd == 8'hB5)
    begin
      for (i=0;i<=23;i=i+1)
      begin
        mosi_out=address[23-i];
        #10;
      end
      for (i=0;i<=31;i=i+1)
      begin
        mosi_out=data[31-i];
        #10;
      end
      mosi_out=0;
    end
end

always @(posedge cs)
  begin
    counter=0;
    i=0;
  end

endmodule