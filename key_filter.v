module key_filter(
    clk,
    rst_n,
    Key,
    Key_R_Flag
    );
    
    input clk;
    input rst_n;
    input Key;
    output reg Key_R_Flag;
    
    reg Key_R_Flag;
        
    reg [1:0]sync_Key;
    always@(posedge clk)
        sync_Key <= {sync_Key[0],Key};
        
    reg [1:0]r_Key;
    always@(posedge clk)
        r_Key <= {r_Key[0],sync_Key[1]};  //位拼接：等效于r_Key[0]<=Key; r_Key[1]<=sync_Key[1];
    
    wire pedge_key;
    assign pedge_key = r_Key == 2'b01;
    wire nedge_key;
    assign nedge_key = r_Key == 2'b10;
    
    reg [19:0]cnt;
        localparam IDLE = 0;
        localparam P_FILTER = 1;
        localparam WAIT_R = 2;
        localparam R_FILTER = 3;
    reg [1:0]state;
    always@(posedge clk or negedge rst_n)
    if(!rst_n)begin
        state      <= 0;
        Key_R_Flag <= 1'b0;
        cnt <= 0;
    end
    else begin
        case(state)
            IDLE:
                begin
                    Key_R_Flag <= 1'b0;
                if(nedge_key)
                    state <= 1;
                else
                    state <= 0;
                end
            P_FILTER:
                if((pedge_key) && (cnt < 1000000 - 1))begin
                    state <= 1;
                    cnt   <= 0;
                end
                else if(cnt >= 1000000 - 1)begin
                    state <= 2;
                    cnt   <= 0;
                end
                else begin
                    cnt <= cnt + 1'b1;
                    state <= 1;
                end
            WAIT_R:
                begin
                if(pedge_key)
                    state <= 3;
                else
                    state <= 2;
                end
            R_FILTER:
                if((nedge_key) && (cnt < 1000000 - 1))begin
                    state <= 2;
                    cnt   <= 0;
                end
                else if(cnt >= 1000000 - 1)begin
                    state      <= 0;
                    cnt        <= 0;
                    Key_R_Flag <= 1'b1;
                end
                else begin
                    cnt <= cnt + 1'b1;
                    state <= 3;
                end
        endcase
    end
    
endmodule
