`timescale 1ns / 1ps

module sync_fifo_tb;

  // Signals
  reg clk;
  reg nrst;
  reg upstr_d_valid;
  reg [32:0] upstr_data;
  wire upstr_d_ready;
  wire downstr_d_valid;
  wire [32:0] downstr_data;
  reg downstr_d_ready;

  // Instantiate DUT
  sync_fifo sync_fifo_inst (
    .clk(clk),
    .nrst(nrst),
    .upstr_d_valid(upstr_d_valid),
    .upstr_data(upstr_data),
    .upstr_d_ready(upstr_d_ready),
    .downstr_d_valid(downstr_d_valid),
    .downstr_data(downstr_data),
    .downstr_d_ready(downstr_d_ready)
  );

  // Clock generation: 100 MHz
  initial clk = 0;
  always #5 clk = ~clk;  // 10 ns period

  // Reset logic
  initial begin
    nrst = 0;
    upstr_d_valid = 0;
    upstr_data = 0;
    downstr_d_ready = 0;
    #20 nrst = 1;  // Deassert reset after 20 ns
  end

  // Writer logic
  initial begin
    // Start after reset
    #30;

    forever begin
      #50
      @(posedge clk);
      upstr_data = $random;
    end
  end
    // Writer logic
  initial begin
    // Start after reset
    #30;
    forever begin
      upstr_d_valid = (1'b1); // Randomize valid signal
      #1500
      upstr_d_valid = (1'b0); // Randomize valid signal
      #2000 ;
    end
  end

  // Reader logic
  initial begin
    // Start slightly delayed
    #40;

    forever begin
      downstr_d_ready = (1'b0); 
      #1450;
      downstr_d_ready = (1'b1);
      #1500;
    end

    downstr_d_ready = 0;
  end

  // Simulation time control

endmodule
