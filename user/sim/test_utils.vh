`ifndef TEST_UTILS_VH
`define TEST_UTILS_VH

`define PRINT_TEST_HEX(_item_name_, _actual_, _expected_) \
    $display("·\t%s\t%s:\t0x%0h (0x%0h)",((_actual_) === (_expected_)) ? "[PASS] " : "[ERROR]",\
    (_item_name_), (_actual_), (_expected_))
`define PRINT_TEST_BIN(_item_name_, _actual_, _expected_) \
    $display("·\t%s\t%s:\t0b%0b (0b%0b)",((_actual_) === (_expected_)) ? "[PASS] " : "[ERROR]",\
    (_item_name_), (_actual_), (_expected_))
`define PRINT_TEST_DEC(_item_name_, _actual_, _expected_) \
    $display("·\t%s\t%s:\t%0d (%0d)",((_actual_) === (_expected_)) ? "[PASS] " : "[ERROR]",\
    (_item_name_), (_actual_), (_expected_))

/*
    一种用来简化测试程序编写的包含头文件
    下面是 TestBench 文件中推荐的单元测试结果的输出 task
    更具体的实例请见 user/sim/stages/tb_write_back.v
    
    task check_result;
        parameter BUFFER_LEN = 128;
        input [BUFFER_LEN*8-1:0] description;
        begin
            #1;
            $display("Test: %0s (@time: %0t)", description, $time);
    
            // ! >>> 需要修改的部分 开始 >>> !
    
            // PRINT_TEST_HEX 的参数格式是 (单元测试描述，实际输出值，理论上的输出值）
            `PRINT_TEST_HEX("Write Data", write_data, expected_write_data);
            `PRINT_TEST_HEX("rd", rd_out, rd_in);
            `PRINT_TEST_HEX("reg_we", reg_we_out, reg_we_in);
            // 如果有更多的测试项，可以继续添加 `PRINT_TEXT_xxx 宏来增加输出
    
            // ! <<< 需要修改的部分 结束 <<< !
        end
    endtask
*/

`endif // TEST_UTILS_VH
