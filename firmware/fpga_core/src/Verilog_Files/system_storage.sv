module system_storage #(
    parameter AXIS_COUNT = 6 
)(
    input  logic clk,
    input  logic rst_n,
    
    // --- STM32 interface ---
    input  logic        write_en,
    input  logic [7:0]  addr,      
    input  logic [31:0] wdata,
    output logic [31:0] rdata,

    // --- Encoders and PWM interface ---
    
    input  logic [31:0] enc_pos_in    [0 : AXIS_COUNT-1],
    input  logic [31:0] enc_period_in [0 : AXIS_COUNT-1],
    input  logic        enc_dir_in    [0 : AXIS_COUNT-1],
    input  logic        enc_index_in  [0 : AXIS_COUNT-1],

    
    output logic [15:0] pwm_duties  [0 : AXIS_COUNT-1], // 6 duties outputs 
    output logic        enables     [0 : AXIS_COUNT-1]  // 6 enable outputs
);

    // Memory: [Axis Number][Register number]
    // 6 Axis * 4 register 
    logic [31:0] regs [0 : AXIS_COUNT-1][0 : 3]; 

    // adress translate
    logic [3:0] axis_id;
    logic [3:0] reg_id;
    
    assign axis_id = addr[7:4]; // Main 4 bits - axis selection
    assign reg_id  = addr[3:0]; // The lower 4 bits are the parameter selection

    // --- Write ---
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers in all axes by cycle
            for (int i = 0; i < AXIS_COUNT; i++) begin
                regs[i][0] <= 0; // Control
                regs[i][1] <= 0; // PWM Duty
                // ... and other
            end
        end else begin
            if (write_en) begin
                // Checking that the axis ID does not exceed (0..5)
                if (axis_id < AXIS_COUNT) begin
                    // Writing to a specific cell of a specific axis
                    regs[axis_id][reg_id] <= wdata;
                end
            end
        end
    end

    // --- READ ---
    always_comb begin
        rdata = 32'd0;
        if (axis_id < AXIS_COUNT) begin
            case (reg_id)
                
            4'd4: rdata = enc_pos_in[axis_id];    // position
            4'd5: rdata = enc_period_in[axis_id]; // speed
            4'd6: rdata = {30'd0, enc_index_in[axis_id], enc_dir_in[axis_id]}; // status
                
                
                default: rdata = regs[axis_id][reg_id];
            endcase
        end
    end

    // --- GENERATE LOOP ---
    
    generate
        genvar i;
        for (i = 0; i < AXIS_COUNT; i++) begin : wiring_loop
            assign enables[i]    = regs[i][0][0];    // Reg 0, bit 0 -> Enable
            assign pwm_duties[i] = regs[i][1][15:0]; // Reg 1 -> PWM
        end
    endgenerate

endmodule