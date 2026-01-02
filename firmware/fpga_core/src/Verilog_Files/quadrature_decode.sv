module quadrature_decoder (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        a_in,   // Phase A input (Raw, from the leg)
    input  logic        b_in,   // Phase B input (Raw, from the leg)
    output logic [31:0] count   // Result (Step Counter)
);

    // 1. SYNCHRONIZATION (Required!)
    // A signal from the outside world can arrive at the moment of the front of the clock and break the trigger.
    // We run it through 2 triggers in a row to "calm it down".
    logic a_sync, b_sync;
    logic a_r1, b_r1;

    always_ff @(posedge clk) begin
        a_r1 <= a_in;
        b_r1 <= b_in;
        a_sync <= a_r1;
        b_sync <= b_r1;
    end

    // 2. FRONT DETECTOR
    logic [1:0] state, prev_state;
    assign state = {a_sync, b_sync};

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
            prev_state <= 0;
        end else begin
            prev_state <= state;
            
            // Decoding logic (X4 encoding - counting each front)
            case ({prev_state, state})
                // Forward rotation (00->10, 10->11, 11->01, 01->00)
                4'b00_10, 4'b10_11, 4'b11_01, 4'b01_00: count <= count + 1;
                
                // Rotate BACKWARD (00->01, 01->11, 11->10, 10->00)
                4'b00_01, 4'b01_11, 4'b11_10, 4'b10_00: count <= count - 1;
                
                default: ; // or wait
            endcase
        end
    end

endmodule