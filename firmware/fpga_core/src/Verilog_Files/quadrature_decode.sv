// ABZ Encoder Decoder with Glitch Filter and Precise Velocity Measurement.
//
// Features:
// - Glitch Filter (removes noise from wires).
// - X4 Decoding (counts every edge of A and B).
// - Index (Z) channel support for homing.
// - Velocity measurement via "Time between pulses" (Period).
// - 32-bit Position Counter.


module quadrature_decoder #(
    parameter int CLK_FREQ = 27_000_000, // System clock frequency
    parameter int FILTER_LEN = 4         // Filter depth (debounce)
)(
    input  logic        clk,
    input  logic        rst_n,
    
    // --- Physical Inputs ---
    input  logic        a_in,   // Phase A
    input  logic        b_in,   // Phase B
    input  logic        z_in,   // Index Z (One pulse per revolution)

    // --- Control Interface ---
    input  logic        set_zero,      // Software command to reset position
    input  logic        homing_mode,   // If 1: Z-pulse will reset position automatically

    // --- Outputs to System Storage ---
    output logic [31:0] position,      // Absolute position (ticks)
    output logic [31:0] period,        // Cycles between last two edges (Inverse Velocity)
    output logic        dir_fwd,       // Direction flag (1 = Forward, 0 = Backward)
    output logic        index_found    // Latch: set to 1 when Z pulse is seen
);

    // --- 1. GLITCH FILTER ---
    // Shift registers to filter noise. Signal must be stable for FILTER_LEN cycles.
    logic [FILTER_LEN-1:0] a_filter, b_filter, z_filter;
    logic a_clean, b_clean, z_clean;

    always_ff @(posedge clk) begin
        a_filter <= {a_filter[FILTER_LEN-2:0], a_in};
        b_filter <= {b_filter[FILTER_LEN-2:0], b_in};
        z_filter <= {z_filter[FILTER_LEN-2:0], z_in};
    end

    // Majority vote or strict stability check. Here: Strict stability.
    // If all bits are 1 -> 1, if all 0 -> 0, else keep previous.
    function automatic logic filter_logic(logic [FILTER_LEN-1:0] hist, logic prev);
        if (&hist) return 1'b1;      // All 1s
        else if (|hist == 1'b0) return 1'b0; // All 0s
        else return prev;            // Noise
    endfunction

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_clean <= 0; b_clean <= 0; z_clean <= 0;
        end else begin
            a_clean <= filter_logic(a_filter, a_clean);
            b_clean <= filter_logic(b_filter, b_clean);
            z_clean <= filter_logic(z_filter, z_clean);
        end
    end

    // --- 2. EDGE DETECTION & DECODING ---
    logic [1:0] current_state, prev_state;
    logic       pulse_event;      // High for 1 cycle on any valid step
    logic       direction;        // 1 = FWD, 0 = BWD (internal)

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            position      <= 0;
            prev_state    <= 0;
            index_found   <= 0;
            pulse_event   <= 0;
            direction     <= 1;
        end else begin
            current_state <= {a_clean, b_clean};
            prev_state    <= current_state;
            pulse_event   <= 0; // Default

            // Software Reset
            if (set_zero) position <= 0;

            // Z-Index Handling
            if (z_clean) begin
                index_found <= 1; // Latch that we saw the index
                if (homing_mode) position <= 0; // Hardware homing
            end

            // Quadrature Logic
            case ({prev_state, current_state})
                // Forward: 00->10, 10->11, 11->01, 01->00
                4'b00_10, 4'b10_11, 4'b11_01, 4'b01_00: begin
                    position    <= position + 1;
                    pulse_event <= 1;
                    direction   <= 1; // Forward
                end
                
                // Backward: 00->01, 01->11, 11->10, 10->00
                4'b00_01, 4'b01_11, 4'b11_10, 4'b10_00: begin
                    position    <= position - 1;
                    pulse_event <= 1;
                    direction   <= 0; // Backward
                end
            endcase
        end
    end

    assign dir_fwd = direction;

    // --- 3. VELOCITY UNIT (Time Stamping) ---
    // Measures the time (clk ticks) between two encoder pulses.
    // If period is small -> High Speed.
    // If period is large -> Low Speed.
    
    logic [31:0] timer_cnt;
    logic [31:0] period_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            timer_cnt  <= 0;
            period_reg <= 32'hFFFFFFFF; // Max value (Speed = 0)
        end else begin
            // Increment timer until max (saturation)
            if (timer_cnt != 32'hFFFFFFFF) begin
                timer_cnt <= timer_cnt + 1;
            end

            if (pulse_event) begin
                // Event happened! Capture time and reset timer.
                period_reg <= timer_cnt;
                timer_cnt  <= 0;
            end
        end
    end

    // Output the period. 
    // Note: STM32 should calculate Velocity = K / period.
    // If timer saturated (motor stopped), period will be Max.
    assign period = period_reg;

endmodule