
module sync_fifo_tb;

  // Parameters

  //Ports
  reg clk;
  reg nrst;
  reg upstr_d_valid;
  reg [32:0] upstr_data;
  wire upstr_d_ready;
  wire downstr_d_valid;
  wire [32:0] downstr_data;
  reg downstr_d_ready;

  sync_fifo  sync_fifo_inst (
    .clk(clk),
    .nrst(nrst),
    .upstr_d_valid(upstr_d_valid),
    .upstr_data(upstr_data),
    .upstr_d_ready(upstr_d_ready),
    .downstr_d_valid(downstr_d_valid),
    .downstr_data(downstr_data),
    .downstr_d_ready(downstr_d_ready)
  );

always #5  clk = ! clk ;

endmodule