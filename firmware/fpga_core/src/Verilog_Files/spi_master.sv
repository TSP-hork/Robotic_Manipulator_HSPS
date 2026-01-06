// Generic SPI Master Module (Mode 0: CPOL=0, CPHA=0).
//
// This module implements a full-duplex SPI master interface.
// It is designed to be reusable for various data widths and configurable clock speeds.
//
// Architecture:
// - MSB (Most Significant Bit) First.
// - Generates "done" pulse when transaction completes.


module spi_master #(
    parameter int DATA_WIDTH = 32,  // Number of bits per transaction
    parameter int CLK_DIV    = 13   // Clock divider. F_sck = F_sys / (2 * CLK_DIV)
                                    // Example: 27 MHz / (2 * 13) ~= 1 MHz SPI Clock
                                    // Set CLK_DIV >= 2.
)(
    input  logic                    clk,        // System Clock
    input  logic                    rst_n,      // Active-low Reset

    // --- Control Interface ---
    input  logic                    start,      // Single cycle pulse to start transaction
    input  logic [DATA_WIDTH-1:0]   tx_data,    // Data to transmit (captured on start)
    output logic [DATA_WIDTH-1:0]   rx_data,    // Data received (valid when done = 1)
    output logic                    busy,       // High while transaction is in progress
    output logic                    done,       // Single cycle pulse when finished

    // --- Physical SPI Interface ---
    output logic                    spi_cs_n,   // Chip Select (Active Low)
    output logic                    spi_sck,    // Serial Clock
    output logic                    spi_mosi,   // Master Out Slave In
    input  logic                    spi_miso    // Master In Slave Out
);

    // --- Internal State Registers ---
    logic [DATA_WIDTH-1:0]  shift_reg;       // Main shift register for TX and RX
    logic [15:0]            clk_cnt;         // Counter for clock generation
    logic [7:0]             bit_cnt;         // Counter for remaining bits
    logic                   active;          // Flag: transaction in progress
    logic                   sck_enable;      // Flag: enable sck toggling

    // --- Output Assignments ---
    assign spi_cs_n = ~active;               // Pull CS low when active
    assign spi_mosi = shift_reg[DATA_WIDTH-1]; // Always output the MSB
    assign busy     = active;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            active      <= 1'b0;
            sck_enable  <= 1'b0;
            spi_sck     <= 1'b0;
            shift_reg   <= '0;
            rx_data     <= '0;
            clk_cnt     <= '0;
            bit_cnt     <= '0;
            done        <= 1'b0;
        end else begin
            // Clear one-shot pulse
            done <= 1'b0;

            if (active) begin
                // --- Transaction Logic ---
                if (clk_cnt == (CLK_DIV - 1)) begin
                    // Toggle Clock Edge
                    clk_cnt     <= '0;
                    spi_sck     <= ~spi_sck;

                    if (!spi_sck) begin
                        // --- RISING EDGE (Sample MISO) ---
                        // Mode 0: Data is valid on rising edge
                        // Capture data from slave into the LSB
                        shift_reg[0] <= spi_miso;
                    end else begin
                        // --- FALLING EDGE (Shift Data) ---
                        // Mode 0: Data changes on falling edge
                        if (bit_cnt == 0) begin
                            // Transaction Complete
                            active      <= 1'b0;
                            sck_enable  <= 1'b0;
                            done        <= 1'b1;
                            rx_data     <= shift_reg; // Publish result
                        end else begin
                            // Shift next bit (MSB shift left)
                            // We protect bit 0 here to keep the sampled value valid
                            // until the next rising edge, but typically shift is fine.
                            // Standard shift left:
                            shift_reg <= {shift_reg[DATA_WIDTH-2:0], 1'b0};
                            bit_cnt   <= bit_cnt - 1;
                        end
                    end
                end else begin
                    // Wait for clock divider
                    clk_cnt <= clk_cnt + 1;
                end
            end else begin
                // --- IDLE State ---
                spi_sck <= 1'b0; // Mode 0 Idle Low
                
                if (start) begin
                    // Start Trigger: Load Data, assert CS, reset counters
                    active     <= 1'b1;
                    shift_reg  <= tx_data;
                    bit_cnt    <= DATA_WIDTH - 1;
                    clk_cnt    <= '0;
                    // Note: We don't toggle SCK immediately.
                    // We wait one CLK_DIV period to establish setup time for CS.
                end
            end
        end
    end

endmodule